using System;

namespace DOL.GS.PacketHandler.Client.v168
{
    /// <summary>
    /// A probe on the combat-mode toggle, to settle where it is being lost.
    ///
    /// Pressing the tilde does nothing, on every class rather than one, and
    /// the server side reads as if it should work: the handler refuses only a
    /// drawn bow, CharacterClass.StartAttack is overridden by exactly one
    /// class (the Disciple, and only while shaded), every other way out of
    /// AttackComponent.StartAttack sends a message saying why, and the
    /// messages it would send are present in the language table. Entering
    /// combat with nothing targeted has its own line -- "You enter combat mode
    /// but have no target!" -- so even the do-nothing case is supposed to say
    /// something. Silence is not one of the outcomes the code has.
    ///
    /// Which leaves the packet never arriving. This says so either way, and it
    /// can be trusted to, because it will actually be installed -- unlike the
    /// last script handler written here, which was ignored for a reason worth
    /// recording:
    ///
    ///     if (!type.Namespace.EndsWith(version, StringComparison.OrdinalIgnoreCase))
    ///         continue;
    ///
    /// A packet handler is only registered if its NAMESPACE ends with the
    /// client version, and version is the literal "v168". A handler in
    /// DOL.GS.Scripts is skipped in silence however correct it otherwise is,
    /// which is why the frontier door handler never replaced the core's and
    /// went unexplained at the time. Hence the namespace above.
    ///
    /// This is a diagnostic and is meant to come out again. It does the core's
    /// job faithfully -- it is a copy of PlayerAttackRequestHandler with a line
    /// of logging in front -- so leaving it in place breaks nothing while the
    /// question is being answered.
    /// </summary>
    [PacketHandler(PacketHandlerType.TCP, eClientPackets.PlayerAttackRequest,
        "Handles Player Attack Request", eClientStatus.PlayerInGame)]
    public class GaherisAttackRequestProbe : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            bool start = packet.ReadByte() != 0;

            // Zero here means the player pressed the key. One means the client
            // decided to stop on its own.
            bool userAction = packet.ReadByte() == 0;

            GamePlayer player = client.Player;

            Console.WriteLine("AttackRequest: " + (player == null ? "?" : player.Name) +
                              " start=" + start + " userAction=" + userAction +
                              " slot=" + (player == null ? "?" : player.ActiveWeaponSlot.ToString()) +
                              " weapon=" + (player?.ActiveWeapon == null ? "none" : player.ActiveWeapon.Name) +
                              " target=" + (player?.TargetObject == null ? "none" : player.TargetObject.Name));

            if (player == null)
                return;

            if (player.ActiveWeaponSlot == eActiveWeaponSlot.Distance)
            {
                if (userAction)
                    player.Out.SendMessage("You can't enter melee combat mode with a ranged weapon!",
                        eChatType.CT_YouHit, eChatLoc.CL_SystemWindow);

                return;
            }

            if (start && userAction)
                player.attackComponent.RequestStartAttack();
            else
                player.attackComponent.StopAttack();
        }
    }
}
