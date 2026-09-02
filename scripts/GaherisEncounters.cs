using System;
using System.Collections.Generic;
using DOL.AI.Brain;
using DOL.Database;
using DOL.GS.PacketHandler;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// Encounters.
    ///
    /// Adapted from the Dawn of Light community script pack rather than ported
    /// from it. The ideas in those scripts are good and the code is not: the
    /// Doppleganger's reward was commented out and written as ten identical
    /// branches, the splitting mob split on EVERY damage tick below half health
    /// (so it spawned copies without bound), and the seedsman kept its counters
    /// in static fields and walked to twenty coordinates hardcoded for one spot
    /// on somebody else's server -- which means exactly one of it could ever
    /// exist, in exactly one place.
    ///
    /// These are rewritten for OpenDAoC and driven by the mob row, so each one
    /// is placed with /mob create and configured by editing that mob rather
    /// than by editing this file:
    ///
    ///     /mob create DOL.GS.Scripts.GaherisDoppleganger
    ///     /mob create DOL.GS.Scripts.GaherisSplitter
    ///     /mob create DOL.GS.Scripts.GaherisSeedsman
    ///     /mob create DOL.GS.Scripts.GaherisRewardMob
    ///
    /// The chest is spawned by an encounter rather than placed by hand.
    /// </summary>
    public static class Encounters
    {
        /// <summary>Everyone who can see this, and is alive to enjoy it.</summary>
        public static List<GamePlayer> Audience(GameNPC source, int radius)
        {
            List<GamePlayer> watching = new();

            foreach (GamePlayer player in source.GetPlayersInRadius((ushort) radius))
            {
                if (player.IsAlive)
                    watching.Add(player);
            }

            return watching;
        }

        /// <summary>
        /// Puts one of something in a player's bag.
        ///
        /// The community scripts call player.ReceiveItem(this, "some_id"), and
        /// that overload does not exist here -- ReceiveItem takes a real
        /// DbInventoryItem. This is the equivalent that works.
        /// </summary>
        public static bool Give(GameNPC from, GamePlayer player, string templateId)
        {
            if (player == null || string.IsNullOrEmpty(templateId))
                return false;

            DbItemTemplate template =
                GameServer.Database.FindObjectByKey<DbItemTemplate>(templateId);

            if (template == null)
                return false;

            DbInventoryItem item = GameInventoryItem.Create(template);

            if (!player.Inventory.AddItem(eInventorySlot.FirstEmptyBackpack, item))
            {
                player.Out.SendMessage(
                    "Your pack is full, and " + template.Name + " falls to the ground.",
                    eChatType.CT_Important, eChatLoc.CL_SystemWindow);
                return false;
            }

            InventoryLogging.LogInventoryAction(from, player, eInventoryActionType.Loot,
                item.Template, item.Count);

            player.Out.SendMessage("You receive " + template.GetName(0, false) + ".",
                eChatType.CT_Loot, eChatLoc.CL_SystemWindow);

            return true;
        }
    }

    // =====================================================================
    // 1. The thing that is not what it looks like
    // =====================================================================

    /// <summary>
    /// Wears a harmless shape until it strikes.
    ///
    /// The mob row holds the DISGUISE -- whatever name, model and level you
    /// want it to be walking around as. What it turns into is taken from the
    /// Guild column, so one class covers every ambush you care to set:
    ///
    ///     Guild = "Doppleganger|2248|75"     name | model | level
    ///
    /// On death everyone who can see it gets a cut, because on a co-operative
    /// server the point of a set-piece is that the group shares it.
    /// </summary>
    public class GaherisDoppleganger : GameNPC
    {
        /// <summary>What it drops on everyone present, if anything.</summary>
        public const string SPOILS = "glowing_dreaded_seal";

        /// <summary>Percentage chance each witness gets one.</summary>
        public const int SPOILS_CHANCE = 35;

        private bool _revealed;
        private string _trueName;
        private ushort _trueModel;
        private byte _trueLevel;

        public override bool AddToWorld()
        {
            ReadDisguise();
            return base.AddToWorld();
        }

        /// <summary>Guild column: "name|model|level". Any part may be left out.</summary>
        private void ReadDisguise()
        {
            _trueName = "Doppleganger";
            _trueModel = Model;
            _trueLevel = (byte) Math.Min(byte.MaxValue, Level + 15);

            if (string.IsNullOrWhiteSpace(GuildName))
                return;

            string[] parts = GuildName.Split('|');

            if (parts.Length > 0 && !string.IsNullOrWhiteSpace(parts[0]))
                _trueName = parts[0].Trim();

            if (parts.Length > 1 && ushort.TryParse(parts[1].Trim(), out ushort model))
                _trueModel = model;

            if (parts.Length > 2 && byte.TryParse(parts[2].Trim(), out byte level))
                _trueLevel = level;
        }

        public override void StartAttack(GameObject target)
        {
            Reveal();
            base.StartAttack(target);
        }

        private void Reveal()
        {
            if (_revealed)
                return;

            _revealed = true;

            Name = _trueName;
            Model = _trueModel;
            Level = _trueLevel;

            // Level carries the stats, so health has to be put back or it
            // stands there at a fraction of the bar it just grew.
            Health = MaxHealth;

            foreach (GamePlayer player in GetPlayersInRadius(WorldMgr.VISIBILITY_DISTANCE))
            {
                player.Out.SendMessage(
                    "The " + _trueName + " sheds its disguise!",
                    eChatType.CT_Important, eChatLoc.CL_SystemWindow);

                player.Out.SendModelChange(this, _trueModel);
            }
        }

        public override void Die(GameObject killer)
        {
            List<GamePlayer> watching = Encounters.Audience(this, WorldMgr.VISIBILITY_DISTANCE);

            base.Die(killer);

            foreach (GamePlayer player in watching)
            {
                if (Util.Chance(SPOILS_CHANCE))
                    Encounters.Give(this, player, SPOILS);
            }
        }
    }

    // =====================================================================
    // 2. The thing that becomes two things
    // =====================================================================

    /// <summary>
    /// Splits into weaker copies as it is worn down.
    ///
    /// The original split on every damage tick below half health, which is not
    /// a mechanic, it is a fork bomb. This splits ONCE at each threshold and
    /// never more than SPLIT_CAP times, and the copies cannot split at all --
    /// so the fight has a shape and a known end.
    /// </summary>
    public class GaherisSplitter : GameNPC
    {
        /// <summary>Health percentages that each cost it a piece of itself.</summary>
        private static readonly int[] Thresholds = { 75, 50, 25 };

        /// <summary>Never more than this many, however the maths falls.</summary>
        private const int SPLIT_CAP = 3;

        /// <summary>How much weaker each copy is, in levels.</summary>
        private const int COPY_PENALTY = 4;

        private int _splits;
        private readonly List<GameNPC> _copies = new();

        /// <summary>A copy is a dead end; only the original divides.</summary>
        public bool IsCopy { get; set; }

        public override void TakeDamage(GameObject source, eDamageType damageType,
            int damageAmount, int criticalAmount)
        {
            base.TakeDamage(source, damageType, damageAmount, criticalAmount);

            if (IsCopy || !IsAlive || _splits >= SPLIT_CAP)
                return;

            // One split per threshold crossed, counted from how many are now
            // behind us rather than from the damage that arrived -- so a single
            // enormous hit still only costs the thresholds it actually passed.
            int passed = 0;

            foreach (int threshold in Thresholds)
            {
                if (HealthPercent < threshold)
                    passed++;
            }

            while (_splits < passed && _splits < SPLIT_CAP)
            {
                _splits++;
                Divide(source as GameLiving);
            }
        }

        private void Divide(GameLiving foe)
        {
            byte level = (byte) Math.Max(1, Level - COPY_PENALTY);

            GaherisSplitter copy = new()
            {
                IsCopy = true,
                Name = Name,
                Model = Model,
                Level = level,
                Realm = Realm,
                Size = (byte) Math.Max(10, Size - 10),
                Flags = Flags,
                MeleeDamageType = MeleeDamageType,
                CurrentRegion = CurrentRegion,
                Heading = Heading,
                X = X + Util.Random(-100, 100),
                Y = Y + Util.Random(-100, 100),
                Z = Z,
                RespawnInterval = -1,
                MaxSpeedBase = MaxSpeedBase,
                Strength = Strength,
                Constitution = Constitution,
                Dexterity = Dexterity,
                Quickness = Quickness,
                Intelligence = Intelligence,
                Empathy = Empathy,
                Piety = Piety,
                Charisma = Charisma,
            };

            StandardMobBrain brain = new();

            if (Brain is StandardMobBrain mine)
            {
                brain.AggroLevel = mine.AggroLevel;
                brain.AggroRange = mine.AggroRange;
            }

            copy.SetOwnBrain(brain);

            if (!copy.AddToWorld())
                return;

            copy.Health = copy.MaxHealth;
            _copies.Add(copy);

            // The original gives up the same ground it just handed over.
            Level = (byte) Math.Max(1, Level - 1);
            Size = (byte) Math.Max(10, Size - 5);

            if (foe != null)
                copy.StartAttack(foe);

            foreach (GamePlayer player in GetPlayersInRadius(WorldMgr.VISIBILITY_DISTANCE))
            {
                player.Out.SendMessage(Name + " tears a piece of itself away!",
                    eChatType.CT_Important, eChatLoc.CL_SystemWindow);
            }
        }

        public override void Die(GameObject killer)
        {
            base.Die(killer);

            if (IsCopy)
                return;

            // Kill the source and the pieces go with it, rather than being left
            // standing around a corpse with nothing to do.
            foreach (GameNPC copy in _copies)
            {
                if (copy != null && copy.ObjectState == eObjectState.Active)
                    copy.RemoveFromWorld();
            }

            _copies.Clear();
        }
    }

    // =====================================================================
    // 3. The thing that keeps making more things
    // =====================================================================

    /// <summary>
    /// Plants a crop of minions while it lives, and takes them with it when it
    /// dies -- so the answer to it is to go through it rather than through them.
    ///
    /// All of the state is per-instance, which the original's was not: it kept
    /// its counters in static fields, so a second seedsman anywhere in the
    /// world shared the first one's crop.
    ///
    /// The Guild column names what it plants:
    ///
    ///     Guild = "risen sapling|30"       minion name | minion model
    /// </summary>
    public class GaherisSeedsman : GameNPC
    {
        private const int CROP_CAP = 4;
        private const int PLANT_INTERVAL = 12000;
        private const int NOTICE_RANGE = 2500;

        private readonly List<GameNPC> _crop = new();
        private ECSGameTimer _planting;
        private string _seedName = "risen sapling";
        private ushort _seedModel;

        public override bool AddToWorld()
        {
            ReadSeed();

            if (!base.AddToWorld())
                return false;

            // A timer, not the brain: a brain stops thinking the moment no
            // player can see the body, and a seedsman that only plants while
            // watched is a seedsman that never has a crop ready.
            _planting ??= new ECSGameTimer(this, Plant);
            _planting.Start(PLANT_INTERVAL);
            return true;
        }

        private void ReadSeed()
        {
            _seedModel = Model;

            if (string.IsNullOrWhiteSpace(GuildName))
                return;

            string[] parts = GuildName.Split('|');

            if (parts.Length > 0 && !string.IsNullOrWhiteSpace(parts[0]))
                _seedName = parts[0].Trim();

            if (parts.Length > 1 && ushort.TryParse(parts[1].Trim(), out ushort model))
                _seedModel = model;
        }

        private int Plant(ECSGameTimer timer)
        {
            if (!IsAlive || ObjectState != eObjectState.Active)
                return 0;

            Prune();

            // Nothing to prove to an empty field.
            if (_crop.Count >= CROP_CAP || GetPlayersInRadius(NOTICE_RANGE) == null)
                return PLANT_INTERVAL;

            bool watched = false;

            foreach (GamePlayer player in GetPlayersInRadius(NOTICE_RANGE))
            {
                if (player.IsAlive)
                {
                    watched = true;
                    break;
                }
            }

            if (!watched)
                return PLANT_INTERVAL;

            Sow();
            return PLANT_INTERVAL;
        }

        private void Prune()
        {
            for (int i = _crop.Count - 1; i >= 0; i--)
            {
                GameNPC minion = _crop[i];

                if (minion == null || !minion.IsAlive ||
                    minion.ObjectState != eObjectState.Active)
                    _crop.RemoveAt(i);
            }
        }

        private void Sow()
        {
            GameNPC minion = new()
            {
                Name = _seedName,
                Model = _seedModel,
                Level = (byte) Math.Max(1, Level - 6),
                Realm = Realm,
                Size = (byte) Math.Max(10, Size - 15),
                CurrentRegion = CurrentRegion,
                Heading = Heading,
                X = X + Util.Random(-250, 250),
                Y = Y + Util.Random(-250, 250),
                Z = Z,
                RespawnInterval = -1,
                MaxSpeedBase = MaxSpeedBase,
            };

            StandardMobBrain brain = new() { AggroLevel = 100, AggroRange = 500 };
            minion.SetOwnBrain(brain);

            if (!minion.AddToWorld())
                return;

            minion.Health = minion.MaxHealth;
            _crop.Add(minion);
        }

        public override void Die(GameObject killer)
        {
            _planting?.Stop();

            List<GameNPC> crop = new(_crop);
            _crop.Clear();

            base.Die(killer);

            foreach (GameNPC minion in crop)
            {
                if (minion != null && minion.ObjectState == eObjectState.Active)
                    minion.RemoveFromWorld();
            }
        }

        public override bool RemoveFromWorld()
        {
            _planting?.Stop();
            return base.RemoveFromWorld();
        }
    }

    // =====================================================================
    // 4. Something to find
    // =====================================================================

    /// <summary>
    /// A chest that will not wait forever.
    ///
    /// Spawned by whatever wants to leave one behind rather than placed by
    /// hand, so it belongs to an encounter and vanishes with it.
    /// </summary>
    public class GaherisTreasureChest : GameStaticItemTimed
    {
        /// <summary>How long it stands there, in minutes.</summary>
        public const int LINGERS = 10;

        private readonly List<string> _spoils = new();
        private readonly List<string> _taken = new();

        public GaherisTreasureChest() : base((uint) (LINGERS * 60 * 1000)) { }

        /// <summary>
        /// A chest is opened, not picked up.
        ///
        /// GameStaticItemTimed is abstract in 1.127 and demands the pick-up
        /// contract that dropped loot uses -- money and world items that go
        /// straight into a bag. None of that applies to something you walk up
        /// to and open, so both routes decline and Interact does the work.
        ///
        /// This is the one thing in the community pack that could not simply be
        /// rewritten: their chest derives from a class that has since grown two
        /// abstract members, so it would not compile here at all.
        /// </summary>
        public override TryPickUpResult TryAutoPickUp(IGameStaticItemOwner itemOwner)
        {
            return TryPickUpResult.DoesNotWant;
        }

        public override TryPickUpResult TryPickUp(GamePlayer source, IGameStaticItemOwner itemOwner)
        {
            return TryPickUpResult.DoesNotWant;
        }

        public GaherisTreasureChest(IEnumerable<string> spoils)
            : base((uint) (LINGERS * 60 * 1000))
        {
            Name = "treasure chest";
            Model = 1596;

            if (spoils != null)
                _spoils.AddRange(spoils);
        }

        public override bool Interact(GamePlayer player)
        {
            if (!base.Interact(player))
                return false;

            if (!player.IsWithinRadius(this, WorldMgr.INTERACT_DISTANCE))
                return false;

            // One share each. Without this the first person to arrive empties
            // it repeatedly, which on a co-operative server is the whole group
            // getting nothing.
            if (_taken.Contains(player.InternalID))
            {
                player.Out.SendMessage("You have already taken your share.",
                    eChatType.CT_System, eChatLoc.CL_SystemWindow);
                return true;
            }

            _taken.Add(player.InternalID);

            if (_spoils.Count == 0)
            {
                player.Out.SendMessage("The chest is empty.",
                    eChatType.CT_System, eChatLoc.CL_SystemWindow);
                return true;
            }

            string prize = _spoils[Util.Random(_spoils.Count - 1)];
            DbItemTemplate template =
                GameServer.Database.FindObjectByKey<DbItemTemplate>(prize);

            if (template == null)
                return true;

            DbInventoryItem item = GameInventoryItem.Create(template);

            if (player.Inventory.AddItem(eInventorySlot.FirstEmptyBackpack, item))
            {
                InventoryLogging.LogInventoryAction("(chest)", player,
                    eInventoryActionType.Loot, item.Template, item.Count);

                player.Out.SendMessage("You take " + template.GetName(0, false) +
                    " from the chest.", eChatType.CT_Loot, eChatLoc.CL_SystemWindow);
            }
            else
            {
                _taken.Remove(player.InternalID);

                player.Out.SendMessage("Your pack is too full to take anything.",
                    eChatType.CT_System, eChatLoc.CL_SystemWindow);
            }

            return true;
        }
    }

    // =====================================================================
    // 5. Something worth killing
    // =====================================================================

    /// <summary>
    /// Pays realm points on a band, with a chance of paying considerably more.
    ///
    /// This replaces the pack's DragonNPC in the set, which turned out not to
    /// be an encounter at all -- it is a peace-flagged vendor that exchanges
    /// dragonslayer gear, and there are already three hundred of those items
    /// in the database.
    ///
    /// Realm points matter here because they are what the hired company spends:
    /// a kill that pays them is a kill that makes the whole group better.
    /// </summary>
    public class GaherisRewardMob : GameNPC
    {
        /// <summary>Percentage chance of the larger payout.</summary>
        private const int JACKPOT_CHANCE = 5;

        private const int JACKPOT_MULTIPLIER = 10;

        /// <summary>Realm points per level, before the band.</summary>
        private const int PER_LEVEL = 12;

        public override void Die(GameObject killer)
        {
            List<GamePlayer> watching = Encounters.Audience(this, 3000);

            base.Die(killer);

            if (watching.Count == 0)
                return;

            int award = Math.Max(10, Level * PER_LEVEL);
            bool jackpot = Util.Chance(JACKPOT_CHANCE);

            if (jackpot)
                award *= JACKPOT_MULTIPLIER;

            foreach (GamePlayer player in watching)
            {
                player.GainRealmPoints(award, false, true, true);

                if (jackpot)
                {
                    player.Out.SendMessage(
                        "The " + Name + " carried far more than it looked -- " +
                        award + " realm points!",
                        eChatType.CT_Important, eChatLoc.CL_SystemWindow);
                }
            }
        }
    }
}
