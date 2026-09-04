# diagnostics/

Temporary. **Delete this folder before any release.**

| File | |
|---|---|
| `UnclaimedPackets.cs` | Registers ~176 no-op handlers so unhandled client opcodes can be counted |
| `UnknownPacketLog.cs` | Logs opcodes the server has no handler for, with a guess at why they were sent |
| `PacketAudit.cs` | Traces packets around a particular action |
| `AttackRequestProbe.cs` | Traces the attack request path |

These exist to answer a question, not to run a server. They cost a handler
registration per opcode and write to the console.
