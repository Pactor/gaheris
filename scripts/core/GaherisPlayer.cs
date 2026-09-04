using System;
using System.Reflection;
using DOL.Database;
using DOL.Events;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// The class the server uses for players, in place of GamePlayer.
    ///
    /// It exists for one reason: to let an effect shrink a blow before it
    /// lands. Three spells need that and none of them could have it --
    /// see DamageGate for why nothing else in reach was enough.
    ///
    /// `serverproperty.player_class` names this, and `GameClient` looks through
    /// the script assemblies for it. If it ever fails to load, core logs an
    /// error and falls back to plain GamePlayer, so the worst case is the
    /// server the repo had before rather than a server that will not run.
    ///
    /// **Keep this thin.** Everything a script can already do belongs in a
    /// script. What belongs here is only what genuinely cannot be reached any
    /// other way -- overrides of members that are virtual on GamePlayer and
    /// called by core. Every addition is paid for by every player on the
    /// server, so each one should name the thing it unblocks.
    /// </summary>
    public class GaherisPlayer : GamePlayer
    {
        public GaherisPlayer(GameClient client, DbCoreCharacter dbChar)
            : base(client, dbChar) { }

        /// <summary>
        /// Say at boot whether this class is actually the one players will get.
        ///
        /// Core only finds out at the moment somebody logs in, and when it
        /// cannot find the class it falls back silently enough that a server
        /// looks healthy while every damage-softening effect quietly does
        /// nothing again. The name lives in the database, so renaming or moving
        /// this class breaks the link with nothing to say so -- the same trap
        /// that mob.ClassType sets for the teleporters and guards.
        ///
        /// So it is checked here, out loud, once.
        /// </summary>
        [ScriptLoadedEvent]
        public static void OnScriptLoaded(DOLEvent e, object sender, EventArgs args)
        {
            string wanted = ServerProperties.Properties.PLAYER_CLASS;
            string mine = typeof(GaherisPlayer).FullName;

            if (!string.Equals(wanted, mine, StringComparison.Ordinal))
            {
                Console.WriteLine($"GaherisPlayer: players will NOT use this class -- " +
                                  $"serverproperty player_class is '{wanted}', this is '{mine}'. " +
                                  "Focus Shell and Phaseshift will absorb nothing.");
                return;
            }

            // The same lookup core does at login, done now rather than then.
            bool found = false;

            foreach (Assembly assembly in ScriptMgr.Scripts)
            {
                if (assembly.GetType(mine) != null)
                {
                    found = true;
                    break;
                }
            }

            Console.WriteLine(found
                ? $"GaherisPlayer: in use as player_class ({mine})."
                : $"GaherisPlayer: player_class names '{mine}' but no script assembly holds it.");
        }

        /// <summary>
        /// Both attack paths call this immediately before the damage is
        /// applied -- `WeaponAction.FinalizeAttack` and
        /// `SpellHandler.DamageTarget`, each followed by `DealDamage` -- so
        /// this is where a blow can still be made smaller.
        ///
        /// Softened before the base call rather than after, so that the damage
        /// messages the base sends quote the number the player actually takes.
        /// </summary>
        public override void OnAttackedByEnemy(AttackData ad)
        {
            DamageGate.Soften(this, ad);
            base.OnAttackedByEnemy(ad);
        }
    }
}
