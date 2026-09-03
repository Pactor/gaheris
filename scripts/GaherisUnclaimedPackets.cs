using System;

namespace DOL.GS.PacketHandler.Client.v168
{
    /// <summary>
    /// A logging handler on every packet code the server does not claim.
    ///
    /// The combat-mode probe proved two things and left one open. It is
    /// installed -- the audit reads the handler table and names it on 0x74 --
    /// and it hears nothing when the tilde is pressed. What that does not
    /// prove is that the client sent nothing, because a code with no handler
    /// is dropped without a word:
    ///
    ///     IPacketHandler packetHandler = _packetHandlers[code];
    ///
    ///     if (packetHandler == null)
    ///         return;
    ///
    /// 176 of the 256 codes are in that state. If this client sends combat mode
    /// on a code the server was never told about, it vanishes exactly the way
    /// a key that sends nothing does, and no amount of looking at 0x74 would
    /// ever show it.
    ///
    /// So every one of them is claimed here, and each says what it received.
    /// Press the tilde once with this loaded: either a line appears, and the
    /// code it names is the answer, or nothing does, and the key genuinely
    /// sends nothing and the matter is settled at the client.
    ///
    /// Generated, and meant to be deleted once the question is answered. These
    /// handlers only log -- they consume nothing the server was using, since
    /// by definition nothing was listening to these codes before.
    /// </summary>
    public static class UnclaimedPacketProbeNotes
    {
    }

