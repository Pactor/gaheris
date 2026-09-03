using System;
using System.Collections.Generic;
using System.Linq;
using DOL.AI.Brain;
using DOL.Database;
using DOL.Events;
using DOL.GS.PacketHandler;
using DOL.GS.PropertyCalc;
using DOL.GS.RealmAbilities;
using DOL.GS.SkillHandler;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// What a hire does in a fight. A class is a bundle of these rather than a
    /// hand-written brain, so all forty-seven of them share one tested set of
    /// behaviours and a new one costs a single line.
    /// </summary>
    [Flags]
    public enum Duty
    {
        None   = 0,
        Tank   = 1 << 0,   // taunts, and guards whoever would die first
        Melee  = 1 << 1,   // closes and swings
        Archer = 1 << 2,   // shoots, never closes
        Nuke   = 1 << 3,
        PBAoE  = 1 << 4,
        DoT    = 1 << 5,
        Debuff = 1 << 6,
        Heal   = 1 << 7,   // single target, and the group when several are hurt
        Buffs  = 1 << 8,   // strength/constitution, dexterity/quickness, armour
        Bubble = 1 << 9,   // the group damage shield
        Chants = 1 << 10,  // power, endurance and health regeneration, and haste
        CC     = 1 << 11,
        Pet    = 1 << 12,
        Speed  = 1 << 13,
    }

    /// <summary>
    /// How the group is meant to be played. This changes what they actually
    /// do, not just what they say.
    /// </summary>
    public enum Tactic
    {
        /// <summary>Tanks hold, healers heal whoever is worst off. The default.</summary>
        Balanced,

        /// <summary>Everyone stacks on you and the casters favour area damage.</summary>
        PBAoE,

        /// <summary>
        /// Your pet holds everything and the group keeps it standing. Nobody
        /// taunts -- pulling a single mob off your pet is how this one dies.
        /// </summary>
        Focus,
    }

    /// <summary>Where the group stands relative to their employer.</summary>
    public enum Formation
    {
        /// <summary>Spread around you. Everyone reachable, nobody stacked.</summary>
        Circle,

        /// <summary>Abreast behind you. Good for holding a room.</summary>
        Line,

        /// <summary>Single file behind you. For corridors and bridges.</summary>
        Column,

        /// <summary>Melee forward, casters back. For meeting something head on.</summary>
        Wedge,
    }

    /// <summary>One of the game's classes, as something you can hire.</summary>
    public class MercClass
    {
        public string Name;
        public eRealm Realm;
        public ushort Model;
        public Duty Duties;
        public string Blurb;
        public string[] Pets = Array.Empty<string>();

        public string Key => Name.ToLower();

        /// <summary>
        /// The game's own class id, so the real spell lines and styles can be
        /// looked up. Derived from the name, which matches the enum for all but
        /// the three Maulers.
        /// </summary>
        public eCharacterClass ClassId
        {
            get
            {
                switch (Name)
                {
                    case "Mauler":              return eCharacterClass.MaulerAlb;
                    case "Mauler of Midgard":   return eCharacterClass.MaulerMid;
                    case "Mauler of Hibernia":  return eCharacterClass.MaulerHib;
                    default:
                        return Enum.TryParse(Name, out eCharacterClass parsed)
                            ? parsed : eCharacterClass.Unknown;
                }
            }
        }

        public bool Has(Duty duty) => (Duties & duty) != 0;
    }

    /// <summary>
    /// Hireable companions.
    ///
    /// A Gaheris keep is group content -- twenty-seven guards and a lord with a
    /// flat 40% resist to everything. This fields a full group so one player
    /// can approach the frontier.
    ///
    /// Design notes:
    ///
    ///  * They are the game's real classes, not invented archetypes. All
    ///    forty-seven of them, every realm, because Gaheris has one side.
    ///
    ///  * They join your group, so they show in the group window and a group
    ///    buff cast by one of them lands on all of you -- and on your own pet.
    ///
    ///  * They are NOT your controlled pet. A player has exactly one
    ///    ControlledBrain slot and a pet class is already using it, so they act
    ///    on their own. There is no pet command window for them.
    ///
    ///  * They wear real player gear. Drag anything from your pack onto one and
    ///    it puts it on -- the same database row, moved rather than copied, so
    ///    nothing is duplicated and nothing is destroyed. See MercenaryGear.
    ///
    ///  * The hire list, the gear and the earned realm points are all in the
    ///    database, so the same group reforms around you when you log back in.
    /// </summary>
    public static class MercenaryManager
    {
        public const string RP_KEY = "GaherisMercRealmPoints";
        public const string ROSTER_KEY = "GaherisMercRoster";
        public const string TACTIC_KEY = "GaherisMercTactic";

        /// <summary>Whether the company is dug in where it stands.</summary>
        public const string CAMP_KEY = "GaherisMercCamp";

        /// <summary>Where camp was pitched: region|x|y|z.</summary>
        public const string CAMP_SPOT_KEY = "GaherisMercCampSpot";
        public const string CC_KEY = "GaherisMercCrowdControl";
        public const string FORMATION_KEY = "GaherisMercFormation";
        public const int MAX_TIER = 10;
        public const int MAX_COMPANY = 7;

        /// <summary>The least time a fallen hire stays down, fight or no fight.</summary>
        public const int MIN_DOWN = 30000;

        private static readonly Dictionary<string, List<GameMercenary>> _companies = new();

        private static MercClass C(string name, eRealm realm, ushort model, Duty duties,
                                   string blurb, params string[] pets)
        {
            return new MercClass
            {
                Name = name, Realm = realm, Model = model, Duties = duties,
                Blurb = blurb, Pets = pets ?? Array.Empty<string>()
            };
        }

        /// <summary>Every class in the game, in realm order.</summary>
        public static readonly List<MercClass> Classes = new()
        {
            // ---- Albion -------------------------------------------------
            C("Armsman",     eRealm.Albion, 32, Duty.Tank,
              "Polearm and plate. Holds the line and takes the blows meant for you."),
            C("Paladin",     eRealm.Albion, 38, Duty.Tank | Duty.Chants,
              "Holds the line, and chants endurance back into the group."),
            C("Mercenary",   eRealm.Albion, 61, Duty.Melee,
              "Dual wield. Kills whatever the tank is holding."),
            C("Reaver",      eRealm.Albion, 39, Duty.Melee | Duty.DoT,
              "Flail and soul-drain."),
            C("Infiltrator", eRealm.Albion, 49, Duty.Melee,
              "Poison and a dagger from behind."),
            C("Scout",       eRealm.Albion, 35, Duty.Archer,
              "Longbow from the back rank. Never closes."),
            C("Minstrel",    eRealm.Albion, 65, Duty.Chants | Duty.Speed | Duty.CC | Duty.Melee,
              "Speed, chants, and a song that puts the adds to sleep."),
            C("Cleric",      eRealm.Albion, 74, Duty.Heal | Duty.Buffs,
              "Main healer, and keeps the group buffs standing."),
            C("Friar",       eRealm.Albion, 80, Duty.Heal | Duty.Melee,
              "Heals, and picks up a staff when it comes to it."),
            C("Heretic",     eRealm.Albion,  8, Duty.DoT | Duty.Heal,
              "Faith as a weapon, and as a bandage."),
            C("Wizard",      eRealm.Albion,  9, Duty.Nuke | Duty.PBAoE,
              "Fire, on one target or on all of them."),
            C("Theurgist",   eRealm.Albion, 10, Duty.Pet | Duty.Nuke,
              "Air elementals, endlessly.", "air elemental", "earth elemental"),
            C("Cabalist",    eRealm.Albion, 28, Duty.DoT | Duty.Debuff | Duty.Pet,
              "A spirit servant, and rot for everything else.", "spirit servant"),
            C("Sorcerer",    eRealm.Albion,  5, Duty.CC | Duty.Nuke,
              "Mesmerises the room, then burns what is left."),
            C("Necromancer", eRealm.Albion,  6, Duty.Pet | Duty.DoT | Duty.PBAoE,
              "A shade behind a bone pet.", "bone commander"),
            C("Mauler",      eRealm.Albion, 63, Duty.Melee | Duty.Nuke | Duty.Debuff | Duty.Buffs,
              "Fist and staff, and no armour worth the name."),

            // ---- Midgard ------------------------------------------------
            C("Warrior",      eRealm.Midgard, 153, Duty.Tank,
              "Shield and axe. Holds the line."),
            C("Thane",        eRealm.Midgard, 156, Duty.Melee | Duty.Nuke,
              "Hammer in one hand, lightning in the other."),
            C("Berserker",    eRealm.Midgard, 159, Duty.Melee,
              "Two axes and no interest in defence."),
            C("Savage",       eRealm.Midgard, 160, Duty.Melee,
              "Trades blood for speed."),
            C("Skald",        eRealm.Midgard, 161, Duty.Chants | Duty.Speed | Duty.Melee,
              "Runs the group faster and hits while doing it."),
            C("Hunter",       eRealm.Midgard, 175, Duty.Archer | Duty.Pet,
              "Bow from the back, with a cat in front.", "spotted lynx"),
            C("Shadowblade",  eRealm.Midgard, 191, Duty.Melee,
              "Comes out of nothing behind them."),
            C("Healer",       eRealm.Midgard, 192, Duty.Heal | Duty.Buffs | Duty.CC,
              "Main healer, group buffs, and mesmerises when it goes wrong."),
            C("Shaman",       eRealm.Midgard, 193, Duty.Heal | Duty.Buffs | Duty.DoT,
              "Heals, buffs, and poisons the ground."),
            C("Runemaster",   eRealm.Midgard, 203, Duty.Nuke | Duty.PBAoE,
              "Runes, single target and all around."),
            C("Spiritmaster", eRealm.Midgard, 212, Duty.Pet | Duty.Nuke,
              "A spirit champion does the walking.", "spirit champion"),
            C("Bonedancer",   eRealm.Midgard, 213, Duty.Pet | Duty.DoT,
              "A commander and its minions.", "bone commander", "bone healer"),
            C("Warlock",      eRealm.Midgard, 214, Duty.Nuke | Duty.Debuff,
              "Chambered magic and a weakening touch."),
            C("Valkyrie",     eRealm.Midgard, 215, Duty.Melee | Duty.Heal,
              "Spear and a little mending."),
            C("Mauler of Midgard", eRealm.Midgard, 216, Duty.Melee | Duty.Nuke | Duty.Debuff | Duty.Buffs,
              "Fist and staff, Midgard's own."),

            // ---- Hibernia -----------------------------------------------
            C("Hero",        eRealm.Hibernia, 342, Duty.Tank,
              "Shield and spear. The one thing between them and you."),
            C("Champion",    eRealm.Hibernia, 365, Duty.Melee | Duty.Nuke,
              "Blade and a little magic behind it."),
            C("Blademaster", eRealm.Hibernia, 286, Duty.Melee,
              "Three weapon styles and no patience."),
            C("Ranger",      eRealm.Hibernia, 326, Duty.Archer,
              "Bow from the back rank. Never closes."),
            C("Nightshade",  eRealm.Hibernia, 377, Duty.Melee,
              "Out of the dark, into their back."),
            C("Druid",       eRealm.Hibernia, 387, Duty.Heal | Duty.Buffs | Duty.Pet,
              "Main healer, group buffs, and something of the forest.", "spirit of the forest"),
            C("Warden",      eRealm.Hibernia, 383, Duty.Bubble | Duty.Heal | Duty.Buffs,
              "Runs the bubble -- a group damage shield -- and mends what gets through."),
            C("Bard",        eRealm.Hibernia, 362, Duty.Chants | Duty.Speed | Duty.CC | Duty.Heal,
              "Power, endurance and health regeneration, speed, and mez for the adds."),
            C("Eldritch",    eRealm.Hibernia, 361, Duty.Nuke | Duty.PBAoE,
              "Void magic, single target and all around."),
            C("Enchanter",   eRealm.Hibernia, 388, Duty.Pet | Duty.PBAoE,
              "A simulacrum, and everything at once.", "emerald simulacrum"),
            C("Mentalist",   eRealm.Hibernia, 366, Duty.Nuke | Duty.Heal | Duty.CC,
              "Mind magic: burns, mends, and puts to sleep."),
            C("Animist",     eRealm.Hibernia, 325, Duty.Pet | Duty.PBAoE,
              "Turrets, and more turrets.", "functional turret", "hardy turret"),
            C("Valewalker",  eRealm.Hibernia, 389, Duty.Melee | Duty.DoT,
              "A scythe, and the field rots behind it."),
            // A Bainshee is female. That is not decoration -- it is the class:
            // she is a wailing spirit, and the game has never let anyone make a
            // male one. Model 302 is male, and the mob table settles it without
            // any guessing: twenty-five NPCs use it and every one is Gender 1.
            // 310 is the female model, used eighteen times, Chieftess Crimthain
            // among them.
            C("Bainshee",    eRealm.Hibernia, 310, Duty.PBAoE | Duty.Nuke,
              "Screams. Everything in front of her stops."),
            C("Vampiir",     eRealm.Hibernia, 380, Duty.Melee | Duty.Debuff,
              "Closes, drains, and takes their strength with it."),
            C("Mauler of Hibernia", eRealm.Hibernia, 334, Duty.Melee | Duty.Nuke | Duty.Debuff | Duty.Buffs,
              "Fist and staff, Hibernia's own."),
        };

        /// <summary>Keyword -> class, used by the recruiter.</summary>
        public static readonly Dictionary<string, MercClass> Roster = BuildRoster();

        private static Dictionary<string, MercClass> BuildRoster()
        {
            Dictionary<string, MercClass> roster = new();

            foreach (MercClass profile in Classes)
                roster[profile.Key] = profile;

            return roster;
        }

        /// <summary>Reads one of this character's stored values.</summary>
        public static string GetParam(GamePlayer player, string key)
        {
            if (player == null)
                return null;

            DbCoreCharacterXCustomParam row = DOLDB<DbCoreCharacterXCustomParam>.SelectObject(
                DB.Column("DOLCharactersObjectId").IsEqualTo(player.ObjectId)
                  .And(DB.Column("KeyName").IsEqualTo(key)));

            return row?.Value;
        }

        public static void SetParam(GamePlayer player, string key, string value)
        {
            if (player == null)
                return;

            DbCoreCharacterXCustomParam row = DOLDB<DbCoreCharacterXCustomParam>.SelectObject(
                DB.Column("DOLCharactersObjectId").IsEqualTo(player.ObjectId)
                  .And(DB.Column("KeyName").IsEqualTo(key)));

            if (row == null)
            {
                row = new DbCoreCharacterXCustomParam();
                row.DOLCharactersObjectId = player.ObjectId;
                row.KeyName = key;
                row.Value = value;
                GameServer.Database.AddObject(row);
                return;
            }

            row.Value = value;
            GameServer.Database.SaveObject(row);
        }

        /// <summary>
        /// Whether the crowd control classes should actually use it.
        ///
        /// Mesmerising the adds is usually right and occasionally the exact
        /// wrong thing -- an area-damage group wants every mob awake and
        /// standing in one place, and a mez breaks on the first tick of it.
        /// On by default, because that is what crowd control is for.
        /// </summary>
        public static bool GetCrowdControl(GamePlayer player)
        {
            return GetParam(player, CC_KEY) != "off";
        }

        public static void SetCrowdControl(GamePlayer player, bool on)
        {
            SetParam(player, CC_KEY, on ? "on" : "off");
        }

        public static Formation GetFormation(GamePlayer player)
        {
            return Enum.TryParse(GetParam(player, FORMATION_KEY), out Formation formation)
                ? formation : Formation.Circle;
        }

        public static void SetFormation(GamePlayer player, Formation formation)
        {
            SetParam(player, FORMATION_KEY, formation.ToString());
        }

        public static Tactic GetTactic(GamePlayer player)
        {
            return Enum.TryParse(GetParam(player, TACTIC_KEY), out Tactic tactic) ? tactic : Tactic.Balanced;
        }

        public static void SetTactic(GamePlayer player, Tactic tactic)
        {
            SetParam(player, TACTIC_KEY, tactic.ToString());
        }

        /// <summary>
        /// Whether the company is set up somewhere and pulling to it.
        ///
        /// Deliberately not a Tactic. A camp can be a point-blank camp, a pet
        /// camp or a single-pull camp -- it says nothing about how the fight is
        /// fought, only that you are staying put and the ground is worth
        /// investing in. Making it a fourth tactic would have forced a choice
        /// between the two that nobody should have to make.
        /// </summary>
        public static bool IsCamped(GamePlayer player)
        {
            return GetParam(player, CAMP_KEY) == "1";
        }

        public static void SetCamped(GamePlayer player, bool camped)
        {
            SetParam(player, CAMP_KEY, camped ? "1" : "0");

            // Where camp is, is where you were standing when you called it.
            // The company holds this ground rather than following you, so the
            // spot has to be remembered rather than recomputed from wherever
            // the employer has since wandered off to.
            if (camped && player != null)
                SetParam(player, CAMP_SPOT_KEY,
                         player.CurrentRegionID + "|" + player.X + "|" + player.Y + "|" + player.Z);
        }

        /// <summary>The camp, or null if there is not one.</summary>
        public static GameLocation CampSpot(GamePlayer player)
        {
            if (player == null || !IsCamped(player))
                return null;

            string[] parts = (GetParam(player, CAMP_SPOT_KEY) ?? string.Empty).Split('|');

            if (parts.Length != 4 ||
                !ushort.TryParse(parts[0], out ushort region) ||
                !int.TryParse(parts[1], out int x) ||
                !int.TryParse(parts[2], out int y) ||
                !int.TryParse(parts[3], out int z))
                return null;

            return new GameLocation("camp", region, x, y, z);
        }

        public static long GetRealmPoints(GamePlayer player)
        {
            string stored = GetParam(player, RP_KEY);
            return long.TryParse(stored, out long value) ? value : 0;
        }

        public static void AddRealmPoints(GamePlayer player, long amount)
        {
            if (player == null || amount <= 0)
                return;

            SetParam(player, RP_KEY, (GetRealmPoints(player) + amount).ToString());

            int tier = GetTier(player);

            player.Out.SendMessage(
                "Your group shares in the reward. (" + GetRealmPoints(player).ToString("N0") +
                " earned, tier " + tier + ")",
                eChatType.CT_Important, eChatLoc.CL_SystemWindow);

            foreach (GameMercenary merc in GetCompany(player))
            {
                merc.ApplyTier(tier);

                // Learn() re-spends the realm points, and this is the only
                // place that can notice they have gone up.
                //
                // Without it, abilities were bought at three moments only:
                // when a hire was taken on, when it re-levelled, and when it
                // was fielded again on login. Earning realm points -- the
                // actual thing that pays for them -- triggered nothing. Turn in
                // a pile of seals at level 50, where there is no levelling left
                // to do, and the company would have kept whatever it had until
                // the next relog.
                //
                // Safe to repeat: GetClassRealmAbilities hands back fresh
                // instances, and AddAbility is add-OR-UPDATE keyed on name, so
                // re-spending upgrades rather than duplicating.
                merc.Learn();

                merc.ApplyGear(); // Item caps move with level, so re-read the gear.
            }
        }

        /// <summary>Roughly a tier per 50k, which is a handful of cleared keeps.</summary>
        public static int GetTier(GamePlayer player)
        {
            long rp = GetRealmPoints(player);
            int tier = (int) (rp / 50000);
            return tier > MAX_TIER ? MAX_TIER : tier;
        }

        public static List<GameMercenary> GetCompany(GamePlayer player)
        {
            if (player == null)
                return new List<GameMercenary>();

            if (!_companies.TryGetValue(player.ObjectId, out List<GameMercenary> company))
            {
                company = new List<GameMercenary>();
                _companies[player.ObjectId] = company;
            }

            company.RemoveAll(m => m == null || m.ObjectState != GameObject.eObjectState.Active);
            return company;
        }

        public static void Register(GamePlayer player, GameMercenary merc)
        {
            GetCompany(player).Add(merc);
        }

        /// <summary>Sends them home for good, and forgets they were ever hired.</summary>
        public static void Dismiss(GamePlayer player)
        {
            Disband(player);
            SetParam(player, ROSTER_KEY, string.Empty);
        }

        /// <summary>Clears them out of the world but keeps the hire list.</summary>
        public static void Disband(GamePlayer player)
        {
            List<GameMercenary> company = GetCompany(player);

            foreach (GameMercenary merc in new List<GameMercenary>(company))
                merc.Retire();

            company.Clear();
        }

        // -------------------------------------------------------------------
        // The hire list
        // -------------------------------------------------------------------
        // Who was hired, remembered per character. They are ordinary game
        // objects and do not outlive the session -- but this does, and so does
        // their gear, so the same group is rebuilt the moment you return.

        /// <summary>
        /// Adds a class to the standing hire list. Only hiring writes to this
        /// and only dismissal clears it -- notably, falling in battle does not,
        /// or a death followed by a quick relog would lose that hire for good.
        /// </summary>
        public static void AddToRoster(GamePlayer player, string key)
        {
            if (player == null || string.IsNullOrEmpty(key))
                return;

            string saved = GetParam(player, ROSTER_KEY) ?? string.Empty;
            List<string> keys = new(saved.Split(',', StringSplitOptions.RemoveEmptyEntries));

            if (keys.Contains(key) || keys.Count >= MAX_COMPANY)
                return;

            keys.Add(key);
            SetParam(player, ROSTER_KEY, string.Join(",", keys));
        }

        public static bool HasRole(GamePlayer player, string key)
        {
            foreach (GameMercenary merc in GetCompany(player))
            {
                if (merc.RoleKey == key && merc.IsAlive)
                    return true;
            }

            return false;
        }

        public static int RestoreRoster(GamePlayer player)
        {
            // Anything still listed belongs to the previous session's player
            // object, so clear it out before rebuilding.
            Disband(player);

            string saved = GetParam(player, ROSTER_KEY);

            if (string.IsNullOrEmpty(saved))
                return 0;

            int offset = 0;
            int fielded = 0;

            foreach (string key in saved.Split(','))
            {
                if (GetCompany(player).Count >= MAX_COMPANY)
                    break;

                if (!Roster.TryGetValue(key.Trim(), out MercClass profile))
                    continue;

                Field(player, profile, offset);
                offset += 50;
                fielded++;
            }

            return fielded;
        }

        /// <summary>
        /// Brings a fallen hire back once the fight they fell in is over.
        ///
        /// A flat timer is the wrong shape for this: three minutes is nothing
        /// while you are still swinging and an age while you are stood waiting.
        /// They pick themselves up when their employer is out of combat, after
        /// a decent minimum -- and they come back hurt, so somebody has to mend
        /// them before the next pull.
        /// </summary>
        public static void ScheduleReturn(GamePlayer player, string key)
        {
            if (player == null || !Roster.ContainsKey(key))
                return;

            long readyAt = GameLoop.GameLoopTime + MIN_DOWN;
            ECSGameTimer timer = new ECSGameTimer(player);

            timer.Callback = t =>
            {
                // Dismissed, replaced, or logged out on in the meantime -- and
                // a relog or a release fields the whole list anyway.
                if (player.ObjectState != GameObject.eObjectState.Active ||
                    HasRole(player, key) ||
                    GetCompany(player).Count >= MAX_COMPANY)
                    return 0;

                // Not while the fight that killed them is still going.
                if (GameLoop.GameLoopTime < readyAt || player.InCombat)
                    return 5000;

                GameMercenary returning = Field(player, Roster[key], GetCompany(player).Count * 50);
                returning.Health = Math.Max(1, returning.MaxHealth / 4);

                player.Out.SendMessage(
                    "Your " + returning.RoleName + " rejoins you, in a bad way.",
                    eChatType.CT_Important, eChatLoc.CL_SystemWindow);
                return 0;
            };

            timer.Start(5000);
        }

        /// <summary>Spawns one hire beside the player.</summary>
        public static GameMercenary Field(GamePlayer player, MercClass profile, int offset)
        {
            GameMercenary merc = new GameMercenary();
            int tier = GetTier(player);

            merc.Profile = profile;
            merc.Configure(player, tier);
            merc.X = player.X + 50 + offset;
            merc.Y = player.Y + 50;
            merc.Z = player.Z;
            merc.Heading = player.Heading;
            merc.CurrentRegion = player.CurrentRegion;
            merc.SetOwnBrain(new MercenaryBrain(player));
            merc.AddToWorld();
            Register(player, merc);
            Enlist(player, merc);
            AddToRoster(player, profile.Key);
            return merc;
        }

        /// <summary>
        /// Puts a hire in the player's group, so they show up in the group
        /// window with health bars like anyone else you run with -- and so a
        /// group buff one of them casts reaches all of you.
        ///
        /// Safe on the reward side because a hire cons through its employer and
        /// carries no damage share of its own: the group still counts one
        /// player, so nothing of the player's is divided away.
        /// </summary>
        public static void Enlist(GamePlayer player, GameMercenary merc)
        {
            if (player == null || merc == null || !merc.CanWearGear)
                return;

            if (player.Group == null)
            {
                Group formed = new Group(player);
                GroupMgr.AddGroup(formed);
                formed.AddMember(player);
            }

            // AddMember refuses past the server's group cap on its own, which
            // is eight -- the player and a full group of seven.
            if (player.Group != null && merc.Group == null)
                player.Group.AddMember(merc);
        }
    }

    /// <summary>
    /// The spells the hires use. One shared set, built once: a class draws on
    /// whichever of them its duties call for.
    ///
    /// Note that DbSpell.Duration is in SECONDS -- the Spell constructor
    /// multiplies by a thousand. Getting that wrong is how you end up with a
    /// five hour mesmerise.
    /// </summary>
    /// <summary>
    /// Follows the employer and assists whatever they are fighting.
    ///
    /// This IS a ControlledMobBrain, and it has to be -- which is worth
    /// recording, because the obvious alternative is a trap.
    ///
    /// Core hands a pet's owner 30% of its damage as aggro, and with six hires
    /// that is six streams of it landing on a player who has not swung at
    /// anything. The apparent fix is to stop being pets. But half the combat
    /// code keys off IControlledBrain, and KeepGuardBrain.CheckNpcAggro is
    /// blunt about it:
    ///
    ///     // Non-pet NPCs are ignored.
    ///     if (npc is GameKeepGuard || npc.Brain is not IControlledBrain)
    ///         continue;
    ///
    /// Uncoupled, a keep garrison cannot see the group at all: twenty-seven
    /// guards walk past six people to reach the player, who is now the only
    /// thing in the room they are willing to fight. On a server built around
    /// keeps that is far worse than the tag.
    ///
    /// So the tag stays, and the tank out-aggros it deliberately -- see
    /// GameMercenary.Provoke.
    /// </summary>
    /// <summary>
    /// Follows the employer and fights alongside them.
    ///
    /// Deliberately NOT a ControlledMobBrain. That is what makes something
    /// somebody's pet, and core hands a pet's owner 30% of its damage as aggro
    /// so mobs do not ignore the person standing behind it. Sized for one pet
    /// that is reasonable; with six hires it is six streams of aggro landing on
    /// a player who has not swung at anything, and mobs walk through the whole
    /// group to reach them. These are meant to be a group of players, so they
    /// are not anybody's pet.
    ///
    /// Two things had to be dealt with to make that work, and both were mine:
    /// keep guards ignore non-pet NPCs (fixed in MonsterKeepGuardBrain), and
    /// the employer must still be credited for what the group kills (done in
    /// GameMercenary.OnAttackEnemy).
    /// </summary>
    public class MercenaryBrain : StandardMobBrain
    {
        public GamePlayer Employer;

        public MercenaryBrain(GamePlayer employer)
        {
            Employer = employer;

            // They do not go looking for trouble. Like a player, they fight
            // what the group is fighting and whatever comes at them.
            AggroLevel = 0;
            AggroRange = 0;
        }

        public override int ThinkInterval => 1000;

        /// <summary>How far the employer may get before following beats fighting.</summary>
        private const int STAY_WITH_EMPLOYER = 600;

        /// <summary>How close they gather once the fighting is over.</summary>
        private const int REGROUP_DISTANCE = 150;

        /// <summary>
        /// The second argument to Follow is a GIVE-UP range, not a stopping
        /// distance:
        ///
        ///     if (distanceSquared > MaxFollowDistance * MaxFollowDistance)
        ///     {
        ///         StopFollowing();
        ///         return 0;
        ///     }
        ///
        /// Passing the regroup distance there meant a hire more than 150 units
        /// away cancelled its own follow on the spot -- and the further behind
        /// it was, the more certainly it gave up. Walking back to it brought it
        /// inside its own give-up radius, which is why that always worked.
        ///
        /// Pets use 10000 and never have the problem. Neither should they.
        /// </summary>
        public const int FOLLOW_GIVE_UP = 10000;

        /// <summary>
        /// How close they get to their own place in the formation.
        ///
        /// This is measured from the FORMATION spot, not from the employer, so
        /// it adds to the ring radius rather than replacing it. Leaving it at
        /// the regroup distance put them a hundred and fifty units past where
        /// they were meant to stand.
        /// </summary>
        private const int FORMATION_SLACK = 30;

        /// <summary>
        /// How far from the EMPLOYER something has to be before the group will
        /// engage it.
        ///
        /// They fight what reaches the group; they do not go out to meet it.
        /// That is not tidiness -- it is how a caster pull works. The pet is
        /// sent in, takes the aggro, is set passive and walks the train back to
        /// where the group is sitting. Melee that charge out to intercept it
        /// scatter the group across the camp and pull everything else on the
        /// way. Sit still, let it come, then kill it.
        /// </summary>
        public const int ENGAGE_RANGE = 500;

        /// <summary>
        /// Whatever is currently attacking the employer or anyone hired by
        /// them. Nearest first, so they deal with what has actually reached the
        /// group rather than the furthest thing that once swung at somebody.
        /// </summary>
        private GameLiving ThreatToTheGroup(GamePlayer owner)
        {
            GameLiving nearest = null;
            int closest = int.MaxValue;

            foreach (GameNPC npc in Body.GetNPCsInRadius(2000))
            {
                if (npc is GameMercenary || !npc.IsAlive || !npc.InCombat)
                    continue;

                GameLiving victim = npc.TargetObject as GameLiving;

                if (victim == null)
                    continue;

                if (!GameMercenary.IsOneOfUs(victim, owner))
                    continue;

                if (!GameServer.ServerRules.IsAllowedToAttack(Body, npc, true))
                    continue;

                int range = Body.GetDistanceTo(npc);

                if (range < closest)
                {
                    closest = range;
                    nearest = npc;
                }
            }

            return nearest;
        }

        /// <summary>
        /// How far out the ring sits.
        ///
        /// Inside WorldMgr.GIVE_ITEM_DISTANCE, which is 128, because being
        /// spread out is pointless if it puts them beyond the range at which
        /// the game lets you hand somebody an item. The first attempt sat at
        /// 130 and missed it by two.
        /// </summary>
        private const int FORMATION_RADIUS = 80;

        /// <summary>
        /// Gives each hire its own place in a ring behind the employer.
        ///
        /// Following alone walks every one of them to the same point, so the
        /// group ends up standing inside each other -- which looks wrong and,
        /// more to the point, makes it impossible to drag an item onto the one
        /// you meant. You cannot gear somebody you cannot click.
        ///
        /// This is core's own hook: FollowTick calls CheckFormation and uses
        /// whatever position comes back.
        /// </summary>
        public override bool CheckFormation(ref int x, ref int y, ref int z)
        {
            GamePlayer owner = Employer;

            if (owner == null || Body is not GameMercenary merc)
                return false;

            List<GameMercenary> company = MercenaryManager.GetCompany(owner);
            int place = company.IndexOf(merc);

            if (place < 0 || company.Count == 0)
                return false;

            double facing = owner.Heading * (Math.PI / 2048.0);

            // Forward and right in the employer's own frame, matching the
            // convention used by GetPointFromHeading.
            double fx = -Math.Sin(facing), fy = Math.Cos(facing);
            double rx = Math.Cos(facing), ry = Math.Sin(facing);

            double ahead = 0, across = 0;
            int count = company.Count;

            switch (MercenaryManager.GetFormation(owner))
            {
                case Formation.Column:
                    ahead = -(place + 1) * 60;
                    break;

                case Formation.Line:
                    ahead = -80;
                    across = (place - (count - 1) / 2.0) * 70;
                    break;

                case Formation.Wedge:
                {
                    bool front = merc.Profile != null &&
                                 (merc.Profile.Has(Duty.Tank) || merc.Profile.Has(Duty.Melee));
                    ahead = front ? 80 : -90;
                    across = (place - (count - 1) / 2.0) * 65;
                    break;
                }

                default:
                {
                    // A ring, starting behind them.
                    double angle = facing + Math.PI + place * (2 * Math.PI / count);
                    x += (int) (Math.Sin(angle) * FORMATION_RADIUS);
                    y += (int) (Math.Cos(angle) * FORMATION_RADIUS);
                    return true;
                }
            }

            x += (int) (fx * ahead + rx * across);
            y += (int) (fy * ahead + ry * across);
            return true;
        }

        public override void Think()
        {
            GamePlayer owner = Employer;
            GameMercenary merc0 = Body as GameMercenary;

            // Retiring is the leash timer's call, not the brain's. A player is
            // briefly inactive in the middle of every teleport, and a brain
            // that retired on sight of that would disband the group each time
            // they travelled.
            if (owner == null || owner.ObjectState != GameObject.eObjectState.Active)
                return;

            // A corpse is not a fight.
            //
            // The attack component holds movement while AttackState is set, and
            // it stays set on a dead target. That wedged them: too close to
            // trigger the break-off, too "busy" for the regroup, and following
            // was called every tick and silently overridden. They stood over
            // the body swinging, several hundred units from the group.
            if (Body.TargetObject is GameLiving corpse && !corpse.IsAlive)
            {
                Body.StopAttack();
                Body.TargetObject = null;
            }

            // Left a long way behind -- catch up rather than wander.
            if (!Body.IsWithinRadius(owner, 3000))
            {
                Note(merc0, "teleporting to employer");
                Body.MoveTo(owner.CurrentRegionID, owner.X, owner.Y, owner.Z, owner.Heading);
                return;
            }

            // Staying with the employer comes before finishing a fight.
            //
            // A mob brain plants itself and trades blows until one of them is
            // down, which is why the group kept getting left behind mid-pull.
            // A companion goes where you go and brings what is chasing them,
            // so if the player has walked off, they break and follow -- aggro
            // and all. Fighting is what they do when they are already with you.
            if (!Body.IsWithinRadius(owner, STAY_WITH_EMPLOYER))
            {
                // BREAK OFF first. Following is not enough on its own.
                //
                // Follow only sets a follow target; the attack component is
                // meanwhile chasing its own, and chasing wins. So the call was
                // made on every tick and quietly overridden, and the melee
                // stayed out in the spawn swinging while the casters -- who
                // were not chasing anything -- came back like they were told.
                //
                // That is also why this looked like a follow-distance problem
                // and survived three attempts at tuning the distance.
                Note(merc0, "breaking off at " + Body.GetDistanceTo(owner) + "u, returning");
                Body.StopAttack();
                ClearAggroList();
                Body.TargetObject = null;
                GoHome(owner);
                return;
            }

            // Regroup BEFORE doing anything that roots them in place.
            //
            // An NPC cannot move while it is casting, and the moment a fight
            // ends the buffers begin a pass that is dozens of casts long. They
            // were not failing to come back -- they were standing exactly where
            // the fight finished, buffing, for minutes, which is regularly the
            // middle of a spawn. Walk back first; dress afterwards.
            // Note what this does NOT ask: whether the GROUP is busy.
            //
            // Committed() is group-wide on purpose, so that everyone piles in
            // when anyone starts a fight. Reusing it here was a mistake -- it
            // counts casting, buffing is casting, and a buff pass is minutes
            // long, so while anybody was dressing, nobody was allowed to walk
            // back. That is why they never returned, at any distance.
            //
            // Coming home is a personal decision: is MY employer out of combat,
            // and am I not mid-swing.
            if (!owner.InCombat && !Body.attackComponent.AttackState &&
                !Body.IsWithinRadius(owner, REGROUP_DISTANCE))
            {
                Note(merc0, "walking back from " + Body.GetDistanceTo(owner) + "u");
                Body.StopAttack();
                GoHome(owner);
                return;
            }

            GameMercenary merc = merc0;

            if (merc != null)
                merc.RoleThink(owner);

            GameLiving foe = owner.TargetObject as GameLiving;
            bool engaging = GameMercenary.Committed(owner) && foe != null && foe.IsAlive &&
                            GameServer.ServerRules.IsAllowedToAttack(Body, foe, true);

            // Casters may open at range; melee wait for it to arrive.
            bool reachedUs = foe != null && owner.IsWithinRadius(foe, ENGAGE_RANGE);

            if (engaging)
            {
                if (merc == null || (merc.EngagesInMelee && reachedUs))
                {
                    // Check whether they are actually SWINGING, not just whether
                    // they are pointed at the right thing. Casting sets
                    // TargetObject, so a tank that taunts ends up already "on
                    // target", and a check on target alone refuses to restart
                    // the attack the cast just interrupted.
                    if (!Body.attackComponent.AttackState || Body.TargetObject != foe)
                        Body.StartAttack(foe);

                    AddToAggroList(foe, 1);
                    Note(merc, "attacking " + foe.Name);
                }
                else if (merc != null && merc.EngagesInMelee)
                    Note(merc, "holding, " + foe.Name + " has not reached us");
                else
                    Note(merc, "casting at " + foe.Name);

                return;
            }

            // Nothing of the employer's to hit -- so look after the group.
            // Anything laying into one of us is everyone's problem, which is
            // what being in a group means and what a pet would never do.
            GameLiving threat = ThreatToTheGroup(owner);

            if (threat != null && (merc == null || merc.EngagesInMelee) &&
                owner.IsWithinRadius(threat, ENGAGE_RANGE))
            {
                if (!Body.attackComponent.AttackState || Body.TargetObject != threat)
                    Body.StartAttack(threat);

                AddToAggroList(threat, 1);
                Note(merc, "defending against " + threat.Name);
                return;
            }

            // Only a live target they are actually swinging at, and close
            // enough to be swinging at, keeps them where they are.
            //
            // The previous test was HasAggro || AttackState || InCombat, and
            // any of those can stay true long after the fight is over -- a
            // stale aggro entry, a combat timer still running down. The group
            // stayed rooted wherever the last mob died, which in practice is
            // standing in the middle of a spawn waiting for it to repopulate
            // around them.
            GameLiving current = Body.TargetObject as GameLiving;
            bool stillFighting = current != null && current.IsAlive &&
                                 Body.attackComponent.AttackState &&
                                 Body.IsWithinRadius(current, 500);

            if (stillFighting)
            {
                Note(merc, "still fighting " + current.Name);
                base.Think();
                return;
            }

            // Genuinely idle, and ONLY then: come back and stand ON the
            // employer, not merely somewhere near them.
            //
            // Following cancels attack movement, so calling it on any tick that
            // is not strictly idle yanks them off whatever they were hitting.
            // That is what stopped the whole group attacking the first time
            // this was uncoupled -- nothing to do with being pets.
            //
            // The follow distance is deliberately tight. At a few hundred units
            // they were considered "with you" wherever the fight happened to
            // end -- which is regularly standing in the middle of a spawn,
            // waiting to pull the next camp on their own.
            Note(merc, "idle, following at " + Body.GetDistanceTo(owner));

            if (Body.attackComponent.AttackState)
                Body.StopAttack();

            GoHome(owner);
        }

        /// <summary>
        /// Go where home is, which at a camp is not the employer.
        ///
        /// Every "come back" in this brain used to be Body.Follow(owner), and
        /// that is what kept the company at the player's heels through a camp
        /// no matter what the leash timer decided. Follow sets a moving target
        /// and re-aims every tick; there is no distance at which it stops. So
        /// holding ground has to be a different call, not a further condition
        /// on the same one.
        ///
        /// A healer whose employer is dead is the exception, and it belongs
        /// here rather than at the call sites: a camp you cannot be
        /// resurrected at ends at the first bad pull.
        /// </summary>
        private void GoHome(GamePlayer owner)
        {
            // A minion goes where its commander goes. It is the commander's,
            // not the employer's, so it has no business walking back to a
            // player it does not belong to -- and the commander is already
            // being sent to camp or after the employer by its own tick.
            if (Body is MercenaryServant servant && servant.Commander != null &&
                servant.Commander.IsAlive &&
                servant.Commander.ObjectState == GameObject.eObjectState.Active)
            {
                Body.Follow(servant.Commander, 80, MercenaryBrain.FOLLOW_GIVE_UP);
                return;
            }

            GameLocation camp = MercenaryManager.CampSpot(owner);

            bool rescuing = camp != null && !owner.IsAlive &&
                            Body is GameMercenary healer &&
                            healer.Profile != null && healer.Profile.Has(Duty.Heal) &&
                            healer.Kit?.Rez != null;

            if (camp == null || rescuing)
            {
                Body.Follow(owner, FORMATION_SLACK, FOLLOW_GIVE_UP);
                return;
            }

            Body.StopFollowing();

            if (Body.CurrentRegionID != camp.RegionID)
            {
                Body.MoveTo(camp.RegionID, camp.X, camp.Y, camp.Z, Body.Heading);
                return;
            }

            int dx = camp.X - Body.X;
            int dy = camp.Y - Body.Y;

            if (dx * dx + dy * dy > CAMP_SPREAD * CAMP_SPREAD)
                Body.WalkTo(new Point3D(camp.X, camp.Y, camp.Z), Body.MaxSpeed);
        }

        /// <summary>How far from the camp marker a hire may stand.</summary>
        private const int CAMP_SPREAD = 250;

        private static void Note(GameMercenary merc, string what)
        {
            if (merc != null)
                merc.LastAction = what;
        }
    }

    /// <summary>
    /// A hired class. One type for all forty-seven of them: what it does comes
    /// from its profile's duties, not from a subclass per class.
    /// </summary>
    public class GameMercenary : GameNPC
    {
        public GamePlayer Employer;
        public MercClass Profile;

        public virtual string RoleName => Profile != null ? Profile.Name : "Companion";
        public virtual string RoleDescription => Profile != null ? Profile.Blurb : string.Empty;
        protected virtual ushort RoleModel => Profile != null ? Profile.Model : (ushort) 334;

        /// <summary>The recruiter's keyword, which also names the gear drawer.</summary>
        public virtual string RoleKey => Profile != null ? Profile.Key : "companion";

        /// <summary>Archers and casters hang back; tanks and melee close.</summary>
        public virtual bool EngagesInMelee =>
            Profile == null || Profile.Has(Duty.Tank) || Profile.Has(Duty.Melee);

        /// <summary>Summoned servants belong to a hire, not to you, so they get nothing.</summary>
        public virtual bool CanWearGear => true;

        /// <summary>
        /// Picks up everything the class knows at this level -- the real spell
        /// lines and the real styles, straight from the game's own data.
        /// </summary>
        public void Learn()
        {
            if (Profile == null)
                return;

            // Master Levels belong to the employer, and the company walks them
            // with him. A hire that arrived at level 50 already knowing all ten
            // made your own progress through Atlantis the only progress in the
            // group that meant nothing.
            Kit = MercenaryLoadout.For(Profile.ClassId, Level, Profile.Duties,
                                       Employer is { MLGranted: true } ? Employer.MLLevel : 0);
            Styles = Kit.Styles;

            // The class's real abilities, so armour and weapon proficiency
            // work out of the game's own rules rather than a list I invented.
            foreach (Ability ability in Kit.Abilities)
                AddAbility(ability);

            SpendRealmPoints();
        }

        /// <summary>Guard needs shield training, which the class either has or does not.</summary>
        private bool HasShieldTraining => Kit != null && Kit.Styles.Any(st => st.Spec == "Shields");

        /// <summary>Has the duty. What they can actually DO comes from the class.</summary>
        public bool Can(Duty duty)
        {
            return Profile != null && Profile.Has(duty);
        }

        /// <summary>
        /// Can pick their employer up off the floor -- which is simply whether
        /// the class has learned a resurrection yet. No invented level gate:
        /// they get it when a player of that class would get it.
        /// </summary>
        public bool CanRaise => IsAlive && Kit != null && Kit.Rez != null;

        /// <summary>Where in the huddle this one stands, so they do not stack up.</summary>
        public int FormationOffset = 60;

        private const int LEASH_RANGE = 3500;

        /// <summary>How long an employer must be gone before it counts as a logout.</summary>
        private const long GONE_FOR_GOOD = 30000;

        /// <summary>Beyond this, out of combat, they should be walking home.</summary>
        private const int STRANDED_DISTANCE = 400;

        /// <summary>How long to let them try to walk it before carrying them.</summary>
        private const long STRANDED_PATIENCE = 8000;

        /// <summary>The real spells and styles this class knows at this level.</summary>
        public Loadout Kit = new();

        /// <summary>
        /// What this one decided to do on its last tick, for /mercwatch.
        ///
        /// Written at every branch of the brain, so the reason a hire is doing
        /// nothing can be READ rather than guessed at. Cheaper than another
        /// round of theories and a restart each time.
        /// </summary>
        public string LastAction = "new";

        private readonly Dictionary<int, long> _cooldowns = new();
        private long _ownerMissingSince;
        private long _strandedSince;
        private long _fieldedAt;
        private long _nextGuardCheck;
        private long _nextProvoke;
        private ECSGameTimer _leash;

        public virtual void Configure(GamePlayer owner, int tier)
        {
            Employer = owner;
            Name = RoleName;
            GuildName = "Free Company";
            Model = RoleModel;

            // Keep the gender flag agreeing with the model. Nothing much reads
            // it today, but a female model on an NPC the server believes is
            // male is the kind of disagreement that surfaces later in a
            // pronoun or an emote and takes an hour to trace back to here.
            Gender = Profile != null && Profile.Name == "Bainshee"
                ? eGender.Female
                : eGender.Neutral;

            Size = 50;
            Realm = owner.Realm;
            Flags = 0;
            RespawnInterval = -1;
            MaxSpeedBase = 250;
            FormationOffset = 60 + MercenaryManager.GetCompany(owner).Count * 40;
            ApplyTier(tier);
            Learn();
            MercenaryGear.Load(this);
            ApplyGear();
            Health = Math.Max(1, MaxHealth);
        }

        /// <summary>
        /// Tier raises level and stats, so a group keeps pace with its employer
        /// instead of being outgrown. A class's duties shape the emphasis.
        /// </summary>
        public virtual void ApplyTier(int tier)
        {
            if (Employer == null)
                return;

            int level = Employer.Level + tier;
            Level = (byte) (level > 70 ? 70 : level);

            // Stats belong to the level too. Flat level 50 numbers on a level 1
            // hire would not look wrong -- the level reads correctly -- but a
            // constitution of 120 and a nuke to match would quietly flatten
            // everything between the starter zone and the frontier.
            double share = Level / 50.0;

            Strength     = Stat(120, 15, tier, share);
            Constitution = Stat(120, 15, tier, share);
            Dexterity    = Stat(120, 10, tier, share);
            Quickness    = Stat(120, 10, tier, share);
            Intelligence = Stat(150, 20, tier, share);
            Empathy      = Stat(150, 20, tier, share);
            Piety        = Stat(150, 20, tier, share);

            if (Profile != null)
            {
                if (Profile.Has(Duty.Tank))
                {
                    Constitution = Stat(180, 20, tier, share);
                    BlockChance = 40;
                    ParryChance = 25;
                    EvadeChance = 10;
                }
                else if (Profile.Has(Duty.Melee))
                {
                    Strength = Stat(180, 20, tier, share);
                    Quickness = Stat(150, 15, tier, share);
                    ParryChance = 15;
                    EvadeChance = 10;
                }
                else if (Profile.Has(Duty.Pet) && !Profile.Has(Duty.Heal))
                {
                    // Pet classes are frail; the servants do the standing.
                    Constitution = Stat(90, 8, tier, share);
                }
            }

            Health = MaxHealth;
        }

        /// <summary>
        /// A level 50 stat, scaled down to whoever is actually wearing it.
        ///
        /// It scales from a floor rather than from zero, and that floor is not
        /// cosmetic. An NPC's max health is (constitution - 25) * 1.8 + a level
        /// term, so a constitution under 25 subtracts health, and a straight
        /// proportional scale gives a level 1 hire a constitution of 10 -- and
        /// a NEGATIVE maximum health. They spawn dead, die, get fielded again
        /// by the return timer, and die again, forever.
        /// </summary>
        private static short Stat(int atFifty, int perTier, int tier, double share)
        {
            double scaled = atFifty * (LOW_LEVEL_FLOOR + (1 - LOW_LEVEL_FLOOR) * share);
            return (short) Math.Max(MIN_STAT, (int) Math.Round(scaled) + perTier * tier);
        }

        /// <summary>What share of a level 50's stats the lowest level keeps.</summary>
        private const double LOW_LEVEL_FLOOR = 0.35;

        /// <summary>Comfortably clear of the constitution offset in the health formula.</summary>
        private const int MIN_STAT = 40;

        // -------------------------------------------------------------------
        // What they do in a fight
        // -------------------------------------------------------------------

        /// <summary>
        /// Once a second. Ordered by what a real group does first: keep people
        /// standing, keep the buffs up, lock down the adds, then damage.
        /// </summary>
        public virtual void RoleThink(GamePlayer owner)
        {
            if (Profile == null)
                return;

            // Nothing else matters while the employer is on the floor.
            if (!owner.IsAlive)
            {
                if (Kit.Rez != null && !InCombat && IsWithinRadius(owner, 1500))
                    CastAt(owner, Kit.Rez, 10000, true);

                return;
            }

            // Pets are kept standing whether or not there is a fight on --
            // an Animist replacing burnt turrets mid-fight is the class working
            // as intended, not an interruption.
            if (Profile.Has(Duty.Pet))
                MaintainServants();

            if (Profile.Has(Duty.Heal) && Mend(owner))
                return;

            // Healing carries on in a fight. Buffing does not.
            //
            // Buffs are slow, they are interrupted the moment anything lands,
            // and a group that stands there dressing itself while the pull
            // arrives simply dies mid-cast. Anything not already up can wait
            // until the fighting stops.
            if (!owner.InCombat && !InCombat && Support(owner))
                return;

            // A utility class is always doing something. Which song is playing
            // is the decision -- see Perform.
            if (Kit != null && Kit.HasSongs && Perform(owner))
                return;

            Tactic tactic = MercenaryManager.GetTactic(owner);

            // No mez under Focus, for the same reason nobody taunts under it:
            // the pet is holding everything on purpose, and a mesmerised mob is
            // a mob taken off the pet. It also breaks on the first tick of
            // anything, so mezzing here achieves nothing and costs the hold.
            if (Profile.Has(Duty.CC) && tactic != Tactic.Focus &&
                MercenaryManager.GetCrowdControl(owner) && Sleep(owner))
                return;

            if (Profile.Has(Duty.Tank))
                HoldTheLine(owner);

            GameLiving foe = FoeOf(owner);

            if (foe == null)
                return;

            // Under Focus, NOBODY opens until the pet has walked it in.
            //
            // The pull is: send the pet, let it take the aggro, set it passive,
            // and let it drag the train back to where the group is sitting. A
            // caster who opens the moment the pet engages takes the aggro
            // straight off it and brings the camp down on the group instead.
            // Holding was applied to melee only, so the Eldritch blasted the
            // pull apart the instant it started.
            if (tactic == Tactic.Focus && !owner.IsWithinRadius(foe, MercenaryBrain.ENGAGE_RANGE))
                return;

            // Under Focus the pet is the tank. A taunt would take one mob off
            // it, which is the whole thing the tactic is built to avoid.
            if (Profile.Has(Duty.Tank) && tactic != Tactic.Focus)
            {
                // The aggro plant happens whether or not the class owns a taunt
                // SPELL -- and almost none do.
                //
                // Real tanks taunt with styles, so keying the whole thing off a
                // taunt spell meant Heroes, Armsmen and Warriors never generated
                // any extra threat at all. The player would land one hit and
                // take the mob straight off them, which is exactly backwards.
                Provoke(foe);

                if (Kit.Taunt != null && CastAt(foe, Kit.Taunt, 6000))
                    return;
            }

            // A shaded Necromancer does not cast. Everything it has goes
            // through the servant, which is the whole shape of the class --
            // and casting directly is what had it throwing several of its own
            // spells a fight while the pet stood there.
            if (Shaded)
                return;

            if (Profile.Has(Duty.Debuff) && Kit.Debuff != null && CastAt(foe, Kit.Debuff, 12000))
                return;

            if (Profile.Has(Duty.DoT) && Kit.Dot != null && CastAt(foe, Kit.Dot, 5000))
                return;

            if (UseAtlantis())
                return;

            // Under PBAoE, a class that HAS a point-blank spell goes in and
            // uses it, and the thrown area spell waits its turn.
            //
            // This is the whole tactic, and it did not work. The order here was
            // thrown-first, and a Wizard has both -- Steaming Wind at range 0,
            // radius 300, and Explosive Blast at range 1500. So it stood at
            // fifteen hundred, threw the weaker spell, returned, and never
            // reached the code below that would have walked it in. Setting the
            // tactic changed nothing you could see.
            bool goInAndBlast = tactic == Tactic.PBAoE && Kit.Pbaoe != null;

            // Thrown area damage otherwise: it reaches, and it does not require
            // walking a caster into the middle of the pile to use it.
            if (!goInAndBlast && Kit.AreaNuke != null &&
                IsWithinRadius(foe, Kit.AreaNuke.Range) &&
                CastAt(foe, Kit.AreaNuke, 3500))
                return;

            // Point-blank only when they are actually among them.
            if (Kit.Pbaoe != null && IsWithinRadius(foe, Math.Max(150, Kit.Pbaoe.Radius)) &&
                CastAt(foe, Kit.Pbaoe, 3500))
                return;

            if (Kit.Dot != null && Profile.Has(Duty.DoT) && IsWithinRadius(foe, Kit.Dot.Range) &&
                CastAt(foe, Kit.Dot, 5000))
                return;

            // In a PBAoE group the casters go in rather than stand off, so the
            // area damage actually reaches something.
            // In a PBAoE group the point-blank casters go in, because their
            // spell has no reach at all -- that is the whole trade.
            if (tactic == Tactic.PBAoE && Kit.Pbaoe != null &&
                !IsWithinRadius(foe, Kit.Pbaoe.Radius))
            {
                Follow(foe, 60, MercenaryBrain.FOLLOW_GIVE_UP);
                return;
            }

            if (Kit.Nuke == null)
                return;

            // Cast at the spell's OWN range, and close the gap if short.
            //
            // A caster keeps station on its employer, up to a few hundred units
            // behind. Stand at the edge of your own range and the caster is
            // beyond the edge of its -- so it says nothing and does nothing,
            // and you find yourself walking onto the mob to get it to fire.
            if (IsWithinRadius(foe, Kit.Nuke.Range))
            {
                CastAt(foe, Kit.Nuke, 3000);
                return;
            }

            Follow(foe, Math.Max(200, Kit.Nuke.Range - 300), Kit.Nuke.Range - 100);
        }

        /// <summary>
        /// Plays whatever the moment calls for.
        ///
        /// Only one song pulses at a time, so this is a choice and not a list
        /// to keep up. On the road that is speed, because the group is going
        /// somewhere; in a fight it is whichever sustain the group is actually
        /// short of. Filing speed with the maintained buffs -- which is where
        /// it used to live -- meant a Bard kept the group quick and then stood
        /// there in the fight playing nothing at all.
        ///
        /// Two of the same class do not fight over it: a song already pulsing
        /// on the employer satisfies the check, so the second one moves on.
        /// </summary>
        private bool Perform(GamePlayer owner)
        {
            bool fighting = owner.InCombat || InCombat;

            if (!fighting)
            {
                if (Kit.Speed != null && NeedsSong(owner, Kit.Speed))
                    return CastAt(this, Kit.Speed, 3000);

                // Out of combat there is nothing else worth playing over the
                // travel song, so a class without one simply rests.
                return false;
            }

            Spell song = FightSong(owner);

            return song != null && NeedsSong(owner, song) && CastAt(this, song, 3000);
        }

        /// <summary>What the group is short of right now.</summary>
        private Spell FightSong(GamePlayer owner)
        {
            // Power first. It is the one thing a fight will not give back, and
            // a caster out of power has left the fight.
            if (Kit.PowerSong != null && Thirsty(owner))
                return Kit.PowerSong;

            if (Wounded(owner) > 0)
            {
                if (Kit.ChantHeal != null)
                    return Kit.ChantHeal;

                if (Kit.HealthSong != null)
                    return Kit.HealthSong;
            }

            // Nobody needs propping up: play something that helps them kill it.
            return Kit.ChantDamage ?? Kit.ChantGuard
                ?? Kit.HealthSong ?? Kit.ChantEndurance;
        }

        /// <summary>Whether a song is not already pulsing on the group.</summary>
        private bool NeedsSong(GamePlayer owner, Spell song)
        {
            eEffect effect = EffectHelper.GetEffectFromSpell(song);

            // Unknown means the effect cannot be tested for. The per-spell cast
            // cooldown still paces it, so this errs towards playing.
            if (effect is eEffect.Unknown)
                return true;

            return EffectListService.GetEffectOnTarget(owner, effect) == null;
        }

        /// <summary>Whether anybody in the group is running out of power.</summary>
        private bool Thirsty(GamePlayer owner)
        {
            if (owner.MaxMana > 0 && owner.ManaPercent < 70)
                return true;

            foreach (GameMercenary mate in MercenaryManager.GetCompany(owner))
            {
                if (mate.IsAlive && mate.MaxMana > 0 && mate.ManaPercent < 70)
                    return true;
            }

            return false;
        }

        /// <summary>
        /// How many realm ability points the company has to spend.
        ///
        /// This used to be the company TIER -- one point per fifty thousand
        /// realm points -- which is the scale that decides their LEVEL and is
        /// far too coarse to buy abilities with. A player at realm rank seven
        /// has spent points on several; a company that had earned the same
        /// realm points had a budget of zero and bought nothing at all, so the
        /// whole realm-ability system was dead code in practice.
        ///
        /// Now it is a realm rank, worked out against the game's own realm
        /// point table so the curve matches what a player would have earned.
        /// </summary>
        private int RealmAbilityPoints()
        {
            if (Employer == null)
                return 0;

            long earned = MercenaryManager.GetRealmPoints(Employer);
            int rank = 0;

            for (int level = 1; level < GamePlayer.REALMPOINTS_FOR_LEVEL.Length; level++)
            {
                if (earned >= GamePlayer.REALMPOINTS_FOR_LEVEL[level])
                    rank = level;
                else
                    break;
            }

            return rank;
        }

        /// <summary>
        /// How much a given realm ability is worth to THIS class.
        ///
        /// Matched on the name rather than on a hard-coded table of keys, so a
        /// server that has renamed or added abilities still gets sensible
        /// choices, and anything unrecognised simply scores zero and is bought
        /// last with whatever is left over.
        /// </summary>
        private int Worth(RealmAbility ability)
        {
            string key = ((ability.KeyName ?? string.Empty) + " " +
                          (ability.Name ?? string.Empty)).ToLowerInvariant();

            int worth = 0;

            // Everyone wants out of crowd control, and everyone wants to live.
            if (key.Contains("purge")) worth += 100;
            if (key.Contains("determination")) worth += 55;
            if (key.Contains("avoidance of magic")) worth += 40;
            if (key.Contains("toughness")) worth += 25;

            if (Profile.Has(Duty.Heal))
            {
                if (key.Contains("mastery of healing")) worth += 95;
                if (key.Contains("divine intervention")) worth += 90;
                if (key.Contains("perfect recovery")) worth += 85;
                if (key.Contains("ameliorating")) worth += 80;
                if (key.Contains("serenity")) worth += 75;
                if (key.Contains("mystic crystal")) worth += 70;
                if (key.Contains("concentration")) worth += 65;
            }

            if (Profile.Has(Duty.Buffs) || Profile.Has(Duty.Bubble) ||
                Profile.Has(Duty.Chants))
            {
                if (key.Contains("barrier of fortitude")) worth += 85;
                if (key.Contains("soldier")) worth += 75;
                if (key.Contains("dashing defense")) worth += 70;
                if (key.Contains("strike prediction")) worth += 65;
                if (key.Contains("augmented") || key.Contains("acuity")) worth += 45;
            }

            if (Profile.Has(Duty.Nuke) || Profile.Has(Duty.PBAoE) ||
                Profile.Has(Duty.DoT))
            {
                if (key.Contains("wild power") || key.Contains("mastery of magery"))
                    worth += 80;

                if (key.Contains("raging power")) worth += 70;
                if (key.Contains("mystic crystal")) worth += 65;
                if (key.Contains("maelstrom") || key.Contains("tempest")) worth += 55;
                if (key.Contains("ichor")) worth += 50;
            }

            if (Profile.Has(Duty.CC))
            {
                if (key.Contains("mastery of concentration")) worth += 90;
                if (key.Contains("bedazzling")) worth += 60;
            }

            if (Profile.Has(Duty.Tank))
            {
                if (key.Contains("ignore pain")) worth += 80;
                if (key.Contains("mastery of blocking")) worth += 65;
                if (key.Contains("mastery of parrying")) worth += 60;
                if (key.Contains("charge")) worth += 55;
            }

            if (Profile.Has(Duty.Melee))
            {
                if (key.Contains("mastery of pain")) worth += 75;
                if (key.Contains("adrenaline")) worth += 65;
                if (key.Contains("anger of the gods")) worth += 60;
                if (key.Contains("charge")) worth += 55;
            }

            if (Profile.Has(Duty.Archer))
            {
                if (key.Contains("falcon")) worth += 75;
                if (key.Contains("arrow summoning")) worth += 60;
                if (key.Contains("rapid fire")) worth += 55;
            }

            if (Profile.Has(Duty.Pet) && key.Contains("juggernaut"))
                worth += 75;

            return worth;
        }

        /// <summary>Heals the worst hurt, or the group when several are.</summary>
        private bool Mend(GamePlayer owner)
        {
            GameLiving worst = WorstWounded(owner);

            if (worst == null || worst.HealthPercent >= 85)
                return false;

            if (Wounded(owner) >= 3 && Kit.GroupHeal != null && CastAt(this, Kit.GroupHeal, 4000))
                return true;

            return Kit.Heal != null && CastAt(worst, Kit.Heal, 2500);
        }

        /// <summary>
        /// Keeps up everything this class would keep up, and only what is
        /// actually missing. These are the real buffs, so what lands on the bar
        /// is what a player of that class would give you -- right icon, right
        /// delve, right strength for the level.
        /// </summary>
        private bool Support(GamePlayer owner)
        {
            // Roughly a cast time, because this is the pace of BUFFING, not a
            // retry timer.
            //
            // Most base and spec buffs are single target, so a group of seven
            // plus pets is dozens of casts. At fifteen seconds a cast the
            // group would still be getting dressed a quarter of an hour later,
            // which reads as "they do not buff the team" -- and once did.
            //
            // Spamming is prevented by the effect check, not by this: they
            // never recast something already up. The endless rebuffing seen
            // earlier was a buff whose effect never registered at all, which
            // cannot happen now they use the game's own spells.
            const int RETRY = 3000;

            foreach (Spell buff in Kit.Maintained)
            {
                // Whoever has the strongest version of this particular buff
                // casts it -- not whoever happened to be hired first.
                if (!BestAt(buff, owner))
                    continue;

                // Travel speed is for travelling.
                if (buff.SpellType is eSpellType.SpeedEnhancement && owner.InCombat)
                    continue;

                eEffect effect = EffectHelper.GetEffectFromSpell(buff);

                if (effect is eEffect.Unknown)
                    continue;

                GameLiving needs = WhoNeeds(owner, buff, effect);

                if (needs != null && CastAt(needs, buff, RETRY))
                    return true;
            }

            return false;
        }

        /// <summary>
        /// Whether this one has the best version of a given buff in the group.
        ///
        /// Two hires casting the same buff does not stack: the weaker is
        /// suppressed and the client draws it with a red outline. So exactly
        /// one has to own each buff -- and it should be whoever actually casts
        /// it best, judged buff by buff rather than by picking a single group
        /// buffer. A Druid and a Warden share both their lines but not their
        /// specialisation, so the better strength buff and the better armour
        /// buff may well belong to different people.
        ///
        /// Ties go to whoever was hired first, so the choice is stable and they
        /// do not trade the job back and forth every second.
        /// </summary>
        private bool BestAt(Spell buff, GamePlayer owner)
        {
            List<GameMercenary> company = MercenaryManager.GetCompany(owner);
            int mine = company.IndexOf(this);

            for (int i = 0; i < company.Count; i++)
            {
                GameMercenary mate = company[i];

                if (mate == this || !mate.IsAlive || mate.Kit == null)
                    continue;

                foreach (Spell theirs in mate.Kit.Maintained)
                {
                    if (theirs.SpellType != buff.SpellType)
                        continue;

                    if (theirs.Value > buff.Value)
                        return false;

                    if (theirs.Value == buff.Value && i < mine)
                        return false;
                }
            }

            return true;
        }

        /// <summary>
        /// Who still needs a given buff -- the employer first, then whoever
        /// else is standing.
        ///
        /// Most base and spec buffs are single target, so buffing only the
        /// player leaves the rest of the group running around bare. A real
        /// Druid works down the group; so does this one.
        /// </summary>
        /// <summary>
        /// Buffs that occupy the same slot as each other.
        ///
        /// A Cleric's Strength buff and a Shaman's Strength/Constitution buff
        /// are one eEffect each -- StrengthBuff and StrengthConBuff -- and the
        /// game treats them as different effects entirely. It does not treat
        /// them as different buffs: they write to the same base-buff category,
        /// so one replaces the other on the target.
        ///
        /// Asking only whether MY effect is on the target therefore always
        /// answers no while the other one is up. The Cleric buffs, the Shaman
        /// sees no StrengthConBuff and buffs over it, the Cleric sees no
        /// StrengthBuff and buffs over that, and the two of them do it for as
        /// long as they are both stood there -- which is exactly what a Cleric
        /// and a Shaman in the same company did, without pause, instead of
        /// healing.
        ///
        /// So the question is asked of the slot rather than the effect. The
        /// singles and the combined version of each are one family, and so are
        /// the resist groups, where the same thing happens between a single
        /// resist buff and the three-way or all-resist versions.
        /// </summary>
        private static readonly eEffect[][] BUFF_FAMILIES =
        {
            new[] { eEffect.StrengthBuff,     eEffect.StrengthConBuff },
            new[] { eEffect.ConstitutionBuff, eEffect.StrengthConBuff },
            new[] { eEffect.DexterityBuff,    eEffect.DexQuickBuff },
            new[] { eEffect.QuicknessBuff,    eEffect.DexQuickBuff },

            new[] { eEffect.BodyResistBuff,   eEffect.SpiritResistBuff, eEffect.EnergyResistBuff,
                    eEffect.BodySpiritEnergyBuff, eEffect.AllMagicResistsBuff, eEffect.AllResistsBuff },
            new[] { eEffect.HeatResistBuff,   eEffect.ColdResistBuff,   eEffect.MatterResistBuff,
                    eEffect.HeatColdMatterBuff,   eEffect.AllMagicResistsBuff, eEffect.AllResistsBuff },
            new[] { eEffect.SlashResistBuff,  eEffect.CrushResistBuff,  eEffect.ThrustResistBuff,
                    eEffect.AllMeleeResistsBuff,  eEffect.AllResistsBuff },
        };

        /// <summary>
        /// Whether this one already has something standing in that slot --
        /// its own buff, or anybody else's that would displace it.
        /// </summary>
        private static bool AlreadyCovered(GameLiving target, eEffect effect)
        {
            if (target == null)
                return true;

            if (EffectListService.GetEffectOnTarget(target, effect) != null)
                return true;

            foreach (eEffect[] family in BUFF_FAMILIES)
            {
                if (Array.IndexOf(family, effect) < 0)
                    continue;

                foreach (eEffect kin in family)
                {
                    if (EffectListService.GetEffectOnTarget(target, kin) != null)
                        return true;
                }
            }

            return false;
        }

        private GameLiving WhoNeeds(GamePlayer owner, Spell buff, eEffect effect)
        {
            // A self-only buff can only ever be on the caster.
            //
            // Casting one at somebody else applies it to the caster anyway, so
            // the check against the intended target is never satisfied and it
            // is recast forever -- which is what a caster with self buffs, like
            // an Eldritch, looked like: casting without pause and apparently
            // buffing itself over and over. It was.
            if (buff.Target is eSpellTarget.SELF)
                return AlreadyCovered(this, effect) ? null : this;

            if (!AlreadyCovered(owner, effect))
                return owner;

            foreach (GameMercenary mate in MercenaryManager.GetCompany(owner))
            {
                if (mate.IsAlive && IsWithinRadius(mate, 1500) &&
                    !AlreadyCovered(mate, effect))
                    return mate;
            }

            // The employer's own pet counts as one of the group. An Enchanter
            // stood behind a simulacrum that nobody buffed is half a character.
            GameLiving pet = owner.ControlledBrain?.Body;

            if (pet != null && pet.IsAlive && IsWithinRadius(pet, 1500) &&
                !AlreadyCovered(pet, effect))
                return pet;

            return null;
        }

        /// <summary>Mesmerises an add, never the thing being killed.</summary>
        private bool Sleep(GamePlayer owner)
        {
            if (Kit.Mez == null)
                return false;

            GameLiving current = owner.TargetObject as GameLiving;

            foreach (GameNPC npc in GetNPCsInRadius(1200))
            {
                if (npc == current || npc is GameMercenary || !npc.IsAlive || !npc.InCombat)
                    continue;

                if (EffectListService.GetEffectOnTarget(npc, eEffect.Mez) != null)
                    continue;

                if (!GameServer.ServerRules.IsAllowedToAttack(this, npc, true))
                    continue;

                return CastAt(npc, Kit.Mez, 8000);
            }

            return false;
        }

        /// <summary>
        /// Plants real aggro, rather than hoping to out-damage the problem.
        ///
        /// Core hands a pet's owner 30% of the pet's damage as aggro, and with
        /// six hires that is six streams of it landing on a player who has not
        /// swung at anything. Weighting the tank's own damage does not beat
        /// that, because a tank does not do much damage -- holding a mob has
        /// never been about hurting it.
        /// </summary>
        private void Provoke(GameLiving foe)
        {
            if (_nextProvoke > GameLoop.GameLoopTime)
                return;

            _nextProvoke = GameLoop.GameLoopTime + 6000;

            if (foe is GameNPC npc && npc.Brain is StandardMobBrain mob)
                mob.AddToAggroList(this, Level * 600L);
        }

        /// <summary>
        /// Whether this one owns a given job for the whole group.
        ///
        /// Two hires casting the same buff does not stack: the loser is
        /// suppressed, and the client draws a suppressed buff with a red
        /// outline. The default party has both a Druid and a Warden, so every
        /// buff line was being cast twice and the player ended up looking at a
        /// bar of red. First one who can do it owns it; the rest leave it be.
        /// </summary>
        private bool IsPrimaryFor(Duty duty, GamePlayer owner)
        {
            foreach (GameMercenary mate in MercenaryManager.GetCompany(owner))
            {
                if (mate.IsAlive && mate.Can(duty))
                    return mate == this;
            }

            return false;
        }

        /// <summary>
        /// Stands in front of whoever would die first. Guard needs the guarder
        /// and the guarded to be in the same group, which is one more thing the
        /// group membership buys.
        /// </summary>
        private void HoldTheLine(GamePlayer owner)
        {
            if (_nextGuardCheck > GameLoop.GameLoopTime)
                return;

            _nextGuardCheck = GameLoop.GameLoopTime + 10000;

            GameLiving ward = Softest(owner);

            if (ward == null || ward == this || Group == null || !Group.IsInTheGroup(ward))
                return;

            // Leave it alone if it is already right.
            //
            // CancelOurEffectThenAddOnTarget does what it says: it drops the
            // guard and puts a new one up. Calling it on a timer meant the
            // tank switched guard off and on every ten seconds forever, for no
            // reason, in full view of the person being guarded.
            foreach (GuardECSGameEffect standing in effectListComponent.GetAbilityEffects(eEffect.Guard))
            {
                if (standing.Source == this && standing.Target == ward)
                    return;
            }

            GuardAbilityHandler.CancelOurEffectThenAddOnTarget(this, ward);
        }

        /// <summary>The one in the group who can least afford to be hit.</summary>
        private GameLiving Softest(GamePlayer owner)
        {
            GameLiving softest = owner;

            foreach (GameMercenary mate in MercenaryManager.GetCompany(owner))
            {
                if (!mate.IsAlive || mate == this || mate.Profile == null)
                    continue;

                if (mate.Profile.Has(Duty.Tank) || mate.Profile.Has(Duty.Melee))
                    continue;

                if (mate.MaxHealth < softest.MaxHealth)
                    softest = mate;
            }

            return softest;
        }

        /// <summary>
        /// Puts the employer on the list of who earned this kill.
        ///
        /// Core does this for free when the attacker is somebody's pet -- it
        /// redirects the damage source to the owner. These are not pets, so the
        /// credit has to be given by hand, or a player whose group did all the
        /// killing would earn nothing from it. Zero damage, exactly as a group
        /// member who never swung is recorded.
        /// </summary>
        public override void OnAttackEnemy(AttackData ad)
        {
            base.OnAttackEnemy(ad);

            if (Employer == null || ad == null || ad.Target == null || ad.Target == Employer)
                return;

            // Credit the DAMAGE, not merely the presence.
            //
            // Experience is scaled by share of the damage done:
            //
            //     damagePercent = entityStats.Damage / npcTotalDamage
            //
            // so registering the employer with zero earns them zero, however
            // long the fight. Loot goes by a different path, which is why the
            // drops still arrived and only the experience went missing. This is
            // what core did for free when they were pets -- it redirected the
            // damage source to the owner -- and it has to be done by hand now
            // that they are not.
            ad.Target.AddXPGainer(Employer, ad.Damage + ad.CriticalDamage);
        }

        public virtual void Retire()
        {
            Group?.RemoveMember(this);

            if (ObjectState == eObjectState.Active)
                Delete();
        }

        /// <summary>
        /// Down, not gone. The hire list still names them, so they pick
        /// themselves up and rejoin a few minutes later, gear and all.
        /// </summary>
        public override void Die(GameObject killer)
        {
            GamePlayer employer = Employer;
            string key = RoleKey;

            // If they died almost the moment they arrived, something is wrong
            // with them rather than with the fight -- and calling them back
            // would just do it again, forever. Stop, and say so.
            bool stillborn = GameLoop.GameLoopTime - _fieldedAt < 10000;
            bool returns = CanWearGear && employer != null && !stillborn;

            if (stillborn && employer != null && CanWearGear)
            {
                employer.Out.SendMessage(
                    "Your " + RoleName + " died the moment they arrived and will not be called back. " +
                    "Tell whoever built me.",
                    eChatType.CT_Important, eChatLoc.CL_SystemWindow);
            }

            Group?.RemoveMember(this);
            base.Die(killer);

            if (returns)
            {
                MercenaryManager.GetCompany(employer).Remove(this);
                MercenaryManager.ScheduleReturn(employer, key);

                employer.Out.SendMessage(
                    "Your " + RoleName + " has fallen, and will find their way back to you.",
                    eChatType.CT_Important, eChatLoc.CL_SystemWindow);
            }
        }

        /// <summary>
        /// Refuses the bow, every time it is offered.
        ///
        /// Overriding the initial choice was not enough, and the reason is in
        /// AttackComponent:
        ///
        ///     // Force NPCs to switch back to their ranged weapon if they
        ///     // have any and their aggro list is empty.
        ///     npcOwner.SwitchWeapon(eActiveWeaponSlot.Distance);
        ///
        /// Core does not decide the weapon once. It re-arms the bow EVERY TIME
        /// a fight ends, so a Blademaster given one drew it again the moment
        /// the aggro list emptied -- which is most of the time. Catching the
        /// switch itself is the only place that covers every route in.
        /// </summary>
        public override void SwitchWeapon(eActiveWeaponSlot slot)
        {
            if (slot is eActiveWeaponSlot.Distance &&
                Profile != null && !Profile.Has(Duty.Archer))
            {
                base.SwitchWeapon(Inventory?.GetItem(eInventorySlot.TwoHandWeapon) != null
                    ? eActiveWeaponSlot.TwoHanded
                    : eActiveWeaponSlot.Standard);

                return;
            }

            base.SwitchWeapon(slot);
        }

        /// <summary>
        /// Picks the weapon this class would actually draw.
        ///
        /// Core's version hands the distance slot to anything with a bow in
        /// its inventory, ahead of every melee weapon, because for an ordinary
        /// mob a bow IS the weapon. These are classes, so only the ones that
        /// shoot for a living should be shooting -- and the gate above stops
        /// anyone else being given a bow in the first place. This covers the
        /// ones handed one before that gate existed.
        /// </summary>
        public override void InitializeActiveWeaponFromInventory()
        {
            if (Inventory == null)
                return;

            if (Profile != null && !Profile.Has(Duty.Archer))
            {
                DbInventoryItem twoHand = Inventory.GetItem(eInventorySlot.TwoHandWeapon);
                DbInventoryItem oneHand = Inventory.GetItem(eInventorySlot.RightHandWeapon);

                if (twoHand != null)
                {
                    SwitchWeapon(eActiveWeaponSlot.TwoHanded);
                    return;
                }

                if (oneHand != null)
                {
                    SwitchWeapon(eActiveWeaponSlot.Standard);
                    return;
                }
            }

            base.InitializeActiveWeaponFromInventory();
        }

        public override bool AddToWorld()
        {
            if (!base.AddToWorld())
                return false;

            _fieldedAt = GameLoop.GameLoopTime;
            _leash ??= new ECSGameTimer(this, Leash);
            _leash.Start(1000);

            // Servants are NOT summoned here.
            //
            // This ran on every login, every zone line and every teleport, and
            // nothing ever retired the previous set -- so a Druid came back
            // from a trip to the frontier with three pets, and an Animist with
            // six. MaintainServants owns the count now: it sweeps the dead,
            // retires the surplus, and tops up to what the class should have.

            return true;
        }

        public override bool RemoveFromWorld()
        {
            _leash?.Stop();
            RetireServants();
            return base.RemoveFromWorld();
        }

        /// <summary>
        /// Keeps a hire with its employer through anything that moves the
        /// player -- a teleporter, a zone line, /jump.
        ///
        /// This cannot live in the brain. A brain is only ticked while
        /// <c>IsVisibleToPlayers</c> holds, so the instant the player leaves,
        /// the group's brains stop and they freeze where they stood, with
        /// nothing left to wake them. Timers are ticked unconditionally.
        /// </summary>
        private int Leash(ECSGameTimer timer)
        {
            if (ObjectState != eObjectState.Active)
                return 0;

            if (Employer == null || Employer.ObjectState != eObjectState.Active)
            {
                // Do not read one missed tick as a logout. A player is inactive
                // for a moment in the middle of every teleport and every zone
                // line, and disbanding on that would cost the player their
                // group for crossing a border.
                if (_ownerMissingSince == 0)
                    _ownerMissingSince = GameLoop.GameLoopTime;

                if (GameLoop.GameLoopTime - _ownerMissingSince < GONE_FOR_GOOD)
                    return 1000;

                Retire();
                return 0;
            }

            _ownerMissingSince = 0;
            WearSpectralForm();
            KeepGroupBreathing();

            // At camp the company holds the ground and the employer does the
            // walking. That is the whole point of a pull camp: you go and
            // fetch, they are already set up when you get back. Following you
            // out would drag the point-blank casters away from the spot they
            // are meant to be standing on and bring the turrets nowhere,
            // since turrets do not move at all.
            if (HoldingCamp())
                return 1000;

            KeepPace();

            // Rescue anyone who cannot walk home.
            //
            // The server has no pathfinding -- it says so at every boot:
            // "LocalPathfindingMgr did not find the Detour library" -- so an
            // NPC told to follow walks a straight line and stops dead against
            // whatever is in the way. One of the group would be left standing
            // behind a rock, correctly deciding to come back, every tick,
            // forever.
            //
            // If they have been trying and not arriving, put them there.
            if (!Employer.InCombat && !IsWithinRadius(Employer, STRANDED_DISTANCE))
            {
                if (_strandedSince == 0)
                    _strandedSince = GameLoop.GameLoopTime;
                else if (GameLoop.GameLoopTime - _strandedSince > STRANDED_PATIENCE)
                {
                    _strandedSince = 0;
                    MoveTo(Employer.CurrentRegionID,
                           Employer.X + FormationOffset, Employer.Y + FormationOffset,
                           Employer.Z, Employer.Heading);
                }
            }
            else
                _strandedSince = 0;

            // Their home is wherever their employer is.
            //
            // A mob brain walks back to its spawn point whenever it has nothing
            // to do, and a hire's spawn point is the spot it was taken on at --
            // so the whole group would trail back to wherever the player logged
            // in and stand there. Moving the spawn with the player turns "go
            // home" into "go to them", which is what a companion means by it.
            SpawnPoint.X = Employer.X;
            SpawnPoint.Y = Employer.Y;
            SpawnPoint.Z = Employer.Z;

            // The follow brain handles anything closer than this on its own.
            if (CurrentRegionID != Employer.CurrentRegionID ||
                !IsWithinRadius(Employer, LEASH_RANGE))
            {
                MoveTo(Employer.CurrentRegionID,
                       Employer.X + FormationOffset, Employer.Y + FormationOffset,
                       Employer.Z, Employer.Heading);
            }

            return 1000;
        }

        /// <summary>
        /// Grows with the employer, between fights.
        ///
        /// A hire is levelled when it is taken on and never again, so a group
        /// hired at level 10 is still level 10 at level 30 -- and a summoned
        /// servant is worse, because it is created once in AddToWorld and never
        /// touched after. Everything goes grey together while the player climbs.
        ///
        /// Levelling up mid-swing would be its own kind of wrong, so this waits
        /// until the fighting stops, which is also when a caster would sensibly
        /// dismiss a servant and call up a fresh one.
        /// </summary>
        private void KeepPace()
        {
            int tier = MercenaryManager.GetTier(Employer);
            byte wanted = (byte) Math.Min(70, Employer.Level + tier);

            if (Level == wanted || Employer.InCombat || InCombat || !IsAlive)
                return;

            ApplyTier(tier);
            Learn();
            ApplyGear();
            Health = Math.Max(1, MaxHealth);

            if (this is MercenaryServant || Profile == null || !Profile.Has(Duty.Pet))
                return;

            // Servants do not re-level in place -- they are released and called
            // up again at the caster's new level. MaintainServants notices the
            // empty slots on its next tick and refills them.
            RetireServants();
        }

        // -------------------------------------------------------------------
        // Casting
        // -------------------------------------------------------------------

        /// <summary>Casts with a per-spell cooldown, so they do not spam.</summary>
        /// <summary>
        /// The Master Level abilities, in a fight.
        ///
        /// These sat unused for a long time and not because of the AI: nothing
        /// about a Font of Power's spell type marks it as anything, so it went
        /// into Known with everything else and no part of the kit ever looked
        /// at it. A hire could hold all ten levels of Perfecter and never drop
        /// a font in its life.
        ///
        /// Order matters. A summon is worth most at the start of a fight, a
        /// buff is worth having up before the damage starts, and a font is
        /// worth nothing at all unless the group is going to stand in it --
        /// which is what camp means and why fonts wait for it.
        /// </summary>
        private bool UseAtlantis()
        {
            const int SUMMON_AGAIN = 120000;
            const int BUFF_AGAIN   = 90000;
            const int FONT_AGAIN   = 60000;

            foreach (Spell summon in Kit.MlPets)
            {
                if (CastAt(this, summon, SUMMON_AGAIN))
                    return true;
            }

            foreach (Spell buff in Kit.MlBuffs)
            {
                if (CastAt(this, buff, BUFF_AGAIN))
                    return true;
            }

            // A camp is not a way of fighting -- it can be a point-blank
            // camp, a pet camp or a single-pull camp -- so this asks whether
            // you are staying, not how you are killing.
            if (Employer == null || !MercenaryManager.IsCamped(Employer))
                return false;

            foreach (Spell font in Kit.MlFonts)
            {
                if (CastAt(this, font, FONT_AGAIN))
                    return true;
            }

            return false;
        }

        protected bool CastAt(GameLiving target, Spell spell, int cooldownMillis, bool allowDead = false)
        {
            if (spell == null || target == null || !IsAlive || IsCasting)
                return false;

            // A resurrection is the one spell whose whole point is a dead
            // target. Without this the healer would refuse to cast it and
            // nothing would say why.
            if (!target.IsAlive && !allowDead)
                return false;

            // Out of range is not a cast, it is a reason to walk.
            //
            // This was missing, and it was the reason a caster would stand off
            // and appear to do nothing. The combat routine is a chain of "try
            // this, and if it worked, stop" -- so a debuff or a dot attempted
            // from a mile away consumed the decision, put itself on cooldown,
            // and returned before the code below that would have closed the
            // gap. The hire looked like it was casting; it was failing at
            // range, every tick, and never moving.
            //
            // Range 0 means the spell has no reach requirement -- a point-blank
            // area spell is centred on the caster and governed by its radius
            // instead -- so only a real range is enforced here.
            if (spell.Range > 0 && target != this && !IsWithinRadius(target, spell.Range))
                return false;

            // A pet-line spell with no pet to cast it is fatal here, not
            // merely useless. PetSpellHandler.CheckBeginCast wants to tell the
            // caster why it cannot be cast, and does it like this:
            //
            //     if (Caster.ControlledBrain == null)
            //         MessageToCaster(LanguageMgr.GetTranslation(
            //             (Caster as GamePlayer).Client, ...
            //
            // A hire is not a GamePlayer, so that cast yields null and the
            // dereference throws inside CastingService -- and the service's
            // answer to a component that throws is to remove the entity that
            // owns it from the world. A Necromancer whose servant was down
            // simply vanished mid-fight, roster and all.
            if (spell.SpellType is eSpellType.PetSpell && ControlledBrain == null)
                return false;

            long now = GameLoop.GameLoopTime;

            if (_cooldowns.TryGetValue(spell.ID, out long ready) && ready > now)
                return false;

            _cooldowns[spell.ID] = now + cooldownMillis;
            TargetObject = target;
            return CastSpell(spell, SkillBase.GetSpellLine(GlobalSpellsLines.Mob_Spells), false);
        }

        /// <summary>Casts only when the effect is actually missing.</summary>
        protected bool Maintain(GameLiving target, Spell spell, eEffect effect, int cooldownMillis)
        {
            if (target == null || !target.IsAlive)
                return false;

            if (EffectListService.GetEffectOnTarget(target, effect) != null)
                return false;

            return CastAt(target, spell, cooldownMillis);
        }

        /// <summary>
        /// Whether the employer has actually committed to a fight.
        ///
        /// InCombat alone is not enough to open on. It is driven by the last
        /// blow LANDED, so a caster who has just started a three second cast is
        /// not yet "in combat" -- and between pulls it lapses entirely. The
        /// group would stand and wait, and the thing that finally convinced
        /// them was the mob reaching the player and hitting them. Swinging or
        /// casting is commitment enough.
        /// </summary>
        public static bool Committed(GamePlayer owner)
        {
            // Swinging, or already traded blows, is commitment outright. So is
            // casting -- but only AT something. A player standing there with a
            // mob selected while he puts a self buff up has not started
            // anything, and counting that opened fights he never called for.
            if (owner.InCombat || owner.attackComponent.AttackState)
                return true;

            if (owner.IsCasting && owner.TargetObject is GameLiving aim &&
                aim.IsAlive && GameServer.ServerRules.IsAllowedToAttack(owner, aim, true))
                return true;

            // The GROUP being in a fight is what starts a fight, not the player
            // personally. If the tank pulled, or something jumped the healer,
            // everyone is in it -- waiting for the employer to throw the first
            // punch means the rest of them stand and watch a fight they are
            // already part of.
            // A hire counts only when it is genuinely in a fight.
            //
            // Casting used to count here as well, and buffing is casting, so a
            // single hire dressing the group marked the whole company as
            // committed -- and a buff pass runs for minutes. For all of it,
            // merely TARGETING a mob was enough to send everyone at it. That is
            // the pulling-on-a-glance bug: a look read as an order.
            foreach (GameMercenary mate in MercenaryManager.GetCompany(owner))
            {
                if (mate.IsAlive && Fighting(mate))
                    return true;
            }

            // And the employer's pet, which in a Focus pull is the ONLY thing
            // fighting -- that is the entire point of it. Leaving the pet out
            // meant nothing counted as committed, so the casters never opened
            // however close the train got. Same blind spot as the threat scan
            // had: the pet is part of the group and has to be counted as one.
            GameLiving pet = owner.ControlledBrain?.Body;
            return pet != null && pet.IsAlive && Fighting(pet);
        }

        /// <summary>
        /// Actually in a fight -- blows landed or being thrown. Casting is
        /// deliberately not here: a hire that is casting is usually buffing.
        /// </summary>
        private static bool Fighting(GameLiving living)
        {
            return living.InCombat || living.attackComponent.AttackState;
        }

        /// <summary>The employer's current foe, if there is a legitimate one.</summary>
        protected GameLiving FoeOf(GamePlayer owner)
        {
            GameLiving foe = owner.TargetObject as GameLiving;

            if (foe != null && (!foe.IsAlive ||
                !GameServer.ServerRules.IsAllowedToAttack(this, foe, true)))
                foe = null;

            // Fall back to whatever is actually fighting the group.
            //
            // Casters only ever fired at the employer's selected target, so if
            // the player had not targeted anything -- or had tabbed off, or was
            // running and looking elsewhere -- every caster in the group stood
            // there doing nothing while the melee fought. Only the ones who
            // close to swing had a way of finding an enemy on their own.
            foe ??= GroupsEnemy(owner);

            if (foe == null || !Committed(owner))
                return null;

            // Generous, because whether they can actually hit it is decided per
            // spell below -- not by one hard-coded number that had nothing to
            // do with any real spell's range.
            return IsWithinRadius(foe, 3000) ? foe : null;
        }

        /// <summary>
        /// Whatever is currently fighting the employer or anyone hired by them,
        /// nearest first. The group's enemy, rather than the player's target.
        /// </summary>
        protected GameLiving GroupsEnemy(GamePlayer owner)
        {
            GameLiving nearest = null;
            int closest = int.MaxValue;

            foreach (GameNPC npc in GetNPCsInRadius(2500))
            {
                if (npc is GameMercenary || !npc.IsAlive || !npc.InCombat)
                    continue;

                GameLiving victim = npc.TargetObject as GameLiving;

                if (!IsOneOfUs(victim, owner) ||
                    !GameServer.ServerRules.IsAllowedToAttack(this, npc, true))
                    continue;

                int range = GetDistanceTo(npc);

                if (range < closest)
                {
                    closest = range;
                    nearest = npc;
                }
            }

            return nearest;
        }

        /// <summary>
        /// Whether something being attacked is one of ours.
        ///
        /// The employer's PET counts, and that is not a detail: in a Focus pull
        /// the pet is deliberately the only thing holding aggro, so every mob
        /// it walks back is attacking the pet and nobody else. Checking only
        /// the player and the hires made the whole incoming train invisible --
        /// the group stood in a heap of mobs with nothing to attack, because as
        /// far as it could tell nothing was attacking IT.
        /// </summary>
        public static bool IsOneOfUs(GameLiving victim, GamePlayer owner)
        {
            if (victim == null)
                return false;

            if (victim == owner)
                return true;

            if (victim is GameMercenary mate && mate.Employer == owner)
                return true;

            return victim == owner.ControlledBrain?.Body;
        }

        /// <summary>Whoever in the group is worst off, employer included.</summary>
        protected GameLiving WorstWounded(GamePlayer owner)
        {
            GameLiving worst = owner;
            GameLiving pet = owner.ControlledBrain?.Body;

            // Under Focus the pet is holding everything, so it is the one that
            // has to stay up -- ahead of the employer, who is not being hit.
            if (pet != null && pet.IsAlive)
            {
                if (MercenaryManager.GetTactic(owner) is Tactic.Focus && pet.HealthPercent < 95)
                    return pet;

                if (pet.HealthPercent < worst.HealthPercent)
                    worst = pet;
            }

            foreach (GameMercenary mate in MercenaryManager.GetCompany(owner))
            {
                if (mate.IsAlive && mate.HealthPercent < worst.HealthPercent)
                    worst = mate;
            }

            return worst;
        }

        /// <summary>How many of the group are hurt enough to be worth a group heal.</summary>
        protected int Wounded(GamePlayer owner)
        {
            int hurt = owner.HealthPercent < 85 ? 1 : 0;

            foreach (GameMercenary mate in MercenaryManager.GetCompany(owner))
            {
                if (mate.IsAlive && mate.HealthPercent < 85)
                    hurt++;
            }

            return hurt;
        }

        // -------------------------------------------------------------------
        // Gear
        // -------------------------------------------------------------------

        /// <summary>
        /// Spends the group's earned realm points on realm abilities.
        ///
        /// They earn realm points alongside their employer, so they should
        /// spend them as a player would: down their OWN class's realm ability
        /// list, from SkillBase.GetClassRealmAbilities, rather than on some
        /// generic bonus. A Hero buys what a Hero can buy.
        ///
        /// The budget is the company tier -- one point per fifty thousand
        /// earned, the same measure that already sets their level -- and it is
        /// spent in list order, buying each ability up as far as it will go
        /// before moving on, which is how the cheap early ranks of the useful
        /// passives get taken first.
        /// </summary>
        public void SpendRealmPoints()
        {
            if (Profile == null || Employer == null)
                return;

            int budget = RealmAbilityPoints();

            if (budget <= 0)
                return;

            List<RealmAbility> available = SkillBase.GetClassRealmAbilities((int) Profile.ClassId);

            if (available == null)
                return;

            // Buy in the order this class would buy, not in whatever order
            // the list happens to arrive in. Spent greedily down a raw list, a
            // healer's points went on the first thing that fit rather than on
            // Purge and the group saves -- which is most of what a support
            // character's realm points are for.
            List<RealmAbility> wanted = new();

            foreach (RealmAbility candidate in available)
            {
                if (candidate != null)
                    wanted.Add(candidate);
            }

            wanted.Sort((a, b) => Worth(b).CompareTo(Worth(a)));

            foreach (RealmAbility ability in wanted)
            {
                if (ability == null)
                    continue;

                for (int level = 1; level <= ability.MaxLevel; level++)
                {
                    int cost = ability.CostForUpgrade(level - 1);

                    if (cost > budget)
                        break;

                    budget -= cost;
                    ability.Level = level;
                }

                if (ability.Level > 0)
                    AddAbility(ability);

                if (budget <= 0)
                    return;
            }
        }

        /// <summary>
        /// Turns worn gear into effects. Core reads NPC equipment for
        /// appearance and nothing else, so every consequence below is applied
        /// by hand -- and recomputed from scratch each time, rather than added
        /// and subtracted, so a mistake cannot accumulate.
        /// </summary>
        public void ApplyGear()
        {
            ItemBonus.Clear();
            BaseBuffBonusCategory[eProperty.MaxHealth] = 0;
            DamageFactor = 1.0;

            if (Inventory == null)
                return;

            foreach (DbInventoryItem item in Inventory.EquippedItems)
            {
                AddBonus(item.Bonus1Type, item.Bonus1);
                AddBonus(item.Bonus2Type, item.Bonus2);
                AddBonus(item.Bonus3Type, item.Bonus3);
                AddBonus(item.Bonus4Type, item.Bonus4);
                AddBonus(item.Bonus5Type, item.Bonus5);
                AddBonus(item.Bonus6Type, item.Bonus6);
                AddBonus(item.Bonus7Type, item.Bonus7);
                AddBonus(item.Bonus8Type, item.Bonus8);
                AddBonus(item.Bonus9Type, item.Bonus9);
                AddBonus(item.Bonus10Type, item.Bonus10);
                AddBonus(item.ExtraBonusType, item.ExtraBonus);
            }

            // An NPC's max health is worked out from its base constitution
            // alone -- it never looks at item bonuses. Route hits and item
            // constitution through the one channel it does read, on the same
            // curve it uses itself.
            int hitsCap = MaxHealthCalculator.GetItemBonusCap(this) +
                          MaxHealthCalculator.GetItemBonusCapIncrease(this);
            int hits = Math.Min(ItemBonus[eProperty.MaxHealth], hitsCap);
            int constitution = GetModifiedFromItems(eProperty.Constitution);
            BaseBuffBonusCategory[eProperty.MaxHealth] = hits + (int) (constitution * 1.8);

            DamageFactor = WeaponFactor(ActiveWeapon);

            // Never a free heal: gear can raise the ceiling, not fill the bar.
            if (Health > MaxHealth)
                Health = Math.Max(1, MaxHealth);
        }

        private void AddBonus(int property, int amount)
        {
            if (property <= 0 || amount == 0 || property >= (int) eProperty.MaxProperty)
                return;

            ItemBonus[(eProperty) property] += amount;
        }

        /// <summary>
        /// Core works out an NPC's swing damage from its level alone and skips
        /// the weapon's quality and condition entirely, so a weapon is worth
        /// nothing to an NPC by default. This gives one back its worth: a
        /// level-appropriate weapon in good repair is about a quarter more
        /// swing damage, and a poor one is never a penalty.
        /// </summary>
        private double WeaponFactor(DbInventoryItem weapon)
        {
            if (weapon == null || !GlobalConstants.IsWeapon(weapon.Object_Type))
                return 1.0;

            double baseline = 1.2 + Level * 0.3;                   // the usual dps-for-level curve
            double dps = Math.Min(weapon.DPS_AF * 0.1, baseline);  // a weapon cannot outrun its wielder
            dps *= weapon.Quality * 0.01 * weapon.ConditionPercent * 0.01;
            return 1.0 + 0.25 * (dps / baseline);
        }

        /// <summary>Worn armour, on the player's terms rather than the mob's.</summary>
        public override double GetArmorAF(eArmorSlot slot)
        {
            DbInventoryItem item = Inventory?.GetItem((eInventorySlot) slot);

            if (item == null || !GlobalConstants.IsArmor(item.Object_Type))
                return base.GetArmorAF(slot);

            double worn = Math.Min(item.DPS_AF, Level * 2) *
                          item.Quality * 0.01 * item.ConditionPercent * 0.01;
            worn += GetModified(eProperty.ArmorFactor) / 5.0;
            return Math.Max(base.GetArmorAF(slot), worn);
        }

        public override double GetArmorAbsorb(eArmorSlot slot)
        {
            DbInventoryItem item = Inventory?.GetItem((eInventorySlot) slot);

            if (item == null || !GlobalConstants.IsArmor(item.Object_Type))
                return base.GetArmorAbsorb(slot);

            double worn = item.SPD_ABS * 0.01 * (1 + GetModified(eProperty.ArmorAbsorption) * 0.01);
            return Math.Clamp(Math.Max(base.GetArmorAbsorb(slot), worn), 0, 1);
        }

        /// <summary>Handed something. Wear it.</summary>
        public override bool ReceiveItem(GameLiving source, DbInventoryItem item)
        {
            GamePlayer player = source as GamePlayer;

            if (player == null || item == null)
                return base.ReceiveItem(source, item);

            if (!CanWearGear)
            {
                SayTo(player, eChatLoc.CL_SystemWindow, "Hand that to my master, not to me.");
                return false;
            }

            if (player != Employer)
            {
                SayTo(player, eChatLoc.CL_SystemWindow, "I answer to somebody else.");
                return false;
            }

            if (!IsWithinRadius(player, WorldMgr.GIVE_ITEM_DISTANCE))
                return false;

            return MercenaryGear.Equip(this, player, item);
        }

        public override bool Interact(GamePlayer player)
        {
            if (!base.Interact(player))
                return false;

            if (!CanWearGear)
                return true;

            TurnTo(player, 5000);

            string text = RoleDescription + "\n\n";
            List<DbInventoryItem> worn = Inventory != null
                ? Inventory.EquippedItems
                : new List<DbInventoryItem>();

            if (worn.Count == 0)
                text += "I carry nothing of my own. Drag anything out of your pack onto me and I will wear it.\n";
            else
            {
                text += "Carrying:\n";

                foreach (DbInventoryItem item in worn)
                    text += "  " + MercenaryGear.SlotName((eInventorySlot) item.SlotPosition) +
                            ": " + item.Name + "\n";
            }

            text += "\nHow we play it, now [" + MercenaryManager.GetTactic(player) + "] -- say " +
                    "[balanced], [pbaoe] or [focus] to change it. Any of us, any time.\n" +
                    "Say [return] and I will hand all of it back.";
            SayTo(player, eChatLoc.CL_PopupWindow, text);
            return true;
        }

        public override bool WhisperReceive(GameLiving source, string text)
        {
            if (!base.WhisperReceive(source, text))
                return false;

            GamePlayer player = source as GamePlayer;

            if (player == null || player != Employer || !CanWearGear)
                return false;

            string keyword = text.ToLower().Trim();

            // The tactic is a between-pulls decision, so any of them can take
            // the order in the field. There is no walking back to a recruiter.
            switch (keyword)
            {
                case "balanced":
                    Order(player, Tactic.Balanced, "The line holds. We mend whoever needs it most.");
                    return true;

                case "pbaoe":
                    Order(player, Tactic.PBAoE, "On top of you, then. We burn what comes.");
                    return true;

                case "camp":
                {
                    bool camped = !MercenaryManager.IsCamped(player);
                    MercenaryManager.SetCamped(player, camped);
                    player.Out.SendMessage(camped
                        ? "We are staying, then. The fonts go down and we hold this ground."
                        : "Breaking camp. No sense spending a font on ground we are leaving.",
                        eChatType.CT_Say, eChatLoc.CL_ChatWindow);
                    return true;
                }

                case "circle":
                case "line":
                case "column":
                case "wedge":
                {
                    // Qualified from the root: GameNPC has its own Formation
                    // member, which shadows the enum inside anything deriving
                    // from it -- and a relative qualification is itself
                    // resolved against the current namespace.
                    global::DOL.GS.Scripts.Formation formation = keyword switch
                    {
                        "line"   => global::DOL.GS.Scripts.Formation.Line,
                        "column" => global::DOL.GS.Scripts.Formation.Column,
                        "wedge"  => global::DOL.GS.Scripts.Formation.Wedge,
                        _        => global::DOL.GS.Scripts.Formation.Circle,
                    };

                    MercenaryManager.SetFormation(player, formation);
                    SayTo(player, eChatLoc.CL_SystemWindow, formation switch
                    {
                        global::DOL.GS.Scripts.Formation.Line   => "Abreast behind you.",
                        global::DOL.GS.Scripts.Formation.Column => "Single file. Mind the corners.",
                        global::DOL.GS.Scripts.Formation.Wedge  => "Blades to the front, the rest behind them.",
                        _                               => "Around you, then.",
                    });
                    player.Out.SendMessage("Formation: " + formation + ".",
                        eChatType.CT_Important, eChatLoc.CL_SystemWindow);
                    return true;
                }

                case "cc":
                case "mez":
                {
                    bool on = !MercenaryManager.GetCrowdControl(player);
                    MercenaryManager.SetCrowdControl(player, on);
                    SayTo(player, eChatLoc.CL_SystemWindow, on
                        ? "We will put the loose ones to sleep."
                        : "No mez. You will get all of them at once -- that is what you asked for.");
                    player.Out.SendMessage("Crowd control is " + (on ? "on" : "off") + ".",
                        eChatType.CT_Important, eChatLoc.CL_SystemWindow);
                    return true;
                }

                case "focus":
                    Order(player, Tactic.Focus,
                        "Your pet holds them. Not one of us lays a taunt, and it gets the " +
                        "healing first.");
                    return true;
            }

            if (keyword != "return")
                return true;

            int returned = MercenaryGear.ReturnAll(this, player);

            SayTo(player, eChatLoc.CL_SystemWindow, returned == 0
                ? "There is nothing to give back, or nowhere in your pack to put it."
                : "All " + returned + " of them, back where they came from.");
            return true;
        }

        /// <summary>One of them takes the order, and the whole group hears it.</summary>
        private void Order(GamePlayer player, Tactic tactic, string acknowledgement)
        {
            MercenaryManager.SetTactic(player, tactic);
            SayTo(player, eChatLoc.CL_SystemWindow, acknowledgement);

            player.Out.SendMessage("Your group is playing " + tactic + ".",
                eChatType.CT_Important, eChatLoc.CL_SystemWindow);
        }

        // -------------------------------------------------------------------
        // Servants
        // -------------------------------------------------------------------

        /// <summary>How many servants this class should have standing.</summary>
        protected virtual int ServantTarget()
        {
            if (Profile == null || !Profile.Has(Duty.Pet) || Kit == null)
                return 0;

            // A turret class plants a field and keeps planting. One wandering
            // mushroom is not an Animist.
            //
            // The field is bigger at a camp, and deliberately. A turret is
            // planted where it stands and does not follow, so a full field is
            // an investment in ground you are going to keep pulling to -- and
            // so much wasted power on ground you are walking through. Camp is
            // where that investment pays, the same as the Master Level fonts.
            // Turrets are planted, not carried. Outside a camp the company is
            // moving, and a field left behind on ground nobody returns to is
            // power spent on nothing -- so a turret class plants only once you
            // have said you are staying.
            // A commander and its minions is not a turret field.
            //
            // Moving SummonMinion into the turret list made a Bonedancer look
            // like an Animist to the count below, so away from camp it summoned
            // nothing at all -- no commander either. That is backwards: a
            // Bonedancer controls exactly one pet directly, the commander, and
            // everything else answers to it. Kill the commander and the minions
            // are released, which is why it is the one that must always be up.
            //
            // Three minions under it at the top end, four pets in all, and none
            // until level 15 when the first minion summon is learned -- so a
            // young Bonedancer walking around with only a commander is correct
            // and not a fault.
            // A commander, specifically -- not merely a pet and a field.
            //
            // An Animist has both: Forest's Servant is a SummonAnimistPet and
            // lands in PetSummon, and the Tanglers and Sporespawn land in the
            // field. Testing for "has both" therefore caught him too, and he
            // planted whether or not there was a camp, which is the opposite of
            // what the camp rule is for. Only SummonCommander commands.
            if (HasCommander)
                return 1 + MinionsAllowed();

            if (Kit.Turrets.Count > 0)
                return Employer != null && MercenaryManager.IsCamped(Employer)
                    ? TURRET_FIELD
                    : 0;

            return Math.Max(1, Profile.Pets.Length);
        }

        /// <summary>
        /// Stand at camp rather than following, and say whether that happened.
        ///
        /// Two exceptions, and both are the reason a company is worth having.
        /// A hire already fighting finishes the fight -- walking back to camp
        /// mid-swing would be worse than useless. And a healer whose employer
        /// is lying dead goes and gets them; a camp you cannot be resurrected
        /// at is a camp that ends at the first bad pull.
        /// </summary>
        private bool HoldingCamp()
        {
            GameLocation camp = MercenaryManager.CampSpot(Employer);

            if (camp == null)
                return false;

            if (InCombat || attackComponent.AttackState)
                return true;

            // The rescue. A healer breaks camp for a dead employer, brings them
            // back up, and the ordinary rule returns them here afterwards.
            if (Employer.IsAlive == false &&
                Profile != null && Profile.Has(Duty.Heal) && Kit?.Rez != null)
                return false;

            if (CurrentRegionID != camp.RegionID)
            {
                MoveTo(camp.RegionID, camp.X + FormationOffset, camp.Y + FormationOffset,
                       camp.Z, Heading);
                return true;
            }

            int dx = camp.X - X;
            int dy = camp.Y - Y;

            if (dx * dx + dy * dy > CAMP_SPREAD * CAMP_SPREAD)
                WalkTo(new Point3D(camp.X + FormationOffset, camp.Y + FormationOffset, camp.Z),
                       MaxSpeed);

            return true;
        }

        /// <summary>
        /// How far from the camp marker a hire may stand. Wide enough that
        /// eight of them are not inside one another, tight enough that a
        /// point-blank spell centred on any of them still covers the pile.
        /// </summary>
        private const int CAMP_SPREAD = 250;

        /// <summary>
        /// Every turret standing near this hire, whoever planted it -- ours and
        /// the real ones a player Animist puts down.
        /// </summary>
        private int TurretsAround()
        {
            int count = 0;
            ushort radius = (ushort) Math.Max(1, ServerProperties.Properties.TURRET_AREA_CAP_RADIUS);

            foreach (GameNPC npc in GetNPCsInRadius(radius))
            {
                if (npc is MercenaryServant servant)
                {
                    if (servant.Stationary)
                        count++;
                }
                // Qualified from the root: we are inside DOL.GS.Scripts, so a
                // bare DOL.AI.Brain resolves to DOL.GS.Scripts.DOL.AI.Brain.
                else if (npc.Brain is global::DOL.AI.Brain.TurretFNFBrain)
                    count++;
            }

            return count;
        }

        /// <summary>Sends every servant of this hire home.</summary>
        protected void RetireServants()
        {
            if (Employer == null)
                return;

            List<GameMercenary> company = MercenaryManager.GetCompany(Employer);

            foreach (GameMercenary mate in new List<GameMercenary>(company))
            {
                if (mate is MercenaryServant servant && servant.Master == this)
                {
                    company.Remove(servant);
                    servant.Retire();
                }
            }
        }

        /// <summary>
        /// Keeps exactly the right number of servants standing.
        ///
        /// This is the only thing that summons them, which is the point: the
        /// count is derived from what the class should have rather than added
        /// to by whatever happened to call a summon. It sweeps the dead, so an
        /// Animist replaces burnt turrets the way an Animist does, and it
        /// retires the surplus, so nothing accumulates across a zone line.
        /// </summary>
        protected void MaintainServants()
        {
            if (Employer == null || Profile == null || !Profile.Has(Duty.Pet))
                return;

            List<GameMercenary> company = MercenaryManager.GetCompany(Employer);
            List<MercenaryServant> mine = new();

            foreach (GameMercenary mate in new List<GameMercenary>(company))
            {
                if (mate is not MercenaryServant servant || servant.Master != this)
                    continue;

                if (!servant.IsAlive || servant.ObjectState != eObjectState.Active)
                {
                    company.Remove(servant);
                    servant.Retire();
                    continue;
                }

                mine.Add(servant);
            }

            WearShadeIfPetIsUp(mine.Count);

            int target = ServantTarget();

            for (int i = mine.Count - 1; i >= target && i >= 0; i--)
            {
                company.Remove(mine[i]);
                mine[i].Retire();
                mine.RemoveAt(i);
            }

            if (mine.Count >= target)
                return;

            // Honour the turret area cap, which nothing else here does.
            //
            // Core enforces two caps in SummonAnimistFnF.CheckBeginCast -- ten
            // turrets within a thousand units, and twelve per caster -- but a
            // hire never goes near that code. It summons through SummonServant,
            // and its turrets carry a MercenaryBrain rather than a
            // TurretFNFBrain, so they are invisible to the area scan as well.
            // The result was no cap at all: seven Animist hires at a camp would
            // plant thirty-five turrets and nothing would object, which is both
            // a framerate problem and a good reason to hire nothing else.
            //
            // Counting hire turrets and real ones together means a player
            // Animist and the company share one budget, which is the point of
            // an area cap.
            if (Kit.Turrets.Count > 0 && TurretsAround() >= ServerProperties.Properties.TURRET_AREA_CAP_COUNT)
                return;

            // Paced, because summoning is a cast. Turrets should appear at the
            // speed somebody plants them, not all at once.
            if (GameLoop.GameLoopTime < _nextServant)
                return;

            _nextServant = GameLoop.GameLoopTime + SERVANT_INTERVAL;
            SummonServant(mine.Count);
        }

        /// <summary>
        /// A Necromancer stands as a shade while its pet is up.
        ///
        /// The core mechanic is a player one -- CharacterClass.Shade, gated on
        /// HasShadeModel -- and a hire is a GameNPC, so none of it applies to
        /// them. What it comes down to is the model, and that we can do: 1353
        /// is the Briton shade, which is the right shape for an Albion
        /// Necromancer.
        ///
        /// It goes back to its own face when the pet goes, so a Necromancer
        /// standing there in flesh is a Necromancer that has lost its pet --
        /// worth being able to see at a glance across a fight.
        /// </summary>
        /// <summary>
        /// Air, when the group is under water.
        ///
        /// Nobody was ever going to ask for this in the half-minute before they
        /// drowned, and a hire holding a spell that stops it is no use if it
        /// waits to be told. Cast on sight of water and left to run; it is half
        /// an hour long and group targeted, so one cast covers everybody who
        /// came in with you.
        ///
        /// Deliberately not gated on being in combat or out of it. Drowning
        /// does not care which you are.
        /// </summary>
        private void KeepGroupBreathing()
        {
            if (Kit?.WaterBreathing == null || Employer == null || !IsAlive)
                return;

            // Somebody has to actually be in the water -- the hire itself or
            // the employer, since one of them reaches it first.
            if (!IsUnderwater && !Employer.IsUnderwater)
                return;

            // CanBreathUnderWater belongs to GamePlayer rather than to an NPC,
            // and the employer is the one who drowns, so his is the answer that
            // matters. If he is already covered the group is.
            if (Employer.CanBreathUnderWater)
                return;

            CastAt(this, Kit.WaterBreathing, 60000);
        }

        /// <summary>
        /// The Bainshee's fighting form.
        ///
        /// She is a wailing spirit and takes the shape when she goes to work --
        /// her whole line is sound and her spells are screams. The core has a
        /// BainsheePulseDmgSpellHandler for the auras and it never touches the
        /// model, so nothing anywhere put her in the form; she fought as an
        /// ordinary elf.
        ///
        /// Driven by combat rather than by a spell, because there is no form
        /// spell in the data to hang it on -- the four lines she has carry
        /// screams, bolts and wards and nothing that shifts shape.
        /// </summary>
        private void WearSpectralForm()
        {
            if (Profile == null || Profile.ClassId is not eCharacterClass.Bainshee)
                return;

            bool fighting = InCombat || attackComponent.AttackState;
            ushort wanted = fighting ? BAINSHEE_MODEL : Profile.Model;

            if (Model == wanted)
                return;

            Model = wanted;

            foreach (GamePlayer nearby in GetPlayersInRadius(WorldMgr.VISIBILITY_DISTANCE))
                nearby.Out.SendModelChange(this, wanted);
        }

        /// <summary>
        /// The spectral shape. Model 1885 is the game's own banshee, used by 56
        /// NPCs -- not a ghost picked to look about right.
        /// </summary>
        private const ushort BAINSHEE_MODEL = 1885;

        private void WearShadeIfPetIsUp(int crop)
        {
            if (Profile == null || Profile.ClassId is not eCharacterClass.Necromancer)
                return;

            // The shade is not a costume. While the servant lives the
            // Necromancer cannot be targeted or damaged at all -- to kill one
            // you kill the pet first, and only then does the shade become
            // something you can hit. Wearing the model without the flags gave
            // us the look of it and none of the rule.
            bool shaded = crop > 0;
            eFlags want = shaded
                ? Flags | eFlags.GHOST | eFlags.CANTTARGET
                : Flags & ~(eFlags.GHOST | eFlags.CANTTARGET);

            if (Flags != want)
            {
                Flags = want;

                // Flags ride along with the create packet rather than an
                // update, so the shade has to be redrawn before it is
                // untargetable on anybody's screen.
                foreach (GamePlayer nearby in GetPlayersInRadius(WorldMgr.VISIBILITY_DISTANCE))
                    nearby.Out.SendNPCCreate(this);
            }

            ushort wanted = shaded ? SHADE_MODEL : Profile.Model;

            if (Model == wanted)
                return;

            Model = wanted;

            foreach (GamePlayer nearby in GetPlayersInRadius(WorldMgr.VISIBILITY_DISTANCE))
                nearby.Out.SendModelChange(this, wanted);
        }

        /// <summary>Briton shade -- what GamePlayer.ShadeModel picks by race.</summary>
        private const ushort SHADE_MODEL = 1353;

        /// <summary>
        /// A Necromancer with its servant up: a shade, which commands rather
        /// than casts and cannot be touched until the servant falls.
        /// </summary>
        protected bool Shaded =>
            Profile != null &&
            Profile.ClassId is eCharacterClass.Necromancer &&
            (Flags & eFlags.CANTTARGET) != 0;

        /// <summary>The summon this class would actually cast.</summary>
        protected virtual Spell ServantSpell()
        {
            return ServantSpell(0);
        }

        /// <summary>What to summon for this slot.</summary>
        protected virtual Spell ServantSpell(int index)
        {
            if (Kit == null)
                return null;

            // Slot zero is the commander. The rest are the crowd it answers for.
            if (HasCommander)
            {
                if (index == 0)
                    return Kit.PetSummon;

                Spell mender = null;
                Spell best = null;

                foreach (Spell minion in Kit.Turrets)
                {
                    if (best == null || minion.Level > best.Level)
                        best = minion;

                    if (MercenaryLoadout.IsHealingMinion(minion) &&
                        (mender == null || minion.Level > mender.Level))
                        mender = minion;
                }

                // At camp the crowd is menders: a Bonedancer holding a pull
                // spot wants the group kept standing, and on his own they are
                // what keeps HIM standing. On the move he takes what fights.
                bool camped = Employer != null && MercenaryManager.IsCamped(Employer);

                return camped && mender != null ? mender : best ?? Kit.PetSummon;
            }

            // At camp, a class that can summon menders summons menders.
            //
            // A Bonedancer standing at a pull camp wants the crowd behind it
            // keeping the group up, not six more skeletons swinging. Away from
            // camp it goes back to whatever it fights best with, because a
            // mender that cannot keep up with a moving group is a wasted
            // summon.
            if (Employer != null && MercenaryManager.IsCamped(Employer))
            {
                Spell mender = null;

                foreach (Spell summon in Kit.Turrets)
                {
                    if (!MercenaryLoadout.IsHealingMinion(summon))
                        continue;

                    if (mender == null || summon.Level > mender.Level)
                        mender = summon;
                }

                if (mender != null)
                    return mender;
            }

            // The best turret is not simply the last one learned.
            //
            // An Animist knows four families of them and only two are for
            // fighting. Creeping Path plants Sporespawn and Spore Cannons;
            // Verdant Path plants Vents of Physical Protection and Ligneous
            // Seals, which are wards. Taking the highest level turret known
            // planted wards at a point-blank camp -- correct by level, useless
            // by purpose, and it looked exactly like the bomb group being
            // broken.
            //
            // The templates say which is which without any guessing at names:
            // a fighting turret carries a spell aimed at an enemy, and a ward
            // carries nothing at all. Prefer one that does; fall back to the
            // highest level if this class has no such thing.
            if (Kit.Turrets.Count > 0)
            {
                Spell best = null;

                foreach (Spell turret in Kit.Turrets)
                {
                    if (!MercenaryLoadout.IsFightingTurret(turret))
                        continue;

                    if (best == null || turret.Level > best.Level)
                        best = turret;
                }

                return best ?? Kit.Turrets[Kit.Turrets.Count - 1];
            }

            return Kit.PetSummon;
        }

        /// <summary>
        /// Calls up one servant, wearing whatever the game says that spell
        /// summons -- the real name, the real model, the real size.
        /// </summary>
        protected void SummonServant(int index)
        {
            if (Employer == null)
                return;

            Spell summon = ServantSpell(index);
            DbNpcTemplate template = MercenaryLoadout.PetTemplate(summon);

            string label;
            ushort model;
            ushort size;

            if (template != null)
            {
                label = template.Name;
                // Random, not first: an underhill ally has thirty-two
                // models and is meant to be any of them.
                model = MercenaryLoadout.AnyOf(template.Model, FALLBACK_MODEL);
                size  = MercenaryLoadout.FirstOf(template.Size, 45);
            }
            else
            {
                // No data for it: fall back to whatever the roster named, which
                // is the old behaviour and is only cosmetic.
                label = Profile.Pets.Length > 0
                    ? Profile.Pets[index % Profile.Pets.Length]
                    : "servant";
                model = FALLBACK_MODEL;
                size  = 45;
            }

            bool turret = Kit != null && Kit.Turrets.Count > 0;

            // Planted around the caster rather than stacked on it, so a field
            // of turrets covers ground instead of being one pile.
            int spread = 40 + index * 35;
            int angle  = index * 2048 / Math.Max(1, ServantTarget());

            MercenaryServant servant = new MercenaryServant();
            servant.Master = this;
            servant.Profile = Profile;
            servant.Configure(Employer, MercenaryManager.GetTier(Employer));
            servant.Shape(label, model, size);
            servant.Stationary = turret;

            // Slot zero of a commander class is the commander itself.
            servant.Commands = index == 0 && HasCommander;

            // Everything after slot zero answers to whatever is standing in it.
            if (HasCommander && index > 0)
            {
                foreach (GameMercenary mate in MercenaryManager.GetCompany(Employer))
                {
                    if (mate is MercenaryServant boss && boss.Master == this && boss.Commands)
                    {
                        servant.Commander = boss;
                        break;
                    }
                }
            }

            // A turret is a bomb on a stick. It cannot chase, so what it has is
            // reach and a blast -- the caster's own area spell, which is what
            // makes a field of them level whatever walks in.
            if (turret)
            {
                servant.Bombs = Kit.Pbaoe ?? Kit.AreaNuke ?? Kit.Nuke;

                // Planted, literally: an NPC with no speed cannot be walked
                // anywhere by anything, which is simpler and more reliable
                // than teaching the brain about turrets.
                servant.MaxSpeedBase = 0;
            }

            servant.X = X + (int) (spread * Math.Cos(angle * Math.PI / 1024.0));
            servant.Y = Y + (int) (spread * Math.Sin(angle * Math.PI / 1024.0));
            servant.Z = Z;
            servant.Heading = Heading;
            servant.CurrentRegion = CurrentRegion;
            servant.SetOwnBrain(new MercenaryBrain(Employer));
            servant.AddToWorld();
            MercenaryManager.Register(Employer, servant);
        }

        /// <summary>How many turrets a turret class keeps planted.</summary>
        private const int TURRET_FIELD = 5;

        /// <summary>
        /// What a turret class plants when the group is on the move. Enough to
        /// still be an Animist, few enough that the field is worth making camp
        /// for.
        /// </summary>
        private const int TURRET_ROAMING = 2;

        /// <summary>
        /// Minions a commander will answer for. Three at the top end, four pets
        /// counting the commander itself.
        /// </summary>
        private const int MINION_LIMIT = 3;

        /// <summary>
        /// Whether this class fields a commander with a crowd under it, rather
        /// than a pet and a field of turrets, which are not the same thing.
        /// </summary>
        protected bool HasCommander =>
            Kit?.PetSummon != null &&
            Kit.PetSummon.SpellType is eSpellType.SummonCommander &&
            Kit.Turrets.Count > 0;

        /// <summary>
        /// The commander's total level budget for minions.
        ///
        /// Live caps the summed levels of everything under a commander at 75,
        /// which is why three minions at their own maximum is not a thing
        /// anyone has ever fielded: at 75 per cent of a level 50 master they
        /// come out at 37 apiece, and two of those is already 74.
        /// </summary>
        private const int MINION_LEVEL_BUDGET = 75;

        /// <summary>
        /// How many minions this commander can answer for, by the budget.
        /// </summary>
        private int MinionsAllowed()
        {
            if (Kit == null || Kit.Turrets.Count == 0)
                return 0;

            // What one will come out at: the summon's own level, or three
            // quarters of the master's, whichever the game would actually give.
            int each = 0;

            foreach (Spell minion in Kit.Turrets)
                each = Math.Max(each, Math.Min(minion.Level, Level * 3 / 4));

            if (each <= 0)
                return Math.Min(MINION_LIMIT, Kit.Turrets.Count);

            return Math.Clamp(MINION_LEVEL_BUDGET / each, 0,
                              Math.Min(MINION_LIMIT, Kit.Turrets.Count));
        }

        /// <summary>Pacing between summons, so a field goes up like a field.</summary>
        private const int SERVANT_INTERVAL = 2500;

        /// <summary>Only ever reached when a summon has no template at all.</summary>
        private const ushort FALLBACK_MODEL = 1910;

        private long _nextServant;
    }

    /// <summary>A servant belonging to a hire rather than to the player.</summary>
    public class MercenaryServant : GameMercenary
    {
        public override void Die(GameObject killer)
        {
            // The commander falling releases everything under it. Done before
            // the base call, while this servant is still the one the others can
            // be matched against.
            if (Commands && Master != null)
            {
                foreach (GameMercenary other in
                         new List<GameMercenary>(MercenaryManager.GetCompany(Employer)))
                {
                    if (other is MercenaryServant minion && ReferenceEquals(minion.Commander, this))
                        minion.Retire();
                }

                Employer?.Out.SendMessage(
                    Master.RoleName + "'s commander falls, and its minions crumble with it.",
                    eChatType.CT_System, eChatLoc.CL_SystemWindow);
            }

            base.Die(killer);
        }

        /// <summary>Who summoned it, so it can be dismissed and resummoned.</summary>
        public GameMercenary Master;

        private string _label = "Servant";
        private ushort _model = 1910;

        /// <summary>Planted where it was summoned. A turret does not follow.</summary>
        public bool Stationary;

        /// <summary>
        /// The one the rest answer to.
        ///
        /// A Bonedancer controls exactly one pet directly and every minion is
        /// the commander's, not his -- so killing the commander releases the
        /// whole crowd at once. That is how a bone army is taken apart, and
        /// without it the commander is just the first of four things to kill.
        /// </summary>
        public bool Commands;

        /// <summary>
        /// The commander this one answers to, or null if it answers to nobody.
        ///
        /// A Bonedancer does not own his minions. He owns the commander, the
        /// commander owns the minions, and it lends them to him -- which is why
        /// they follow it rather than him, fight what it fights, and fall when
        /// it falls. Master stays pointed at the hire so the bookkeeping that
        /// counts and replaces servants still works; this is the chain of
        /// command laid over the top of it.
        /// </summary>
        public MercenaryServant Commander;

        /// <summary>What it throws when something comes into reach.</summary>
        public Spell Bombs;

        public override bool CanWearGear => false;
        public override string RoleName => _label;
        public override string RoleKey => "servant";
        public override bool EngagesInMelee => true;

        public void Shape(string label, ushort model, ushort size)
        {
            _label = label;
            _model = model;
            Name = label;
            Model = model;
            Size = (byte) Math.Clamp((int) size, 10, 255);
        }

        /// <summary>
        /// A servant fights; it does not run its master's duties.
        ///
        /// A turret is the exception: it cannot close, so if it does not throw
        /// something it does nothing at all.
        /// </summary>
        public override void RoleThink(GamePlayer owner)
        {
            if (Bombs == null)
                return;

            GameLiving foe = FoeOf(owner);

            if (foe == null)
                return;

            int reach = Bombs.Range > 0 ? Bombs.Range : Math.Max(350, Bombs.Radius);

            if (IsWithinRadius(foe, reach))
                CastAt(foe, Bombs, 3000);
        }

        public override void ApplyTier(int tier)
        {
            base.ApplyTier(tier);
            Level = (byte) (Level > 4 ? Level - 4 : 1);
            Health = MaxHealth;
        }

        public override bool AddToWorld()
        {
            // Servants do not bring servants of their own.
            Profile = null;
            return base.AddToWorld();
        }
    }
    /// <summary>
    /// Puts the company back in the field when its employer logs in.
    ///
    /// A mercenary is an ordinary NPC and does not outlive the session, but
    /// the roster and the gear both live in the database, so nothing is
    /// actually lost -- they are simply rebuilt, still carrying whatever the
    /// player handed them. Which matters: those are the player's own items.
    /// </summary>
    public static class MercenaryMuster
    {
        /// <summary>How battered the group is when it picks itself back up.</summary>
        private const int HEALTH_ON_RELEASE = 25;

        [ScriptLoadedEvent]
        public static void OnScriptLoaded(DOLEvent e, object sender, EventArgs args)
        {
            GameEventMgr.AddHandler(GamePlayerEvent.GameEntered, new DOLEventHandler(Muster));
            GameEventMgr.AddHandler(GameLivingEvent.Dying, new DOLEventHandler(Fall));
            GameEventMgr.AddHandler(GamePlayerEvent.Released, new DOLEventHandler(Regroup));
            GameEventMgr.AddHandler(GamePlayerEvent.Revive, new DOLEventHandler(Regroup));
            GameEventMgr.AddHandler(GamePlayerEvent.Quit, new DOLEventHandler(Detach));
            GameEventMgr.AddHandler(GamePlayerEvent.Linkdeath, new DOLEventHandler(Detach));
            GameEventMgr.AddHandler(GamePlayerEvent.LeaveGroup, new DOLEventHandler(Detach));
        }

        [ScriptUnloadedEvent]
        public static void OnScriptUnloaded(DOLEvent e, object sender, EventArgs args)
        {
            GameEventMgr.RemoveHandler(GamePlayerEvent.GameEntered, new DOLEventHandler(Muster));
            GameEventMgr.RemoveHandler(GameLivingEvent.Dying, new DOLEventHandler(Fall));
            GameEventMgr.RemoveHandler(GamePlayerEvent.Released, new DOLEventHandler(Regroup));
            GameEventMgr.RemoveHandler(GamePlayerEvent.Revive, new DOLEventHandler(Regroup));
            GameEventMgr.RemoveHandler(GamePlayerEvent.Quit, new DOLEventHandler(Detach));
            GameEventMgr.RemoveHandler(GamePlayerEvent.Linkdeath, new DOLEventHandler(Detach));
            GameEventMgr.RemoveHandler(GamePlayerEvent.LeaveGroup, new DOLEventHandler(Detach));
        }

        /// <summary>The group reforms on login.</summary>
        private static void Muster(DOLEvent e, object sender, EventArgs args)
        {
            GamePlayer player = sender as GamePlayer;

            if (player == null)
                return;

            int fielded = MercenaryManager.RestoreRoster(player);

            if (fielded == 0)
                return;

            player.Out.SendMessage(
                "Your group falls in around you. (" + fielded + ")",
                eChatType.CT_Important, eChatLoc.CL_SystemWindow);

            // Say what was loaded, so a setting that did not survive the night
            // is obvious on sight rather than inferred from behaviour.
            player.Out.SendMessage(
                "Tactic " + MercenaryManager.GetTactic(player) +
                ", formation " + MercenaryManager.GetFormation(player) +
                ", crowd control " + (MercenaryManager.GetCrowdControl(player) ? "on" : "off") + ".",
                eChatType.CT_Important, eChatLoc.CL_SystemWindow);
        }

        /// <summary>
        /// Takes the hires out of the group before their employer leaves it.
        ///
        /// This is not tidiness, it is a crash. Group.RemoveMember picks a new
        /// leader with
        ///
        ///     _groupMembers.OfType&lt;GamePlayer&gt;().First() ?? _groupMembers[0]
        ///
        /// and First() throws on an empty sequence rather than returning null,
        /// so the ?? fallback never runs. A group holding nothing but hires --
        /// which is exactly what is left the moment the player is removed --
        /// therefore throws straight through GamePlayer.CleanupOnDisconnect.
        /// The character is then never properly deleted, and the next login
        /// reports being replaced before deletion.
        ///
        /// Core never had to handle a group of only NPCs. Putting them in the
        /// group is what made it reachable, so leaving it safe is ours to do.
        /// </summary>
        private static void Detach(DOLEvent e, object sender, EventArgs args)
        {
            GamePlayer player = sender as GamePlayer;

            if (player?.Group == null)
                return;

            // Read the GROUP, not our own roster.
            //
            // This used to walk MercenaryManager.GetCompany and remove each
            // hire it found. That trusts our bookkeeping to be a perfect mirror
            // of the group, and when it is not -- a servant registered but
            // never grouped, a hire whose ObjectState had already flipped, a
            // company list pruned a moment too early -- a hire stays in the
            // group, the player leaves, and Group.RemoveMember throws exactly
            // as before. It came back on a fresh character doing nothing
            // unusual.
            //
            // The group knows who is in the group. Anything in it that is not
            // a player comes out, and there is nothing left to be wrong about.
            Group group = player.Group;

            foreach (GameLiving member in new List<GameLiving>(group.GetMembersInTheGroup()))
            {
                if (member is not GamePlayer)
                    group.RemoveMember(member);
            }
        }

        /// <summary>
        /// The group goes down with its employer -- unless somebody can pick
        /// them back up.
        ///
        /// If a healer is still standing and old enough to have a resurrection,
        /// they stay and work: dying next to a live healer should mean a rez,
        /// not a run from the graveyard. Only when there is nobody left to
        /// raise you does the group fall with you.
        /// </summary>
        private static void Fall(DOLEvent e, object sender, EventArgs args)
        {
            GamePlayer player = sender as GamePlayer;

            if (player == null)
                return;

            List<GameMercenary> company = MercenaryManager.GetCompany(player);

            if (company.Count == 0)
                return;

            foreach (GameMercenary merc in company)
            {
                if (merc.CanRaise)
                {
                    player.Out.SendMessage(
                        "Your " + merc.RoleName + " is still standing. Hold on -- wait for the rez.",
                        eChatType.CT_Important, eChatLoc.CL_SystemWindow);
                    return;
                }
            }

            foreach (GameMercenary merc in new List<GameMercenary>(company))
                merc.Retire();

            company.Clear();

            player.Out.SendMessage(
                "Nobody is left standing to raise you. Your group falls with you.",
                eChatType.CT_Important, eChatLoc.CL_SystemWindow);
        }

        /// <summary>
        /// Back on their feet with you, and in no better shape than you are.
        /// Somebody has to sit and mend everyone before the next pull.
        /// </summary>
        private static void Regroup(DOLEvent e, object sender, EventArgs args)
        {
            GamePlayer player = sender as GamePlayer;

            if (player == null)
                return;

            // Revive fires for a healer's resurrection as well as a release.
            // If the group is still standing -- which is the whole point of
            // being raised rather than releasing -- leave them alone. Rebuilding
            // deleted six live hires and made six new ones on top of the player,
            // mid-dungeon, for no reason at all.
            if (MercenaryManager.GetCompany(player).Count > 0)
                return;

            int fielded = MercenaryManager.RestoreRoster(player);

            if (fielded == 0)
                return;

            foreach (GameMercenary merc in MercenaryManager.GetCompany(player))
                merc.Health = Math.Max(1, merc.MaxHealth * HEALTH_ON_RELEASE / 100);

            player.Out.SendMessage(
                "Your group picks itself up around you, in no better shape than you are.",
                eChatType.CT_Important, eChatLoc.CL_SystemWindow);
        }
    }

    /// <summary>
    /// An ordinary NPC inventory that starts out empty, so a mercenary can be
    /// handed gear a piece at a time rather than stamped from a template.
    /// </summary>
    public class MercenaryInventory : GameNPCInventory
    {
        public MercenaryInventory() : base(new GameNpcInventoryTemplate()) { }
    }

    /// <summary>
    /// Gear.
    ///
    /// A mercenary wears real player items -- the very same database rows the
    /// player was carrying, moved rather than copied. No row is ever created or
    /// deleted along the way, so there is no path here that duplicates an item
    /// or loses one.
    ///
    /// The rows are parked under an owner id of "&lt;player&gt;-merc-&lt;role&gt;", which
    /// is what makes the gear stick: a role picks its kit back up on the next
    /// hire, and across restarts. Nothing else reads that id, so the items are
    /// invisible to the player's own inventory until they are handed back.
    ///
    /// Anything goes on -- no class, realm or level restrictions. These are
    /// bots under the player's hand, not characters of their own.
    /// </summary>
    public static class MercenaryGear
    {
        public static string InventoryId(GamePlayer owner, string role)
        {
            return owner.InternalID + "-merc-" + role;
        }

        /// <summary>Where an item may go, best slot first, or null if nowhere.</summary>
        public static eInventorySlot[] SlotsFor(DbInventoryItem item)
        {
            switch (item.Item_Type)
            {
                case Slot.RIGHTHAND:
                    // A one-hander will take the off hand if the main one is full.
                    return new[] { eInventorySlot.RightHandWeapon, eInventorySlot.LeftHandWeapon };
                case Slot.LEFTHAND:
                case Slot.SHIELD:
                    return new[] { eInventorySlot.LeftHandWeapon };
                case Slot.TWOHAND:
                    return new[] { eInventorySlot.TwoHandWeapon };
                case Slot.RANGED:
                    return new[] { eInventorySlot.DistanceWeapon };
                case Slot.FOREARMS:
                case Slot.LEFTWRIST:
                case Slot.RIGHTWRIST:
                    return new[] { eInventorySlot.RightBracer, eInventorySlot.LeftBracer };
                case Slot.LEFTRING:
                case Slot.RIGHTRING:
                    return new[] { eInventorySlot.RightRing, eInventorySlot.LeftRing };
                default:
                    eInventorySlot slot = (eInventorySlot) item.Item_Type;
                    return GameLivingInventory.EquipmentSlots.Contains(slot)
                        ? new[] { slot }
                        : null;
            }
        }

        /// <summary>
        /// Why this one cannot wear that, or null if they can.
        ///
        /// Judged on the class's own armour proficiency, the same ability the
        /// game checks for a player -- so an Eldritch refuses plate for exactly
        /// the reason an Eldritch always has. Handing them anything at all was
        /// right while they were bots in costume; now they are real classes it
        /// is just a way to waste good armour.
        /// </summary>
        public static string WhyNot(GameMercenary merc, DbInventoryItem item)
        {
            if (GlobalConstants.IsWeapon(item.Object_Type))
            {
                // Weapons are trained for, exactly like armour.
                //
                // This used to wave everything through -- "weapons and
                // jewellery: their business" -- and it was not their business
                // at all. Hand a Blademaster a bow and core does the rest:
                // InitializeActiveWeaponFromInventory switches an NPC to the
                // distance slot the moment one is in its inventory, ahead of
                // any melee weapon, and AttackComponent switches it BACK to
                // ranged every time its aggro list empties. One gift turned a
                // melee class into a permanent archer.
                if (!MercenaryLoadout.CanWield(merc, item))
                {
                    return "I have never been trained with " +
                           ((eObjectType) item.Object_Type).ToString().ToLower() +
                           ". Give it to somebody who has.";
                }

                return null;
            }

            if (!GlobalConstants.IsArmor(item.Object_Type))
                return null; // Jewellery: their business.

            int allowed = Math.Max(merc.GetAbilityLevel(Abilities.AlbArmor),
                          Math.Max(merc.GetAbilityLevel(Abilities.HibArmor),
                                   merc.GetAbilityLevel(Abilities.MidArmor)));

            int needed = (eObjectType) item.Object_Type switch
            {
                eObjectType.GenericArmor => ArmorLevel.GenericArmor,
                eObjectType.Cloth        => ArmorLevel.Cloth,
                eObjectType.Leather      => ArmorLevel.Leather,
                eObjectType.Reinforced   => ArmorLevel.Studded,
                eObjectType.Studded      => ArmorLevel.Studded,
                eObjectType.Scale        => ArmorLevel.Chain,
                eObjectType.Chain        => ArmorLevel.Chain,
                eObjectType.Plate        => ArmorLevel.Plate,
                _                        => ArmorLevel.GenericArmor,
            };

            if (allowed >= needed)
                return null;

            return "I am not trained for " +
                   ((eObjectType) item.Object_Type).ToString().ToLower() +
                   ". Give it to somebody who is.";
        }

        public static string SlotName(eInventorySlot slot)
        {
            switch (slot)
            {
                case eInventorySlot.RightHandWeapon: return "right hand";
                case eInventorySlot.LeftHandWeapon:  return "left hand";
                case eInventorySlot.TwoHandWeapon:   return "two hands";
                case eInventorySlot.DistanceWeapon:  return "ranged";
                case eInventorySlot.HeadArmor:       return "head";
                case eInventorySlot.HandsArmor:      return "hands";
                case eInventorySlot.FeetArmor:       return "feet";
                case eInventorySlot.TorsoArmor:      return "chest";
                case eInventorySlot.Cloak:           return "cloak";
                case eInventorySlot.LegsArmor:       return "legs";
                case eInventorySlot.ArmsArmor:       return "arms";
                case eInventorySlot.Neck:            return "neck";
                case eInventorySlot.Jewelry:         return "jewel";
                case eInventorySlot.Waist:           return "waist";
                case eInventorySlot.LeftBracer:      return "left wrist";
                case eInventorySlot.RightBracer:     return "right wrist";
                case eInventorySlot.LeftRing:        return "left ring";
                case eInventorySlot.RightRing:       return "right ring";
                case eInventorySlot.Mythical:        return "mythical";
                default:                             return slot.ToString();
            }
        }

        /// <summary>Gives a freshly fielded mercenary back the kit it was left with.</summary>
        public static void Load(GameMercenary merc)
        {
            merc.Inventory = new MercenaryInventory();

            if (merc.Employer == null || !merc.CanWearGear)
                return;

            string id = InventoryId(merc.Employer, merc.RoleKey);
            var stored = DOLDB<DbInventoryItem>.SelectObjects(DB.Column("OwnerID").IsEqualTo(id));

            if (stored == null)
                return;

            foreach (DbInventoryItem item in stored)
            {
                eInventorySlot slot = (eInventorySlot) item.SlotPosition;

                if (!GameLivingInventory.EquipmentSlots.Contains(slot) ||
                    merc.Inventory.GetItem(slot) != null)
                    continue;

                merc.Inventory.AddItem(slot, item);
                item.OwnerID = id; // AddItem clears it; the row has to keep pointing here.
            }

            merc.InitializeActiveWeaponFromInventory();
        }

        /// <summary>Moves one item from the player's pack onto the mercenary.</summary>
        public static bool Equip(GameMercenary merc, GamePlayer player, DbInventoryItem item)
        {
            eInventorySlot[] candidates = SlotsFor(item);

            if (candidates == null)
            {
                merc.SayTo(player, eChatLoc.CL_SystemWindow,
                    "I would not know where to put the " + item.Name + ".");
                return false;
            }

            string refusal = WhyNot(merc, item);

            if (refusal != null)
            {
                merc.SayTo(player, eChatLoc.CL_SystemWindow, refusal);
                return false;
            }

            eInventorySlot target = candidates[0];

            foreach (eInventorySlot slot in candidates)
            {
                if (merc.Inventory.GetItem(slot) == null)
                {
                    target = slot;
                    break;
                }
            }

            DbInventoryItem displaced = merc.Inventory.GetItem(target);

            // Take it out of the pack without deleting the row -- this is a
            // change of owner, not a destroy and recreate.
            if (!player.Inventory.RemoveItemWithoutDbDeletion(item))
                return false;

            // Whatever was in that slot goes back, into the slot this item just
            // vacated. If that somehow fails, put the item back where it came
            // from and stop -- better a refused trade than a lost one.
            if (displaced != null && !Return(merc, player, displaced))
            {
                eInventorySlot back = player.Inventory.FindFirstEmptySlot(
                    eInventorySlot.FirstBackpack, eInventorySlot.LastBackpack);

                if (back != eInventorySlot.Invalid)
                    player.Inventory.AddItem(back, item);

                merc.SayTo(player, eChatLoc.CL_SystemWindow, "Your pack is too full to trade.");
                return false;
            }

            if (!merc.Inventory.AddItem(target, item))
            {
                eInventorySlot back = player.Inventory.FindFirstEmptySlot(
                    eInventorySlot.FirstBackpack, eInventorySlot.LastBackpack);

                if (back != eInventorySlot.Invalid)
                    player.Inventory.AddItem(back, item);

                return false;
            }

            item.OwnerID = InventoryId(player, merc.RoleKey);
            GameServer.Database.SaveObject(item);

            Refresh(merc);

            merc.SayTo(player, eChatLoc.CL_SystemWindow, displaced == null
                ? "The " + item.Name + " suits me."
                : "The " + item.Name + " suits me. Take the " + displaced.Name + " back.");
            return true;
        }

        /// <summary>Hands one item back to the player's pack.</summary>
        public static bool Return(GameMercenary merc, GamePlayer player, DbInventoryItem item)
        {
            eInventorySlot free = player.Inventory.FindFirstEmptySlot(
                eInventorySlot.FirstBackpack, eInventorySlot.LastBackpack);

            if (free == eInventorySlot.Invalid)
                return false;

            eInventorySlot held = (eInventorySlot) item.SlotPosition;

            merc.Inventory.RemoveItem(item);

            // If the pack refuses it, put it straight back where it was. The
            // window between the two is the only moment this item belongs to
            // nobody, and it does not get to end there.
            if (!player.Inventory.AddItem(free, item))
            {
                merc.Inventory.AddItem(held, item);
                item.OwnerID = InventoryId(player, merc.RoleKey);
                GameServer.Database.SaveObject(item);
                return false;
            }

            item.OwnerID = player.InternalID;
            GameServer.Database.SaveObject(item);
            return true;
        }

        /// <summary>Strips a mercenary. Stops early rather than drop anything.</summary>
        public static int ReturnAll(GameMercenary merc, GamePlayer player)
        {
            if (merc.Inventory == null)
                return 0;

            int returned = 0;

            foreach (DbInventoryItem item in new List<DbInventoryItem>(merc.Inventory.EquippedItems))
            {
                if (!Return(merc, player, item))
                    break; // Pack is full. What is left stays on them.

                returned++;
            }

            Refresh(merc);
            return returned;
        }

        /// <summary>
        /// Pulls back gear left with a role that is not in the field, so a kit
        /// can never be stranded on a mercenary the player stops hiring.
        /// </summary>
        public static int Recover(GamePlayer player)
        {
            int recovered = 0;

            // Anyone in the field holds their kit in memory, so take that first
            // or the two copies would fight over the same rows.
            foreach (GameMercenary merc in new List<GameMercenary>(MercenaryManager.GetCompany(player)))
            {
                if (merc.CanWearGear)
                    recovered += ReturnAll(merc, player);
            }

            // Swept by owner-id PREFIX, not by walking the list of known
            // classes. This is the difference between a safety net and a
            // guess: gear left under a name the roster no longer has -- a
            // class renamed, a role retired, anything at all -- would be
            // invisible to a per-class sweep and stranded in the database
            // forever. A prefix match cannot miss a bucket, whatever it is
            // called. This is the player's own hard-won gear; it does not get
            // to depend on the roster staying the same shape.
            var stored = DOLDB<DbInventoryItem>.SelectObjects(
                DB.Column("OwnerID").IsLike(player.InternalID + "-merc-%"));

            if (stored == null)
                return recovered;

            foreach (DbInventoryItem item in stored)
            {
                eInventorySlot free = player.Inventory.FindFirstEmptySlot(
                    eInventorySlot.FirstBackpack, eInventorySlot.LastBackpack);

                if (free == eInventorySlot.Invalid)
                    break; // Pack is full. What is left keeps its owner and waits.

                // Ownership changes only once the item is actually in the pack.
                // Doing it the other way round leaves a row that claims to be
                // the player's while sitting in nobody's inventory.
                if (!player.Inventory.AddItem(free, item))
                    continue;

                item.OwnerID = player.InternalID;
                GameServer.Database.SaveObject(item);
                recovered++;
            }

            return recovered;
        }

        /// <summary>Re-reads the gear: what they swing, what it does, how they look.</summary>
        public static void Refresh(GameMercenary merc)
        {
            merc.InitializeActiveWeaponFromInventory();
            merc.ApplyGear();
            merc.UpdateNPCEquipmentAppearance();
        }
    }


    /// <summary>Hires, lists and dismisses the group.</summary>
    public class MercenaryRecruiter : GameNPC
    {
        /// <summary>A working group, if you would rather not pick.</summary>
        private static readonly string[] Balanced =
            { "hero", "druid", "warden", "bard", "eldritch", "blademaster" };

        /// <summary>
        /// You cannot hire a Warden while you are still a Naturalist.
        ///
        /// Every character is a base class until it picks one at level 5, so a
        /// level 1 has no business fielding a group of Wardens and Blademasters
        /// -- those classes do not exist yet, not even for the player. This
        /// asks the character class itself rather than testing a level number,
        /// so it is right for anyone who has reached 5 and not yet trained.
        /// </summary>
        private static bool HasChosenAClass(GamePlayer player)
        {
            return player.CharacterClass != null && player.CharacterClass.HasAdvancedFromBaseClass();
        }

        private void SendTooYoung(GamePlayer player)
        {
            SayTo(player, eChatLoc.CL_PopupWindow,
                "You are still a " + (player.CharacterClass != null ? player.CharacterClass.Name : "novice") +
                ", and nobody here follows an unproven banner.\n\n" +
                "Go and become something first -- your trainer will make you one of the classes " +
                "at level 5. Come back then and I will find you a group.");
        }

        public override bool Interact(GamePlayer player)
        {
            if (!base.Interact(player))
                return false;

            TurnTo(player, 5000);

            if (!HasChosenAClass(player))
            {
                SendTooYoung(player);
                return true;
            }

            int tier = MercenaryManager.GetTier(player);
            long rp = MercenaryManager.GetRealmPoints(player);
            int onDuty = 0;

            foreach (GameMercenary merc in MercenaryManager.GetCompany(player))
            {
                if (merc.CanWearGear)
                    onDuty++;
            }

            string text =
                "Keeps are not taken alone.\n\n" +
                "Tier " + tier + " (" + rp.ToString("N0") + " realm points earned). Seals you turn " +
                "in are credited to them as well, and they grow as you do.\n\n" +
                "With you now: " + onDuty + " of " + MercenaryManager.MAX_COMPANY + ".\n\n" +
                "Give them gear as you would wear it yourself -- drag it out of your pack onto " +
                "one and it goes on, and it is still theirs the next time you call them up.\n\n" +
                "Say [party] for a group that works, or pick from a realm:\n\n" +
                "  [Albion]\n  [Midgard]\n  [Hibernia]\n\n" +
                "How they play it -- now [" + MercenaryManager.GetTactic(player) + "]:\n" +
                "  [balanced] Tanks hold the line, healers mend whoever is worst off.\n" +
                "  [pbaoe] They stack on you, and the casters go in rather than stand off.\n" +
                "  [focus] Your pet holds everything. Nobody taunts, and the healing goes " +
                "to the pet first so it keeps what it has pulled.\n\n" +
                "Say [recover] to pull all their gear back, or [dismiss] to send them home.";

            SayTo(player, eChatLoc.CL_PopupWindow, text);
            return true;
        }

        public override bool WhisperReceive(GameLiving source, string text)
        {
            if (!base.WhisperReceive(source, text))
                return false;

            GamePlayer player = source as GamePlayer;

            if (player == null)
                return false;

            string keyword = text.ToLower().Trim();

            if (!HasChosenAClass(player))
            {
                SendTooYoung(player);
                return true;
            }

            switch (keyword)
            {
                case "dismiss":
                    MercenaryManager.Dismiss(player);
                    SayTo(player, eChatLoc.CL_PopupWindow,
                        "They will be here when you need them again. Their gear stays with them.");
                    return true;

                case "party":
                    HireParty(player);
                    return true;

                case "recover":
                    Recover(player);
                    return true;

                case "balanced":
                case "pbaoe":
                case "focus":
                    SetTactic(player, keyword);
                    return true;

                case "camp":
                {
                    bool camped = !MercenaryManager.IsCamped(player);
                    MercenaryManager.SetCamped(player, camped);
                    player.Out.SendMessage(camped
                        ? "Your company is making camp. The Master Level fonts go down here."
                        : "Your company is breaking camp. No more fonts until you settle again.",
                        eChatType.CT_System, eChatLoc.CL_SystemWindow);
                    return true;
                }

                case "albion":
                    ListRealm(player, eRealm.Albion);
                    return true;

                case "midgard":
                    ListRealm(player, eRealm.Midgard);
                    return true;

                case "hibernia":
                    ListRealm(player, eRealm.Hibernia);
                    return true;
            }

            if (MercenaryManager.Roster.TryGetValue(keyword, out MercClass profile))
                HireOne(player, profile);

            return true;
        }

        private void ListRealm(GamePlayer player, eRealm realm)
        {
            string text = GlobalConstants.RealmToName(realm) + ":\n\n";

            foreach (MercClass profile in MercenaryManager.Classes)
            {
                if (profile.Realm != realm)
                    continue;

                text += "[" + profile.Name + "] " + profile.Blurb + "\n";
            }

            SayTo(player, eChatLoc.CL_PopupWindow, text);
        }

        private void HireOne(GamePlayer player, MercClass profile)
        {
            if (MercenaryManager.HasRole(player, profile.Key))
            {
                SayTo(player, eChatLoc.CL_PopupWindow,
                    "You already have a " + profile.Name + " with you.");
                return;
            }

            int onDuty = 0;

            foreach (GameMercenary merc in MercenaryManager.GetCompany(player))
            {
                if (merc.CanWearGear)
                    onDuty++;
            }

            if (onDuty >= MercenaryManager.MAX_COMPANY)
            {
                SayTo(player, eChatLoc.CL_PopupWindow,
                    "That is as many as will follow one banner. Say [dismiss] to start over.");
                return;
            }

            MercenaryManager.Field(player, profile, onDuty * 50);
            SayTo(player, eChatLoc.CL_PopupWindow,
                "Your " + profile.Name + " is with you.");
        }

        private void HireParty(GamePlayer player)
        {
            MercenaryManager.Dismiss(player);

            int offset = 0;

            foreach (string key in Balanced)
            {
                if (!MercenaryManager.Roster.TryGetValue(key, out MercClass profile))
                    continue;

                MercenaryManager.Field(player, profile, offset);
                offset += 50;
            }

            SayTo(player, eChatLoc.CL_PopupWindow,
                "A Hero to hold the line, a Druid and a Warden to keep you whole and shielded, " +
                "a Bard for the chants and the adds, an Eldritch and a Blademaster to break them. " +
                "Keep them alive.");
        }

        private void SetTactic(GamePlayer player, string keyword)
        {
            Tactic tactic = keyword switch
            {
                "pbaoe" => Tactic.PBAoE,
                "focus" => Tactic.Focus,
                _       => Tactic.Balanced,
            };

            MercenaryManager.SetTactic(player, tactic);

            string how = tactic switch
            {
                Tactic.PBAoE => "We will stay on top of you and burn everything around you.",
                Tactic.Focus => "Your pet holds them. We will not touch a taunt, and it gets " +
                                "the healing first -- keep your shield up and let it work.",
                _            => "The line holds, and we mend whoever needs it most.",
            };

            SayTo(player, eChatLoc.CL_PopupWindow, how);
        }

        private void Recover(GamePlayer player)
        {
            int recovered = MercenaryGear.Recover(player);

            SayTo(player, eChatLoc.CL_PopupWindow, recovered == 0
                ? "They are holding nothing of yours, or your pack has no room for it."
                : recovered + " pieces, back in your pack. If your pack filled up before I was " +
                  "done, ask me again.");
        }
    }

    /// <summary>
    /// The seal collector, extended so a turn-in credits the group too.
    /// Repoint the collectors' ClassType at this to enable it.
    /// </summary>
    public class GaherisSealCollector : DreadedSealCollector
    {
        public override bool ReceiveItem(GameLiving source, DbInventoryItem item)
        {
            GamePlayer player = source as GamePlayer;
            long before = player != null ? player.RealmPoints : 0;

            bool handled = base.ReceiveItem(source, item);

            if (player != null)
            {
                long gained = player.RealmPoints - before;

                if (gained > 0)
                    MercenaryManager.AddRealmPoints(player, gained);
            }

            return handled;
        }
    }
}
