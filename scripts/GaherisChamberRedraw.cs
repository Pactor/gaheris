using System;
using DOL.Events;
using DOL.GS.PlayerClass;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// Redraw a Warlock's chambers after zoning or logging in.
    ///
    /// The orbs above a Warlock's head are only ever drawn at the moment a
    /// chamber arms or fires -- `SendWarlockChamberEffect` is called from those
    /// two places and nowhere else. Nothing in the core cancels effects on a
    /// region change (that happens on quit and, for concentration, on death),
    /// so after zoning the chambers are still there and the client simply has
    /// no idea.
    ///
    /// That is worse than a missing picture. A cast of a chamber that is
    /// already armed is a DISCHARGE, not a load, so with the orbs invisible
    /// the Warlock cannot arm anything: every attempt silently spends a
    /// chamber he cannot see, and it looks like the class has stopped working.
    ///
    /// So the picture is sent again whenever it could have been lost.
    /// </summary>
    public static class ChamberRedraw
    {
        [ScriptLoadedEvent]
        public static void OnScriptLoaded(DOLEvent e, object sender, EventArgs args)
        {
            GameEventMgr.AddHandler(GamePlayerEvent.RegionChanged, new DOLEventHandler(Redraw));
            GameEventMgr.AddHandler(GamePlayerEvent.GameEntered, new DOLEventHandler(Redraw));
        }

        [ScriptUnloadedEvent]
        public static void OnScriptUnloaded(DOLEvent e, object sender, EventArgs args)
        {
            GameEventMgr.RemoveHandler(GamePlayerEvent.RegionChanged, new DOLEventHandler(Redraw));
            GameEventMgr.RemoveHandler(GamePlayerEvent.GameEntered, new DOLEventHandler(Redraw));
        }

        private static void Redraw(DOLEvent e, object sender, EventArgs args)
        {
            try
            {
                if (sender is GamePlayer player && player.CharacterClass is ClassWarlock)
                    player.Out.SendWarlockChamberEffect(player);
            }
            catch (Exception)
            {
                // A missing orb is not worth interrupting a zone change over.
            }
        }
    }
}