    [PacketHandler(PacketHandlerType.TCP, 0x02, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe02 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x02 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x04, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe04 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x04 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x08, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe08 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x08 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x09, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe09 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x09 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x0A, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe0A : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x0A from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x0F, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe0F : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x0F from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x12, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe12 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x12 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x13, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe13 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x13 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x15, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe15 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x15 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x16, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe16 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x16 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x17, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe17 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x17 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x19, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe19 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x19 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x1B, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe1B : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x1B from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x1D, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe1D : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x1D from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x1E, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe1E : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x1E from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x1F, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe1F : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x1F from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x20, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe20 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x20 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x21, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe21 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x21 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x22, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe22 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x22 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x23, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe23 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x23 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x24, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe24 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x24 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x25, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe25 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x25 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x26, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe26 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x26 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x27, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe27 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x27 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x28, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe28 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x28 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x29, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe29 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x29 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x2A, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe2A : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x2A from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x2B, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe2B : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x2B from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x2C, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe2C : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x2C from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x2D, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe2D : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x2D from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x2E, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe2E : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x2E from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x2F, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe2F : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x2F from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x30, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe30 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x30 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x31, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe31 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x31 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x32, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe32 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x32 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x33, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe33 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x33 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x34, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe34 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x34 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x35, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe35 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x35 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x36, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe36 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x36 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x38, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe38 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x38 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x39, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe39 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x39 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x3A, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe3A : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x3A from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x3B, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe3B : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x3B from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x3C, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe3C : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x3C from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x3D, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe3D : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x3D from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x3E, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe3E : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x3E from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x3F, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe3F : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x3F from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x41, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe41 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x41 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x42, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe42 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x42 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x43, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe43 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x43 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x44, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe44 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x44 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x45, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe45 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x45 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x46, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe46 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x46 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x47, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe47 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x47 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x49, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe49 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x49 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x4A, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe4A : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x4A from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x4B, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe4B : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x4B from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x4D, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe4D : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x4D from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x4E, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe4E : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x4E from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x50, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe50 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x50 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x51, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe51 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x51 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x52, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe52 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x52 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x54, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe54 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x54 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x55, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe55 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x55 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x56, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe56 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x56 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x57, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe57 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x57 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x58, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe58 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x58 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x59, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe59 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x59 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x5A, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe5A : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x5A from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x5B, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe5B : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x5B from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x5C, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe5C : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x5C from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x5D, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe5D : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x5D from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x5E, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe5E : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x5E from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x5F, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe5F : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x5F from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x60, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe60 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x60 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x61, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe61 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x61 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x62, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe62 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x62 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x63, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe63 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x63 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x65, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe65 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x65 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x67, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe67 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x67 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x68, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe68 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x68 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x69, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe69 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x69 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x6A, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe6A : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x6A from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x6B, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe6B : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x6B from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x6C, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe6C : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x6C from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x6D, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe6D : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x6D from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x6E, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe6E : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x6E from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x70, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe70 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x70 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x72, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe72 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x72 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x73, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe73 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x73 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x75, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe75 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x75 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x77, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe77 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x77 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x7E, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe7E : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x7E from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x7F, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe7F : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x7F from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x81, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe81 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x81 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x83, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe83 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x83 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x86, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe86 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x86 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x88, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe88 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x88 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x89, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe89 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x89 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x8B, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe8B : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x8B from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x8C, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe8C : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x8C from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x8D, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe8D : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x8D from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x8E, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe8E : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x8E from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x8F, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe8F : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x8F from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x91, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe91 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x91 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x92, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe92 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x92 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x93, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe93 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x93 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x94, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe94 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x94 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x95, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe95 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x95 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x96, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe96 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x96 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x97, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe97 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x97 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x98, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe98 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x98 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x9A, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe9A : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x9A from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x9B, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe9B : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x9B from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x9C, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe9C : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x9C from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0x9E, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbe9E : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0x9E from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xA0, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeA0 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xA0 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xA1, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeA1 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xA1 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xA2, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeA2 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xA2 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xA4, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeA4 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xA4 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xA6, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeA6 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xA6 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xA8, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeA8 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xA8 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xAA, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeAA : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xAA from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xAB, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeAB : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xAB from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xAC, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeAC : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xAC from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xAD, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeAD : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xAD from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xAE, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeAE : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xAE from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xB1, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeB1 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xB1 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xB2, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeB2 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xB2 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xB3, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeB3 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xB3 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xB4, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeB4 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xB4 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xB6, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeB6 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xB6 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xB7, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeB7 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xB7 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xB8, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeB8 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xB8 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xB9, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeB9 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xB9 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xBC, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeBC : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xBC from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xBD, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeBD : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xBD from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xC1, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeC1 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xC1 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xC3, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeC3 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xC3 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xC4, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeC4 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xC4 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xC5, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeC5 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xC5 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xC6, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeC6 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xC6 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xC9, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeC9 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xC9 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xCC, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeCC : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xCC from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xCD, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeCD : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xCD from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xCE, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeCE : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xCE from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xCF, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeCF : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xCF from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xD1, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeD1 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xD1 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xD2, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeD2 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xD2 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xD3, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeD3 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xD3 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xD6, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeD6 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xD6 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xD7, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeD7 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xD7 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xD9, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeD9 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xD9 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xDA, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeDA : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xDA from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xDB, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeDB : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xDB from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xDE, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeDE : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xDE from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xDF, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeDF : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xDF from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xE1, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeE1 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xE1 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xE3, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeE3 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xE3 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xE5, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeE5 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xE5 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xE6, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeE6 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xE6 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xE7, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeE7 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xE7 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xE9, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeE9 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xE9 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xEA, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeEA : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xEA from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xEE, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeEE : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xEE from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xEF, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeEF : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xEF from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xF0, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeF0 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xF0 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xF1, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeF1 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xF1 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xF3, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeF3 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xF3 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xF6, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeF6 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xF6 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xF7, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeF7 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xF7 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xF9, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeF9 : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xF9 from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xFA, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeFA : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xFA from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xFB, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeFB : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xFB from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xFD, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeFD : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xFD from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

    [PacketHandler(PacketHandlerType.TCP, 0xFE, "probe", eClientStatus.PlayerInGame)]
    public class UnclaimedProbeFE : PacketHandler
    {
        protected override void HandlePacketInternal(GameClient client, GSPacketIn packet)
        {
            Console.WriteLine("Unclaimed packet 0xFE from " +
                              (client?.Player == null ? "?" : client.Player.Name) +
                              ", " + packet.PacketSize + " bytes");
        }
    }

}
