using System;
using System.Collections.Generic;
using DOL.AI.Brain;
using DOL.Events;
using DOL.GS.PacketHandler;
using DOL.GS.ServerProperties;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// Master Levels, actually reachable.
    ///
    /// OpenDAoC ships the whole apparatus and none of the content. There is an
    /// MLGranted flag, an MLLevel, an MLExperience counter, a ten-entry XP
    /// curve, a Master Level window, ML step tracking, and the ML
    /// specialisations themselves -- and in the entire codebase exactly one
    /// thing sets MLGranted and exactly one thing adds MLExperience, and both
    /// of them are the GM command. The trials were never implemented.
    ///
    /// The Arbiter is the clearest symptom. On live you spoke to him once and
    /// were on the path. Here, DOL.GS.Arbiter inherits Researcher, which has
    /// no Interact of its own, and Arbiter's own Interact does nothing but
    /// print two lines of flavour text. He cannot start anybody, and every
    /// scholar downstream of him is waiting on a flag he never sets. Head
    /// Scholar Mabyle does not answer at all for the same reason one step
    /// further along: DOL.GS.HeadScholar is an empty subclass of Researcher.
    ///
    /// So this supplies the two missing halves. The Arbiter enrols you, and
    /// your whole group with you, because on a co-operative server a raid
    /// entrance that admits one person at a time is not an entrance. And ML
    /// experience comes from killing Atlantis-grade things, since the trials
    /// that would otherwise award it do not exist.
    /// </summary>
    public class GaherisArbiter : Arbiter
    {
        /// <summary>
        /// How far a group member can stand and still be enrolled. Far enough
        /// that nobody has to shuffle into a doorway, short enough that it is
        /// still the group that came here together.
        /// </summary>
        private const int WITH_YOU = 2000;

        public override bool Interact(GamePlayer player)
        {
            // The welcome is for people who have not heard it. Arbiter.Interact
            // puts two popup windows on the screen every single time it runs,
            // so calling it unconditionally means somebody already on the path
            // has to sit through the introduction again before reaching the
            // thing they came back for. Once enrolled, go straight to the
            // disciplines.
            bool newcomer = !(player.MLGranted && player.MLLevel >= 1);

            if (newcomer)
            {
                if (!base.Interact(player))
                    return false;
            }
            else if (!Greet(player))
                return false;

            int enrolled = 0;

            if (Enrol(player))
                enrolled++;

            if (player.Group != null)
            {
                foreach (GamePlayer mate in player.Group.GetPlayersInTheGroup())
                {
                    if (mate == null || mate == player)
                        continue;

                    if (mate.ObjectState != GameObject.eObjectState.Active)
                        continue;

                    if (!mate.IsWithinRadius(this, WITH_YOU))
                        continue;

                    if (Enrol(mate))
                        enrolled++;
                }
            }

            if (enrolled == 0 && !Promote(player))
                SayTo(player, eChatLoc.CL_SystemWindow,
                      "You have already begun the trials.");

            OfferPaths(player);
            return true;
        }

        /// <summary>
        /// Give the player every Master Level their deeds have paid for.
        ///
        /// The experience handler used to promote as soon as the bar filled,
        /// which meant the Master Levels arrived silently in the middle of a
        /// fight and the Arbiter had nothing to do with them. He is who you
        /// train with, so he is who hands them over -- and coming back to him
        /// with a full bar is the reason to come back at all.
        /// </summary>
        private bool Promote(GamePlayer player)
        {
            if (!player.MLGranted || player.MLLevel >= GamePlayer.ML_MAX_LEVEL)
                return false;

            int gained = 0;

            while (player.MLLevel < GamePlayer.ML_MAX_LEVEL)
            {
                long needed = player.GetMLExperienceForLevel(player.MLLevel + 1);

                if (needed <= 0 || player.MLExperience < needed)
                    break;

                player.MLExperience -= needed;
                player.MLLevel++;
                gained++;
            }

            if (gained == 0)
                return false;

            if (player.MLLevel >= GamePlayer.ML_MAX_LEVEL)
                player.MLExperience = 0;

            player.SaveIntoDatabase();

            SayTo(player, eChatLoc.CL_PopupWindow,
                  gained == 1
                      ? "You have earned it. You are Master Level " + player.MLLevel + "."
                      : "You have earned several. You are Master Level " + player.MLLevel + ".");

            player.Out.SendMessage("You have reached Master Level " + player.MLLevel + ".",
                                   eChatType.CT_Important, eChatLoc.CL_SystemWindow);

            Announce(player);
            return true;
        }

        /// <summary>
        /// Everything GameObject.Interact enforces, and none of the talking.
        ///
        /// C# has no way to reach a grandparent's implementation, so a subclass
        /// that wants GameNPC's interact contract without Arbiter's two popup
        /// windows has to keep the contract itself: the distance check that
        /// stops you conversing from across the zone, and the notifications
        /// quests and scripts listen for.
        /// </summary>
        private bool Greet(GamePlayer player)
        {
            if (player.Client.Account.PrivLevel == 1 &&
                !IsWithinRadius(player, InteractDistance))
            {
                player.Out.SendMessage("You are too far away to speak to " +
                                       GetName(0, true) + ".",
                                       eChatType.CT_System, eChatLoc.CL_SystemWindow);
                Notify(GameObjectEvent.InteractFailed, this, new InteractEventArgs(player));
                return false;
            }

            Notify(GameObjectEvent.Interact, this, new InteractEventArgs(player));
            player.Notify(GameObjectEvent.InteractWith, player, new InteractWithEventArgs(this));

            TurnTo(player, 5000);
            return true;
        }

        /// <summary>
        /// The eight Master Level paths, and what each one is for.
        ///
        /// Not class restricted, which is how it worked -- any class may walk
        /// any of them, some merely suit better.
        /// </summary>
        private static readonly (string Key, string What)[] Paths =
        {
            ("Banelord",     "curses, snares and the unmaking of a foe's defences"),
            ("Battlemaster", "the close fight: footwork, guard and the killing blow"),
            ("Convoker",     "summoning -- wards, weapons and servants called from nothing"),
            ("Perfecter",    "mending: healing, cures and calling the fallen back"),
            ("Sojourner",    "movement, reach and passage others cannot take"),
            ("Spymaster",    "stealth, poison and the knife nobody sees"),
            ("Stormlord",    "the sky turned against them -- storms, roots and ruin"),
            ("Warlord",      "holding a line, and keeping those behind it alive"),
        };

        private void OfferPaths(GamePlayer player)
        {
            if (!player.MLGranted)
                return;

            string chosen = PathOf(player);
            string text = chosen == null
                ? "You have yet to choose your discipline. Name one, and its " +
                  "arts open to you as you rise:\n\n"
                : "You walk the path of the " + chosen + ". Name another and " +
                  "you take up its arts instead:\n\n";

            foreach ((string key, string what) in Paths)
                text += "  [" + key + "] -- " + what + "\n";

            // Eight lines of roughly seventy characters: nowhere near the
            // client's 2048 byte packet ceiling, unlike the travel catalogue.
            SayTo(player, eChatLoc.CL_PopupWindow, text);
        }

        public override bool WhisperReceive(GameLiving source, string text)
        {
            // Ours first, then the base class. Arbiter.WhisperReceive returns
            // false on every branch it handles, so calling it first would eat
            // the answer before we ever saw it.
            if (source is GamePlayer player &&
                player.IsWithinRadius(this, WorldMgr.INTERACT_DISTANCE) &&
                Choose(player, (text ?? string.Empty).Trim()))
                return true;

            return base.WhisperReceive(source, text);
        }

        /// <summary>
        /// Take up a path. True if the whisper was a path name.
        ///
        /// MLLine is a position, not a name: RefreshSpecDependantSkills counts
        /// Master Level entries as it walks the career and keeps the one whose
        /// count matches. The career is a dictionary, so the order is whatever
        /// it yields -- which means the only safe way to set MLLine is to walk
        /// it exactly as that loop does and take the index we land on. Working
        /// the number out from the order of the eight names above would sooner
        /// or later hand somebody the wrong discipline.
        /// </summary>
        private bool Choose(GamePlayer player, string said)
        {
            string wanted = null;

            foreach ((string key, string _) in Paths)
            {
                if (key.Equals(said, StringComparison.OrdinalIgnoreCase))
                {
                    wanted = key;
                    break;
                }
            }

            if (wanted == null)
                return false;

            if (!player.MLGranted)
            {
                SayTo(player, eChatLoc.CL_PopupWindow,
                      "Begin the trials first. A discipline is no use to " +
                      "somebody with no standing to practise it.");
                return true;
            }

            byte index = 0;
            bool found = false;

            foreach (KeyValuePair<Specialization, int> entry in
                     SkillBase.GetSpecializationCareer(player.CharacterClass.ID))
            {
                if (entry.Key is not IMasterLevelsSpecialization)
                    continue;

                if (entry.Key.KeyName == wanted)
                {
                    found = true;
                    break;
                }

                index++;
            }

            if (!found)
            {
                SayTo(player, eChatLoc.CL_PopupWindow,
                      "That discipline is closed to you.");
                return true;
            }

            if (player.MLLine == index && PathOf(player) == wanted)
            {
                SayTo(player, eChatLoc.CL_PopupWindow,
                      "You already walk that path.");
                return true;
            }

            player.MLLine = index;
            player.SaveIntoDatabase();

            SayTo(player, eChatLoc.CL_PopupWindow,
                  "So be it. You are of the " + wanted + " now, and its arts " +
                  "come to you as you rise through the Master Levels.");

            player.Out.SendMessage("You have taken up the path of the " + wanted + ".",
                                   eChatType.CT_Important, eChatLoc.CL_SystemWindow);

            Announce(player);
            return true;
        }

        /// <summary>Which path a player currently walks, or null.</summary>
        public static string PathOf(GamePlayer player)
        {
            if (player == null || !player.MLGranted)
                return null;

            byte index = 0;

            foreach (KeyValuePair<Specialization, int> entry in
                     SkillBase.GetSpecializationCareer(player.CharacterClass.ID))
            {
                if (entry.Key is not IMasterLevelsSpecialization)
                    continue;

                if (index == player.MLLine)
                    return entry.Key.KeyName;

                index++;
            }

            return null;
        }

        /// <summary>Puts one person on the path. True if this changed anything.</summary>
        private bool Enrol(GamePlayer player)
        {
            // Granted but still at Master Level 0 counts as unfinished. The
            // first attempt at this set the flag and nothing else, which left
            // players enrolled in a state they could not see.
            if (player.MLGranted && player.MLLevel >= 1)
                return false;

            player.MLGranted = true;

            // Master Level 1 comes with enrolment, and that is a decision
            // rather than an accident. On live it is the reward for completing
            // the first trial, and the trials do not exist here -- nothing in
            // OpenDAoC awards an ML step. Leaving the player at ML0 leaves
            // RefreshSpecDependantSkills refusing to hand over the Master Level
            // specialisation, which is gated on MLLevel >= 1, so all 64 ML
            // spells we imported stay out of reach and the window has nothing
            // to show. The Arbiter opens the first door; the other nine are
            // earned below.
            if (player.MLLevel < 1)
            {
                player.MLLevel = 1;
                player.MLExperience = 0;
            }

            player.SaveIntoDatabase();

            // Said twice on purpose. The base class has just put two popup
            // windows on the screen, and a line in the system window behind
            // them is easy to miss -- which is exactly what happened the first
            // time this ran: the flag was set in the database and the player
            // saw nothing at all.
            SayTo(player, eChatLoc.CL_PopupWindow,
                  "You have begun the trials of Atlantis. You are now Master " +
                  "Level 1, and your deeds against the creatures of this place " +
                  "will carry you further.");

            player.Out.SendMessage(
                "You have begun the trials of Atlantis. You are now Master Level 1.",
                eChatType.CT_Important, eChatLoc.CL_SystemWindow);

            Announce(player);
            return true;
        }

        /// <summary>
        /// Tell the client what it does not otherwise get told.
        ///
        /// Nothing in OpenDAoC sends the Master Level window outside a dialog
        /// response, the GM command and step completion -- so a client that has
        /// just been enrolled, or that has simply logged in, has never been
        /// told the player has Master Levels and will not offer the Master
        /// Level experience bar.
        /// </summary>
        public static void Announce(GamePlayer player)
        {
            if (player?.Out == null || !player.MLGranted)
                return;

            player.RefreshSpecDependantSkills(false);
            player.Out.SendUpdatePlayer();
            player.Out.SendUpdatePoints();
            player.Out.SendMasterLevelWindow((byte) player.MLLevel);

            // The company walks the Master Levels with its employer. Learn()
            // reads his MLLevel, so calling it here means a hire picks up the
            // next path spell the moment he does -- on enrolment, on taking a
            // discipline, on being granted a level, and on logging in.
            foreach (GameMercenary merc in MercenaryManager.GetCompany(player))
                merc.Learn();
        }
    }

    /// <summary>
    /// Sends the Master Level window to anyone already on the path as they
    /// enter the world, so the client knows before they ask.
    /// </summary>
    public static class MasterLevelLogin
    {
        [ScriptLoadedEvent]
        public static void OnScriptLoaded(DOLEvent e, object sender, EventArgs args)
        {
            GameEventMgr.AddHandler(GamePlayerEvent.GameEntered, new DOLEventHandler(Entered));
        }

        [ScriptUnloadedEvent]
        public static void OnScriptUnloaded(DOLEvent e, object sender, EventArgs args)
        {
            GameEventMgr.RemoveHandler(GamePlayerEvent.GameEntered, new DOLEventHandler(Entered));
        }

        private static void Entered(DOLEvent e, object sender, EventArgs args)
        {
            if (sender is GamePlayer player && player.MLGranted)
                GaherisArbiter.Announce(player);
        }
    }

    /// <summary>
    /// Where Master Level experience comes from.
    ///
    /// Nothing in OpenDAoC awards it, so on the Dying event -- the same signal
    /// artifacts level from, raised by GameLiving on every death and carrying
    /// the list of players who earned the kill -- credit everyone on the path.
    ///
    /// Scaled by the level of the thing killed rather than its raw experience
    /// value. A level 50 mob is worth hundreds of thousands of experience and
    /// a Master Level costs 32,000, so paying out raw would hand somebody ML10
    /// for a single kill.
    /// </summary>
    public static class MasterLevelExperience
    {
        /// <summary>
        /// Below this, a kill is not Atlantis-grade and pays nothing. Master
        /// Levels should not be reachable by clearing a low-level camp.
        /// </summary>
        private const int WORTHY = 45;

        [ServerProperty("gaheris", "gaheris_ml_xp_per_level",
            "Master Level experience earned per level of the creature killed. " +
            "A Master Level costs 32,000, so 10 is roughly 53 kills of a level " +
            "60 creature per Master Level. 0 turns Master Level progress off.", 10)]
        public static int ML_XP_PER_LEVEL;

        [ScriptLoadedEvent]
        public static void OnScriptLoaded(DOLEvent e, object sender, EventArgs args)
        {
            GameEventMgr.AddHandler(GameLivingEvent.Dying, new DOLEventHandler(Died));
        }

        [ScriptUnloadedEvent]
        public static void OnScriptUnloaded(DOLEvent e, object sender, EventArgs args)
        {
            GameEventMgr.RemoveHandler(GameLivingEvent.Dying, new DOLEventHandler(Died));
        }

        private static void Died(DOLEvent e, object sender, EventArgs args)
        {
            try
            {
                if (ML_XP_PER_LEVEL <= 0)
                    return;

                if (sender is not GameNPC dead || args is not DyingEventArgs death)
                    return;

                // Nothing is owed for killing something's summoned help.
                if (dead.Brain is IControlledBrain || dead is GameMercenary)
                    return;

                if (dead.Level < WORTHY)
                    return;

                long earned = dead.Level * ML_XP_PER_LEVEL;

                if (earned <= 0)
                    return;

                foreach (GamePlayer player in Earners(death))
                    Award(player, earned);
            }
            catch (Exception)
            {
                // A Master Level is never worth losing a kill over.
            }
        }

        /// <summary>
        /// Everyone this kill counts for. PlayerKillers is the list the core
        /// builds for experience; where it is absent -- a kill finished by a
        /// hired companion, which is not a pet and so credits nobody --
        /// GaherisLoot resolves the employer, the same way it does for loot.
        /// </summary>
        private static IEnumerable<GamePlayer> Earners(DyingEventArgs death)
        {
            if (death.PlayerKillers != null && death.PlayerKillers.Count > 0)
            {
                foreach (GamePlayer player in death.PlayerKillers)
                {
                    if (player != null && player.ObjectState == GameObject.eObjectState.Active)
                        yield return player;
                }

                yield break;
            }

            if (GaherisLoot.Credit(death.Killer) is GamePlayer credited &&
                credited.ObjectState == GameObject.eObjectState.Active)
            {
                yield return credited;
            }
        }

        private static void Award(GamePlayer player, long earned)
        {
            if (!player.MLGranted || player.MLLevel >= GamePlayer.ML_MAX_LEVEL)
                return;

            long before = player.MLExperience;
            long needed = player.GetMLExperienceForLevel(player.MLLevel + 1);

            player.MLExperience += earned;

            // Deliberately does not promote. Experience is earned in the field
            // and the rank is conferred by the Arbiter, so the bar fills here
            // and fills no further until he hands the level over. It is also
            // how the player finds out there is a reason to go back to him.
            if (needed > 0 && before < needed && player.MLExperience >= needed)
            {
                player.MLExperience = needed;
                player.SaveIntoDatabase();

                player.Out.SendMessage(
                    "You have learned all you can alone. Return to the Arbiter " +
                    "to be raised to Master Level " + (player.MLLevel + 1) + ".",
                    eChatType.CT_Important, eChatLoc.CL_SystemWindow);

                player.Out.SendMasterLevelWindow((byte) player.MLLevel);
            }
        }
    }
}
