using System;
using System.Collections.Generic;
using DOL.AI.Brain;
using DOL.GS.PacketHandler;
using DOL.GS.Spells;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// The Animist's Fungal Potency, which had no spell type at all.
    ///
    /// Creeping Path, level 29, spell 150000. It arrived in our own spell
    /// sweep with an empty `Type` and an empty `Target`, so it had no handler
    /// and no way to choose anything to affect. It has never done a thing.
    ///
    /// It is real, and it is not one of ours. Patch 1.88:
    ///
    ///   "Animists receive a new ability in their Creeping baseline at level
    ///    29 called Fungal Potency. It is only usable in PVE zones, has a 2
    ///    second cast time, is non-interruptible and castable while on the
    ///    move. The effect is a 350 radius pet cast ability that reduces
    ///    resists against high level monsters."
    ///
    /// Every value we do have matches that note: cast time 2, MoveCast 1,
    /// Uninterruptible 1, range 2000, radius 350, value 15, level 29 of the
    /// Creeping baseline. Only the two columns blank in the reference were
    /// blank here.
    ///
    /// **Why not resist pierce**, which is the obvious reading of "reduces
    /// resists". eProperty.ResistPierce exists and is applied, but only like
    /// this, in SpellHandler:
    ///
    ///     primaryResistModifier -= Math.Max(0, Math.Min(ad.Target.ItemBonus[property], resistPierce));
    ///
    /// It offsets the victim's *item* resistance, and a monster has no items.
    /// Against the only thing this spell is allowed to be used on it would do
    /// exactly nothing, while looking entirely correct in the database. So the
    /// resists are taken off the monsters instead.
    ///
    /// **Why it lives on BodyResistDebuff.** A script cannot add a value to
    /// the core's eSpellType, so this behaviour has to hang off a type that
    /// already exists. BodyResistDebuff is honest about what it is, and the
    /// special path is entered only for a spell that targets a PET with a
    /// radius -- a shape no resist debuff in the database uses, checked
    /// against all nine of them. Every ordinary resist debuff falls through to
    /// the core untouched.
    ///
    /// Which resists: the patch note says "resists" without saying which, and
    /// the spell's own damage type is Body, which is simply the first magic
    /// resist and reads as an import default rather than a decision. All six
    /// magic resists are reduced, which is what makes it worth casting for a
    /// line of turrets.
    /// </summary>
    [SpellHandler(eSpellType.BodyResistDebuff)]
    public class FungalPotency : BodyResistDebuff
    {
        private static readonly eProperty[] MAGIC =
        {
            eProperty.Resist_Body,
            eProperty.Resist_Cold,
            eProperty.Resist_Energy,
            eProperty.Resist_Heat,
            eProperty.Resist_Matter,
            eProperty.Resist_Spirit,
        };

        public FungalPotency(GameLiving caster, Spell spell, SpellLine line)
            : base(caster, spell, line) { }

        /// <summary>
        /// The one shape that takes the special path: cast on a pet, with a
        /// radius to spread from. Nothing else in the database looks like this.
        /// </summary>
        private bool Fungal => Spell.Target is eSpellTarget.PET && Spell.Radius > 0;

        public override void ApplyEffectOnTarget(GameLiving target)
        {
            if (!Fungal)
            {
                base.ApplyEffectOnTarget(target);
                return;
            }

            Wither(target);
        }

        /// <summary>
        /// Take the resists off everything hostile standing near the pet.
        /// </summary>
        private void Wither(GameLiving pet)
        {
            if (pet == null || !pet.IsAlive)
                return;

            int amount = (int) Spell.Value;
            int duration = CalculateEffectDuration(pet);

            if (amount <= 0 || duration <= 0)
                return;

            List<GameNPC> withered = new();

            foreach (GameNPC npc in pet.GetNPCsInRadius((ushort) Spell.Radius))
            {
                if (npc == null || !npc.IsAlive)
                    continue;

                // Never anybody's pet, including the Animist's own turrets.
                if (npc.Brain is IControlledBrain)
                    continue;

                if (!GameServer.ServerRules.IsAllowedToAttack(Caster, npc, true))
                    continue;

                foreach (eProperty resist in MAGIC)
                    npc.DebuffCategory[resist] += amount;

                withered.Add(npc);
                SendEffectAnimation(npc, 0, false, 1);
            }

            if (withered.Count == 0)
            {
                MessageToCaster("There is nothing near your pet to weaken.",
                    eChatType.CT_SpellResisted);
                return;
            }

            MessageToCaster("The ground around your pet festers, weakening " +
                withered.Count + (withered.Count == 1 ? " creature." : " creatures."),
                eChatType.CT_Spell);

            // Put back exactly what was taken, whatever else has happened since.
            new ECSGameTimer(Caster, _ => Restore(withered, amount), duration).Start(duration);
        }

        private static int Restore(List<GameNPC> withered, int amount)
        {
            foreach (GameNPC npc in withered)
            {
                if (npc == null)
                    continue;

                foreach (eProperty resist in MAGIC)
                    npc.DebuffCategory[resist] -= amount;
            }

            return 0;
        }
    }
}
