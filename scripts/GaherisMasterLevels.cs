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
            // The base class says the welcome. It is good text, and it is the
            // text the player remembers; there is no reason to replace it.
            if (!base.Interact(player))
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

            if (enrolled == 0)
                SayTo(player, eChatLoc.CL_SystemWindow,
                      "You have already begun the trials.");

            return true;
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

            player.MLExperience += earned;

            bool advanced = false;

            while (player.MLLevel < GamePlayer.ML_MAX_LEVEL)
            {
                long needed = player.GetMLExperienceForLevel(player.MLLevel + 1);

                if (needed <= 0 || player.MLExperience < needed)
                    break;

                player.MLExperience -= needed;
                player.MLLevel++;
                advanced = true;
            }

            if (!advanced)
                return;

            if (player.MLLevel >= GamePlayer.ML_MAX_LEVEL)
                player.MLExperience = 0;

            player.SaveIntoDatabase();

            player.Out.SendMessage(
                "You have reached Master Level " + player.MLLevel + ".",
                eChatType.CT_Important, eChatLoc.CL_SystemWindow);

            // The ML specialisation is gated on MLGranted and MLLevel >= 1, so
            // the first level is the one that actually hands over the abilities.
            player.RefreshSpecDependantSkills(true);
            player.Out.SendUpdatePlayer();
            player.Out.SendMasterLevelWindow((byte) player.MLLevel);
        }
    }
}
