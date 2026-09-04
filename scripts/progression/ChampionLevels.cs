using System;
using System.Collections.Generic;
using DOL.AI.Brain;
using DOL.Events;
using DOL.GS.PacketHandler;
using DOL.GS.ServerProperties;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// Where Champion experience comes from.
    ///
    /// Nowhere, until this. OpenDAoC's experience path carries the line
    ///
    ///     // Get Champion Experience too
    ///     // GainChampionExperience(expTotal);
    ///
    /// commented out, so killing things has never awarded a point of it. What
    /// remained were the GM command and quest rewards, which is the same shape
    /// the Master Levels were in: the whole apparatus present -- the Champion
    /// flag, the level, the experience counter, the fifteen mini-line
    /// specialisations, the King who confers the levels -- and nothing feeding
    /// it.
    ///
    /// The King is already complete and needed no help. His Interact prompts a
    /// level 50 who is not yet a Champion, and for one who is, he loops
    ///
    ///     while (ChampionLevel < ChampionMaxLevel &&
    ///            ChampionExperience >= ChampionExperienceForNextLevel)
    ///         player.ChampionLevelUp();
    ///
    /// so ranks arrive by going back to him, exactly as Master Levels arrive by
    /// going back to Demyphon. He was simply never placed in the world;
    /// migration 45 puts him in each throne room.
    ///
    /// Awarded as eXPSource.Quest deliberately. Any other source runs the
    /// core's conversion -- one champion point per two million experience in
    /// PvE -- which is calibrated for live's numbers and, against ours, would
    /// mean somewhere past a million kills for the ten levels. Quest skips the
    /// conversion, so the amount below is the amount granted and is scaled the
    /// same way Master Level experience is: by what died, not by what it was
    /// worth.
    /// </summary>
    public static class ChampionExperience
    {
        /// <summary>
        /// Below this a kill pays nothing. Champion Levels are level 50
        /// content and should not be reachable by clearing a low camp.
        /// </summary>
        private const int WORTHY = 45;

        [ServerProperty("progression", "cl_xp_per_level",
            "Champion experience earned per level of the creature killed. A " +
            "champion level costs 32,000, so 10 is roughly 53 kills of a level " +
            "60 creature per champion level. 0 turns champion progress off.", 10)]
        public static int CL_XP_PER_LEVEL;

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
                if (CL_XP_PER_LEVEL <= 0)
                    return;

                if (sender is not GameNPC dead || args is not DyingEventArgs death)
                    return;

                // Nothing is owed for killing something's summoned help.
                if (dead.Brain is IControlledBrain || dead is GameMercenary)
                    return;

                if (dead.Level < WORTHY)
                    return;

                long earned = dead.Level * CL_XP_PER_LEVEL;

                if (earned <= 0)
                    return;

                foreach (GamePlayer player in Earners(death))
                {
                    if (player.Champion && player.ChampionLevel < GamePlayer.CL_MAX_LEVEL)
                        player.GainChampionExperience(earned, eXPSource.Quest);
                }
            }
            catch (Exception)
            {
                // A champion level is never worth losing a kill over.
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
    }
}
