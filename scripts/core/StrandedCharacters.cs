using System;
using System.Collections.Generic;
using DOL.Database;
using DOL.Events;
using DOL.GS.PacketHandler;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// Nobody is left saved inside an instance that no longer exists.
    ///
    /// An instance is built at runtime and dies with the server. A character
    /// autosaved while standing in one keeps that region id in the database,
    /// and on the next boot there is no such region to put them in. The result
    /// is not an error anybody can act on: the client reaches character
    /// select, cannot draw the character, and closes. From the player's side
    /// the character simply will not log in, twice, with nothing in the server
    /// log but a disconnect and no bytes received.
    ///
    /// It cost an evening to find once and would cost another every time, and
    /// it is not rare -- autosave runs every ten minutes, so anybody who spends
    /// ten minutes in a task dungeon is a restart away from it. OpenDAoC has no
    /// shutdown handler either, so the last autosave is what survives however
    /// carefully somebody logs out.
    ///
    /// So it is repaired at boot instead of diagnosed. Every instance region is
    /// gone by definition at that point, so any character holding one is stale
    /// and can be put back at its bind point with no judgement required.
    ///
    /// WorldMgr allocates instance ids from DEFAULT_VALUE_FOR_INSTANCE_ID_SEARCH_START
    /// upwards, which is where the threshold comes from rather than a guess.
    /// </summary>
    public static class StrandedCharacters
    {
        [GameServerStartedEvent]
        public static void OnServerStarted(DOLEvent e, object sender, EventArgs args)
        {
            try
            {
                IList<DbCoreCharacter> stranded = DOLDB<DbCoreCharacter>.SelectObjects(
                    DB.Column("Region").IsGreaterOrEqualTo(
                        WorldMgr.DEFAULT_VALUE_FOR_INSTANCE_ID_SEARCH_START));

                if (stranded == null || stranded.Count == 0)
                    return;

                int rescued = 0;

                foreach (DbCoreCharacter ch in stranded)
                {
                    // A bind of nought would be a worse place to wake up than
                    // the instance was, so those are left for a human to look
                    // at rather than moved somewhere arbitrary.
                    if (ch.BindRegion <= 0)
                    {
                        Console.WriteLine("StrandedCharacters: " + ch.Name + " is in region " +
                                          ch.Region + " and has no bind point. Left alone.");
                        continue;
                    }

                    Console.WriteLine("StrandedCharacters: " + ch.Name + " was saved in region " +
                                      ch.Region + ", which no longer exists. Moved to bind.");

                    ch.Region = (ushort) ch.BindRegion;
                    ch.Xpos = ch.BindXpos;
                    ch.Ypos = ch.BindYpos;
                    ch.Zpos = ch.BindZpos;
                    ch.Direction = (ushort) ch.BindHeading;

                    GameServer.Database.SaveObject(ch);
                    rescued++;
                }

                if (rescued > 0)
                    Console.WriteLine("StrandedCharacters: " + rescued +
                                      " character(s) recovered from dead instances.");
            }
            catch (Exception ex)
            {
                Console.WriteLine("StrandedCharacters: " + ex.Message);
            }
        }
    }
}
