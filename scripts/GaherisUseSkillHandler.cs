using System;
using DOL.GS.Scripts;

namespace DOL.GS.PacketHandler.Client.v168
{
    /// <summary>
    /// Catches the spells clicked while a chamber is being cast.
    ///
    /// This is the piece the core lost. A chamber is loaded during its own
    /// animation: the Warlock starts the chamber, and the next two spells he
    /// clicks are taken into it rather than cast. That swallowing was done by
    /// an override of CastSpell which no longer exists, so the clicks go
    /// straight through, get cast normally, and the chamber arms empty.
    ///
    /// The click arrives here, in the skill packet, which is the only place
    /// that sees it before it becomes a cast:
    ///
    ///     else if (sk is Spell spell)
    ///     {
    ///         if (sksib is SpellLine spellLine)
    ///             player.CastSpell(spell, spellLine);
    ///     }
    ///
    /// So the packet is read far enough to know which skill was pressed, and
    /// if a chamber is open and still has room the spell goes into it instead.
    /// Everything else is rewound and handed to the core handler untouched --
    /// this must not become a second implementation of using a skill, because
    /// that is every ability, every style and every spell in the game.
    ///
    /// The namespace matters and is not decoration: a packet handler is only
    /// registered if its namespace ends with the client version, so one in
    /// DOL.GS.Scripts would be skipped in silence however correct it is.
    /// </summary>
    [PacketHandler(PacketHandlerType.TCP, eClientPackets.UseSkill,
        "Handles Player Use Skill Request.", eClientStatus.PlayerInGame)]
    public class GaherisUseSkillHandler : PacketHandler
    {
        private static readonly UseSkillHandler _core = new();

        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            long start = packet.Position;

            if (!Swallowed(client, packet))
            {
                packet.Position = start;
                _core.HandlePacket(client, packet);
            }
        }

        /// <summary>
        /// True when the click was taken into a chamber and must not be cast.
        /// </summary>
        private static bool Swallowed(GameClient client, GSPacketIn packet)
        {
            try
            {
                GamePlayer player = client.Player;

                if (player == null || player.CharacterClass is not PlayerClass.ClassWarlock)
                    return false;

                // Reading the packet exactly as the core does, because the
                // index only means anything against the same skill snapshot.
                if (client.Version >= GameClient.eClientVersion.Version1124)
                {
                    packet.ReadFloatLowEndian();
                    packet.ReadFloatLowEndian();
                    packet.ReadFloatLowEndian();
                    packet.ReadFloatLowEndian();
                    packet.ReadShort();
                }

                packet.ReadShort();
                int index = packet.ReadByte();
                int type = packet.ReadByte();

                var snap = player.GetAllUsableSkills();
                Skill sk = null;
                Skill sksib = null;

                if (type > 0)
                {
                    int begin = Math.Max(0, snap.FindIndex(it => it.Item1 is Specialization == false));

                    if (index + begin < snap.Count)
                    {
                        sk = snap[index + begin].Item1;
                        sksib = snap[index + begin].Item2;
                    }
                }
                else if (index < snap.Count)
                {
                    sk = snap[index].Item1;
                    sksib = snap[index].Item2;
                }

                if (sk is not Spell spell || sksib is not SpellLine line)
                    return false;

                return ChamberLoader.Take(player, spell, line);
            }
            catch (Exception)
            {
                // Anything unexpected means the core should have it, not that
                // the player loses the click.
                return false;
            }
        }
    }
}
