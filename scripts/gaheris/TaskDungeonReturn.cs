namespace DOL.GS.Scripts
{
    /// <summary>
    /// Where a player stood before the taskmaster sent them below.
    ///
    /// The way in is a person rather than a place, so the way out has no
    /// obvious destination either -- there is no cave mouth to step back out
    /// of, because the entrance was never a location. Remembering where they
    /// were standing when they took the task gives the exit somewhere honest
    /// to put them: next to the taskmaster who sent them, which is also where
    /// the next task comes from.
    ///
    /// Held on the character rather than on the mission, because the mission
    /// ends the moment they leave and the exit needs this after that.
    /// </summary>
    public static class TaskDungeonReturn
    {
        private const string KEY = "GaherisTaskReturn";

        /// <summary>Remember where they are, before they are moved.</summary>
        public static void Remember(GamePlayer player)
        {
            if (player?.CurrentRegion is null or BaseInstance)
                return;

            player.TempProperties.SetProperty(KEY,
                new GameLocation("task return", player.CurrentRegionID,
                                 player.X, player.Y, player.Z, player.Heading));
        }

        /// <summary>
        /// Where to put them on the way out. The bind stone is the fallback --
        /// somewhere real is always better than somewhere sealed.
        /// </summary>
        public static GameLocation Where(GamePlayer player)
        {
            GameLocation home = player.TempProperties.GetProperty<GameLocation>(KEY, null);

            if (home != null && home.RegionID != 0)
                return home;

            return new GameLocation("bind", (ushort) player.BindRegion,
                                    player.BindXpos, player.BindYpos,
                                    player.BindZpos, (ushort) player.BindHeading);
        }
    }
}
