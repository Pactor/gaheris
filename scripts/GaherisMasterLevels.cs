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
            if (player.MLGranted)
                return false;

            player.MLGranted = true;
            player.SaveIntoDatabase();

            // MLLevel is deliberately left at 0. Being on the path and having
            // walked any of it are different things, and the experience below
            // is what closes the gap.
            player.Out.SendMessage(
                "You have begun the trials of Atlantis. Your deeds against the " +
                "creatures of this place will now count towards your Master Levels.",
                eChatType.CT_Important, eChatLoc.CL_SystemWindow);

            player.Out.SendMasterLevelWindow((byte) player.MLLevel);
            return true;
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
