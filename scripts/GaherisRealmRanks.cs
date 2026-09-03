using System;
using System.Collections.Generic;
using DOL.AI.Brain;
using DOL.Events;
using DOL.GS.PacketHandler;
using DOL.GS.ServerProperties;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// Realm Rank 15.
    ///
    /// Live extended realm ranks from 14 to 15, which raises the realm skill
    /// point ceiling from 130 to 140 -- one point per realm level, as always.
    /// The core cannot follow it here, because the ladder is a hardcoded array:
    ///
    ///     while (RealmPoints >= CalculateRPsFromRealmLevel(RealmLevel + 1) &&
    ///            RealmLevel &lt; (REALMPOINTS_FOR_LEVEL.Length - 1))
    ///
    /// and that array ends at realm level 130, which is Realm Rank 14. There is
    /// no server property for it and GamePlayer is not swappable, so the
    /// ceiling cannot be lifted from a script by configuration. It can be
    /// lifted by carrying on where the core stops, which is what this does.
    ///
    /// The cost of levels 131 to 140 is not invented. The core's own table
    /// grows by exactly 1.11 per level from level 119 to its end -- every ratio
    /// in that stretch is 1.11000 to five places -- so the extension continues
    /// the table's own law from its own last value. Its fallback cubic is NOT
    /// used: that formula returns about 18 million for level 130 where the
    /// table says 187 million, so it disagrees with the table by an order of
    /// magnitude and would hand out ten ranks for nothing.
    ///
    /// Setting RealmLevel is enough to award the skill point, because the
    /// property's setter calls CharacterClass.OnRealmLevelUp. This only ever
    /// raises a level the player has already paid for in realm points.
    /// </summary>
    public static class RealmRankFifteen
    {
        /// <summary>Where the core's table stops. Realm level 130 is RR14.</summary>
        private const int CORE_CEILING = 130;

        /// <summary>Realm points the core's table asks for at level 130.</summary>
        private const long CORE_CEILING_COST = 187917143L;

        /// <summary>
        /// The table's own growth rate. Constant at 1.11 per level across the
        /// whole top of the core's array.
        /// </summary>
        private const double PER_LEVEL = 1.11;

        [ServerProperty("gaheris", "gaheris_max_realm_level",
            "Highest realm level obtainable. 130 is Realm Rank 14, which is " +
            "where the core stops on its own. 140 is Realm Rank 15, as on " +
            "live. Set to 130 to turn this off.", 140)]
        public static int MAX_REALM_LEVEL;

        [ScriptLoadedEvent]
        public static void OnScriptLoaded(DOLEvent e, object sender, EventArgs args)
        {
            GameEventMgr.AddHandler(GameLivingEvent.Dying, new DOLEventHandler(Died));
            GameEventMgr.AddHandler(GamePlayerEvent.GameEntered, new DOLEventHandler(Entered));
        }

        [ScriptUnloadedEvent]
        public static void OnScriptUnloaded(DOLEvent e, object sender, EventArgs args)
        {
            GameEventMgr.RemoveHandler(GameLivingEvent.Dying, new DOLEventHandler(Died));
            GameEventMgr.RemoveHandler(GamePlayerEvent.GameEntered, new DOLEventHandler(Entered));
        }

        /// <summary>
        /// Realm points needed for a realm level past the core's table.
        /// </summary>
        public static long CostOf(int realmLevel)
        {
            if (realmLevel <= CORE_CEILING)
                return CORE_CEILING_COST;

            double cost = CORE_CEILING_COST;

            for (int step = CORE_CEILING; step < realmLevel; step++)
                cost *= PER_LEVEL;

            return (long) Math.Round(cost);
        }

        /// <summary>
        /// Raise anyone who has already earned the points but was stopped by
        /// the core's ceiling.
        ///
        /// The core's own loop fires an event on every level it grants, but it
        /// stops at 130 and never fires again however many points arrive after
        /// -- so there is no level-up event to listen for. Kills and logins are
        /// the two moments worth checking instead.
        /// </summary>
        public static void Promote(GamePlayer player)
        {
            if (player == null || MAX_REALM_LEVEL <= CORE_CEILING)
                return;

            int ceiling = Math.Min(MAX_REALM_LEVEL, 999);

            while (player.RealmLevel >= CORE_CEILING &&
                   player.RealmLevel < ceiling &&
                   player.RealmPoints >= CostOf(player.RealmLevel + 1))
            {
                player.RealmLevel++;

                player.Out.SendUpdatePlayer();
                player.Out.SendMessage(
                    "You have gained a realm level!",
                    eChatType.CT_System, eChatLoc.CL_SystemWindow);

                if (player.RealmLevel % 10 == 0)
                {
                    player.Out.SendUpdatePlayerSkills(true);
                    player.Out.SendMessage(
                        "You have reached Realm Rank " + (player.RealmLevel / 10 + 1) + "!",
                        eChatType.CT_ScreenCenter, eChatLoc.CL_SystemWindow);
                    player.Out.SendMessage(
                        "You are now " + player.RealmRankTitle(player.Client.Account.Language) + ".",
                        eChatType.CT_System, eChatLoc.CL_SystemWindow);

                    foreach (GamePlayer nearby in player.GetPlayersInRadius(WorldMgr.VISIBILITY_DISTANCE))
                        nearby.Out.SendLivingDataUpdate(player, true);

                    player.Notify(GamePlayerEvent.RRLevelUp, player);
                }
                else
                    player.Notify(GamePlayerEvent.RLLevelUp, player);
            }
        }

        private static void Entered(DOLEvent e, object sender, EventArgs args)
        {
            try
            {
                Promote(sender as GamePlayer);
            }
            catch (Exception)
            {
                // Never keep a player out of the world over a realm level.
            }
        }

        private static void Died(DOLEvent e, object sender, EventArgs args)
        {
            try
            {
                if (MAX_REALM_LEVEL <= CORE_CEILING)
                    return;

                if (sender is not GameLiving dead || args is not DyingEventArgs death)
                    return;

                if (dead is GameNPC npc && (npc.Brain is IControlledBrain || npc is GameMercenary))
                    return;

                if (death.PlayerKillers == null)
                    return;

                foreach (GamePlayer player in death.PlayerKillers)
                    Promote(player);
            }
            catch (Exception)
            {
                // A realm level is never worth losing a kill over.
            }
        }
    }
}
