using System;
using System.Collections.Generic;
using DOL.Database;
using DOL.AI.Brain;
using DOL.Events;
using DOL.GS.PacketHandler;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// Artifacts that actually level.
    ///
    /// The ported artifact system expects a GamePlayerEvent.GainedExperience to
    /// hang off. OpenDAoC does not have one -- and the interesting part is that
    /// it still has GainedExperienceEventArgs, with every field intact
    /// (ExpBase, ExpCampBonus, ExpGroupBonus, ExpOutpostBonus, XPSource). The
    /// class was left behind when the event was taken out. Nothing in the
    /// entire codebase constructs it. So there was no signal to subscribe to,
    /// and artifacts sat at level 0 forever.
    ///
    /// GameLivingEvent.EnemyKilled looked like the answer and is not: it is
    /// raised by four named-mob scripts -- three dragons and a Fomor -- and by
    /// nothing else. Hooking it would have levelled artifacts on dragon kills
    /// alone.
    ///
    /// GameLivingEvent.Dying is raised by GameLiving itself on EVERY death,
    /// and its args carry the whole list of players who earned it. That is the
    /// signal. MercenaryMuster already hooks it the same way, so the pattern is
    /// proven here.
    ///
    /// What ArtifactMgr wanted was the sum of the experience the kill was
    /// worth. This gives it the same thing from the other end: what the dead
    /// thing was worth, credited to everyone who earned it.
    /// </summary>
    public static class ArtifactExperience
    {
        /// <summary>
        /// Kills below this are not worth the bookkeeping. A grey mob should
        /// not creep an artifact towards level 10 while you clear a camp.
        /// </summary>
        private const int WORTH_COUNTING = 3;

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
                if (sender is not GameNPC dead || args is not DyingEventArgs death)
                    return;

                // Nothing is owed for killing something's summoned help.
                if (dead.Brain is IControlledBrain || dead is GameMercenary)
                    return;

                if (dead.Level < WORTH_COUNTING)
                    return;

                long worth = dead.ExperienceValue;

                if (worth <= 0)
                    return;

                foreach (GamePlayer player in Earners(death))
                    Award(player, worth);
            }
            catch (Exception)
            {
                // An artifact is never worth losing a kill over.
            }
        }

        /// <summary>
        /// Everyone this kill counts for.
        ///
        /// PlayerKillers is the list the core builds for experience, so using
        /// it means an artifact levels on exactly the kills that levelled the
        /// character. Where it is absent -- a kill finished by a hired
        /// companion, which is not a pet and so credits nobody -- GaherisLoot
        /// resolves the employer, the same way it does for loot.
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

        /// <summary>Every artifact the player is actually wearing.</summary>
        private static void Award(GamePlayer player, long worth)
        {
            if (player?.Inventory == null || player.IsPraying)
                return;

            List<InventoryArtifact> worn = new();

            lock (player.Inventory)
            {
                foreach (DbInventoryItem item in player.Inventory.EquippedItems)
                {
                    if (item is InventoryArtifact artifact)
                        worn.Add(artifact);
                }
            }

            foreach (InventoryArtifact artifact in worn)
                ArtifactMgr.ArtifactGainedExperience(player, artifact, worth);
        }
    }
}
