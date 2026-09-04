using System;
using System.Collections.Generic;
using DOL.GS.Scripts;

namespace DOL.GS.PacketHandler.Client.v168
{
    /// <summary>
    /// Catches list spells clicked while a chamber is being cast.
    ///
    /// There are two ways a spell reaches the server and they are different
    /// packets. `UseSkill` carries abilities, styles and specialisation
    /// entries by index. `UseSpell` carries a LIST spell -- what a caster
    /// actually clicks on the quickbar -- identified not by index but by which
    /// line it is in and what level it sits at:
    ///
    ///     GetSkill(player, spellLineIndex, spellLevel, out Skill sk, out SpellLine sl);
    ///
    ///     if (sk is Spell spell &amp;&amp; sl != null)
    ///         player.CastSpell(spell, sl);
    ///
    /// The chamber interception was written against the first of those, which
    /// is why clicking Molding Hex during a chamber cast did nothing: the click
    /// never went near it. A Warlock's spells are list spells, so this is the
    /// path that matters for chambers, and the other one is very nearly
    /// irrelevant to them.
    ///
    /// Same shape as its sibling: read far enough to identify the spell, offer
    /// it to the chamber, and if it is not wanted rewind and let the core
    /// handler do exactly what it always did.
    /// </summary>
    [PacketHandler(PacketHandlerType.TCP, eClientPackets.UseSpell,
        "Handles Player Use Spell Request.", eClientStatus.PlayerInGame)]
    public class GaherisUseSpellHandler : PacketHandler
    {
        private static readonly UseSpellHandler _core = new();

        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            long start = packet.Position;

            if (!Swallowed(client, packet))
            {
                packet.Position = start;
                _core.HandlePacket(client, packet);
            }
        }

        private static bool Swallowed(GameClient client, GSPacketIn packet)
        {
            try
            {
                GamePlayer player = client.Player;

                if (player == null || player.CharacterClass is not PlayerClass.ClassWarlock)
                    return false;

                int spellLevel;
                int spellLineIndex;

                // Read exactly as the core reads it. Nothing here is applied to
                // the player -- position and heading are left to the core pass,
                // so this cannot move anybody by looking at their packet.
                if (client.Version >= GameClient.eClientVersion.Version1124)
                {
                    packet.ReadFloatLowEndian();
                    packet.ReadFloatLowEndian();
                    packet.ReadFloatLowEndian();
                    packet.ReadFloatLowEndian();
                    packet.ReadShort();
                    packet.ReadShort();
                    spellLevel = packet.ReadByte();
                    spellLineIndex = packet.ReadByte();
                }
                else
                {
                    packet.ReadShort();
                    packet.ReadShort();

                    if (client.Version > GameClient.eClientVersion.Version171)
                    {
                        packet.ReadShort();
                        packet.ReadShort();
                        packet.ReadShort();
                        packet.ReadShort();
                    }

                    spellLevel = packet.ReadByte();
                    spellLineIndex = packet.ReadByte();
                }

                var snap = player.GetAllUsableListSpells();

                if (spellLineIndex >= snap.Count)
                    return false;

                List<Skill> skills = snap[spellLineIndex].Item2;
                Skill found = null;

                foreach (Skill skill in skills)
                {
                    if (skill is Spell s && s.Level == spellLevel)
                    {
                        found = skill;
                        break;
                    }
                }

                if (found is not Spell spell)
                    return false;

                return ChamberLoader.Take(player, spell, snap[spellLineIndex].Item1);
            }
            catch (Exception)
            {
                // Anything unexpected belongs to the core, not to a lost click.
                return false;
            }
        }
    }
}
