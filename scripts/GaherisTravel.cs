using System;
using System.Collections.Generic;
using DOL.AI.Brain;
using DOL.GS.PacketHandler;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// Gaheris travel.
    ///
    /// One realm, one network. Every warden reaches every other warden --
    /// both other realms' frontiers included -- because on Gaheris there is
    /// nobody to hide the map from.
    ///
    /// The network is its own map. Each warden registers itself when it spawns,
    /// so the destination list is exactly the set of wardens standing in the
    /// world, and you always arrive next to one that can send you on again.
    /// Adding a stop is one mob row; moving a stop is editing that row. There
    /// is no second list to keep in step, and nothing to regenerate.
    ///
    /// The mob row's Guild column names the destination. That name is the
    /// keyword -- click it in the window rather than typing it.
    /// </summary>
    public class GaherisTeleporter : GameNPC
    {
        private static readonly List<GaherisTeleporter> _network = new();
        private static readonly object _lock = new();

        /// <summary>Realms in menu order. Cities first, since that is where you start.</summary>
        private static readonly string[] Groups = { "Cities", "Albion", "Midgard", "Hibernia", "Elsewhere" };

        public string StopName => string.IsNullOrEmpty(GuildName) ? Name : GuildName;

        public override bool AddToWorld()
        {
            if (!base.AddToWorld())
                return false;

            Level = 70;
            Flags |= eFlags.PEACE; // Wardens stand outside hostile keeps.

            lock (_lock)
            {
                if (!_network.Contains(this))
                    _network.Add(this);
            }

            return true;
        }

        public override bool RemoveFromWorld()
        {
            lock (_lock)
                _network.Remove(this);

            return base.RemoveFromWorld();
        }

        public override bool Interact(GamePlayer player)
        {
            if (!base.Interact(player))
                return false;

            TurnTo(player, 5000);
            SayTo(player, eChatLoc.CL_PopupWindow, Menu());
            return true;
        }

        public override bool WhisperReceive(GameLiving source, string text)
        {
            if (!base.WhisperReceive(source, text))
                return false;

            GamePlayer player = source as GamePlayer;

            if (player == null)
                return false;

            GaherisTeleporter stop = Find(text);

            if (stop == null || stop == this)
            {
                SayTo(player, eChatLoc.CL_SystemWindow, "I know nowhere by that name.");
                return true;
            }

            Send(player, stop);
            return true;
        }

        private string Menu()
        {
            string text = "Anywhere you like. Your company comes with you.\n\n";

            foreach (string group in Groups)
            {
                List<GaherisTeleporter> stops = InGroup(group);

                if (stops.Count == 0)
                    continue;

                text += group + "\n";

                foreach (GaherisTeleporter stop in stops)
                    text += "  [" + stop.StopName + "]\n";

                text += "\n";
            }

            return text;
        }

        private List<GaherisTeleporter> InGroup(string group)
        {
            List<GaherisTeleporter> stops = new();

            lock (_lock)
            {
                foreach (GaherisTeleporter stop in _network)
                {
                    if (stop != this && GroupOf(stop) == group)
                        stops.Add(stop);
                }
            }

            stops.Sort((a, b) => string.Compare(a.StopName, b.StopName, StringComparison.OrdinalIgnoreCase));
            return stops;
        }

        private static string GroupOf(GaherisTeleporter stop)
        {
            switch (stop.CurrentRegionID)
            {
                case 1:   return "Albion";     // the mainland, frontier included
                case 100: return "Midgard";
                case 200: return "Hibernia";
                case 10:                       // Camelot
                case 101:                      // Jordheim
                case 201: return "Cities";     // Tir na Nog
                default:  return "Elsewhere";
            }
        }

        private static GaherisTeleporter Find(string name)
        {
            string wanted = name.ToLower().Trim();

            lock (_lock)
            {
                foreach (GaherisTeleporter stop in _network)
                {
                    if (stop.StopName.ToLower() == wanted)
                        return stop;
                }
            }

            return null;
        }

        private void Send(GamePlayer player, GaherisTeleporter stop)
        {
            if (!player.IsWithinRadius(this, WorldMgr.INTERACT_DISTANCE))
                return;

            if (player.InCombat)
            {
                SayTo(player, eChatLoc.CL_SystemWindow, "Not while you are fighting.");
                return;
            }

            foreach (GamePlayer nearby in GetPlayersInRadius(WorldMgr.VISIBILITY_DISTANCE))
                nearby.Out.SendSpellCastAnimation(this, 4468, 20);

            // Everything the player brought has to be moved by hand. Their
            // brains stop the moment the player is no longer in sight of them,
            // so anything left behind stays behind for good.
            List<GameNPC> retinue = new();

            foreach (GameMercenary merc in MercenaryManager.GetCompany(player))
                retinue.Add(merc);

            if (player.ControlledBrain != null && player.ControlledBrain.Body != null)
                retinue.Add(player.ControlledBrain.Body);

            player.MoveTo(stop.CurrentRegionID, stop.X + 80, stop.Y + 80, stop.Z, stop.Heading);

            int spread = 100;

            foreach (GameNPC follower in retinue)
            {
                spread += 50;
                follower.MoveTo(stop.CurrentRegionID, stop.X + spread, stop.Y + spread, stop.Z, stop.Heading);
            }
        }
    }
}
