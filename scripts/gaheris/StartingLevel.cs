using System;
using DOL.Events;
using DOL.GS.PacketHandler;
using DOL.GS.ServerProperties;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// Everyone starts at level five, as the class they chose.
    ///
    /// Live did away with base classes years ago. You pick a Vampiir at
    /// creation and you are a Vampiir, rather than a Stalker who visits a
    /// trainer at level five and becomes one. The archetype is a historical
    /// step that no longer exists.
    ///
    /// Half of that is already true here. Character creation accepts the
    /// advanced classes -- the client sends them, and since the six that were
    /// locked out were reopened it accepts all of them -- so choosing Vampiir
    /// on the creation screen makes a Vampiir. What was missing is the level:
    /// the core requires a new character to be level 1
    ///
    ///     if (ch.Level != 1) { ... valid = false; }
    ///
    /// and refuses anything else, so creation cannot hand out level five
    /// directly. This does it on the way in instead, the first time the
    /// character enters the world.
    ///
    /// Experience is set as well as the level. Setting Level alone leaves a
    /// character owing the experience for the levels they were given, so the
    /// next kill drags them backwards.
    /// </summary>
    public static class StartingLevel
    {
        [ServerProperty("gaheris", "gaheris_starting_level",
            "The level every new character begins at. Live retired base " +
            "classes, so a character is the class it was created as from the " +
            "start rather than an archetype that advances at five. Set to 1 " +
            "for the old behaviour.", 5)]
        public static int STARTING_LEVEL;

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
            try
            {
                if (sender is not GamePlayer player)
                    return;

                int want = Math.Clamp(STARTING_LEVEL, 1, 50);

                if (player.Level >= want)
                    return;

                // Only a character who has never been played. Someone who has
                // earned their way to level 3 is not owed a jump to five, and
                // more importantly this must not fire on every login.
                if (player.Experience > 0)
                    return;

                long enough = player.GetExperienceNeededForLevel(want);

                player.Experience = enough;
                player.Level = (byte) want;

                player.Out.SendUpdatePlayer();
                player.Out.SendUpdatePoints();
                player.Out.SendUpdatePlayerSkills(true);
                player.Out.SendMessage(
                    "You begin your service at level " + want + ".",
                    eChatType.CT_Important, eChatLoc.CL_SystemWindow);

                player.SaveIntoDatabase();
            }
            catch (Exception)
            {
                // Never keep somebody out of the world over a starting level.
            }
        }
    }
}
