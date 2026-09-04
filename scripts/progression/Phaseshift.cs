using System;
using DOL.GS.PacketHandler;
using DOL.GS.ServerProperties;
using DOL.GS.Spells;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// Phaseshift, Sojourner 9, which every class can reach.
    ///
    /// A short self-protection: while it holds, blows against you do nothing.
    /// Two separate things stopped it working, and both had to be fixed.
    ///
    /// **The absorption was on a dead event.** The core handler registers
    /// `GamePlayerEvent.AttackedByEnemy` and nothing raises it, so no damage
    /// was ever zeroed. It now goes through `DamageGate`, which `GaherisPlayer`
    /// consults before a blow lands.
    ///
    /// **And it was never even reached.** `MasterlevelHandling` derives
    /// straight from `SpellHandler` and does not build a legacy effect -- only
    /// its font and mine subclasses do that -- so `OnEffectStart(GameSpellEffect)`
    /// is as unreachable here as anywhere else. That is worth stating plainly
    /// because an earlier sweep in this repo assumed the opposite and excused
    /// every Master Level handler on those grounds. It was wrong.
    ///
    /// A consequence of the second fault: the endurance was never charged
    /// either. Core takes half the caster's endurance in that same dead
    /// callback, so the spell has been free as well as useless. It is charged
    /// here, where the effect really starts.
    /// </summary>
    [SpellHandler(eSpellType.Phaseshift)]
    public class PhaseshiftThatHolds : PhaseshiftHandler
    {
        /// <summary>
        /// Core only ever zeroed damage from a GamePlayer:
        ///
        ///     if (ad.Attacker is GamePlayer)
        ///
        /// which on a co-operative server is nothing at all. On by default for
        /// the same reason as Focus Shell -- a spell that does nothing is not a
        /// working spell -- and a switch rather than a decision baked in.
        /// </summary>
        [ServerProperty("gaheris", "phaseshift_stops_monsters",
            "Whether Phaseshift stops damage from monsters. Core only ever " +
            "stopped damage from players, which on a co-operative server means " +
            "it stops nothing. Off restores core's behaviour.", true)]
        public static bool STOPS_MONSTERS;

        public PhaseshiftThatHolds(GameLiving caster, Spell spell, SpellLine line)
            : base(caster, spell, line) { }

        public override ECSGameSpellEffect CreateECSEffect(in ECSGameEffectInitParams initParams)
        {
            return ECSGameEffectFactory.Create(initParams, static (in i) => new PhaseshiftEffect(i));
        }
    }

    public class PhaseshiftEffect : ECSGameSpellEffect, ISoftensDamage
    {
        private int _charged;

        public PhaseshiftEffect(in ECSGameEffectInitParams initParams)
            : base(initParams) { }

        public override void OnStartEffect()
        {
            base.OnStartEffect();

            if (Owner == null)
                return;

            DamageGate.Register(Owner, this);

            // Half the caster's endurance, which core meant to take and never
            // did. Charged against the owner of the effect, which for a self
            // cast is the caster.
            _charged = Owner.MaxEndurance / 2;

            if (_charged > Owner.Endurance)
                _charged = Owner.Endurance;

            Owner.Endurance -= _charged;

            if (Owner is GamePlayer player)
            {
                player.Out.SendMessage("You phase out of the world around you.",
                    eChatType.CT_Spell, eChatLoc.CL_SystemWindow);
            }
        }

        public override void OnStopEffect()
        {
            base.OnStopEffect();
            DamageGate.Unregister(Owner, this);
        }

        public void Soften(AttackData ad)
        {
            if (ad == null)
                return;

            if (ad.Attacker != null && ad.Attacker.Realm is eRealm.None &&
                !PhaseshiftThatHolds.STOPS_MONSTERS)
                return;

            if (ad.Damage <= 0 && ad.CriticalDamage <= 0)
                return;

            ad.Damage = 0;
            ad.CriticalDamage = 0;

            if (ad.Attacker is GamePlayer attacker)
            {
                attacker.Out.SendMessage(
                    (Owner?.Name ?? "Your target") + " is phaseshifted and cannot be attacked!",
                    eChatType.CT_Action, eChatLoc.CL_SystemWindow);
            }
        }
    }
}
