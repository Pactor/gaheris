using System.Collections.Generic;
using DOL.GS.Effects;
using DOL.GS.PacketHandler;
using DOL.GS.Spells;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// The Warlock's chambers, working.
    ///
    /// The core's handler carries its own epitaph:
    ///
    ///     // Likely to be broken. It used to override 'CastSpell', but it no
    ///     // longer exists in 'SpellHanlder'.
    ///     // Can't be tested since Warlocks aren't functional.
    ///
    /// The discharge half survives -- given an armed chamber it fires what is
    /// inside. What a refactor took away is the loading half: the override
    /// that swallowed the two spells clicked during the chamber's own cast.
    /// Without it a chamber always arms empty and says so.
    ///
    /// How it is meant to go: the chamber is a long cast, and during that
    /// animation the Warlock clicks a primary and then a secondary spell,
    /// which are taken into it rather than cast. When the animation ends the
    /// chamber is armed and floats above him. Casting it again later fires
    /// both at once, instantly, and spends it.
    ///
    /// This DERIVES from the core handler rather than replacing it outright,
    /// and that is not a nicety. The packet that draws the chamber orbs does
    ///
    ///     ChamberSpellHandler chamber = (ChamberSpellHandler)effect.SpellHandler;
    ///     sortList[chamber.EffectSlot] = effect;
    ///
    /// so anything not descended from ChamberSpellHandler throws the moment a
    /// chamber arms. Inheriting also means PrimarySpell, SecondarySpell and
    /// EffectSlot are the very fields that packet reads.
    ///
    /// ScriptMgr.CacheSpellHandlerConstructor walks the compiled scripts before
    /// the core assembly and returns the first match, so this is what gets
    /// built for eSpellType.Chamber.
    /// </summary>
    [SpellHandler(eSpellType.Chamber)]
    public class GaherisChamberSpellHandler : ChamberSpellHandler
    {
        public GaherisChamberSpellHandler(GameLiving caster, Spell spell, SpellLine line)
            : base(caster, spell, line)
        {
        }

        /// <summary>
        /// Which orb this chamber occupies above the Warlock's head.
        ///
        /// The core's GetEffectSlot knows five names and three of ours are not
        /// among them -- Decimation, Lesser Fate and Creation all come back
        /// nought. That matters more than a missing icon: the packet builds a
        /// list keyed 1 to 5 and writes one byte per entry, so a nought puts a
        /// sixth entry in it and the client is handed a longer packet than it
        /// expects.
        /// </summary>
        private static readonly Dictionary<string, int> ORBS = new()
        {
            { "Chamber of Minor Fate",   1 },
            { "Chamber of Lesser Fate",  1 },
            { "Chamber of Restraint",    2 },
            { "Chamber of Creation",     2 },
            { "Chamber of Destruction",  3 },
            { "Chamber of Decimation",   3 },
            { "Chamber of Fate",         4 },
            { "Chamber of Greater Fate", 5 },
        };

        private static int Orb(string chamber)
        {
            return ORBS.TryGetValue(chamber, out int slot) ? slot : 1;
        }

        /// <summary>An armed chamber of this name already floating above the caster.</summary>
        private GameSpellEffect Armed()
        {
            return FindEffectOnTarget(Caster, "Chamber", Spell.Name);
        }

        /// <summary>
        /// Open the loading window as the cast begins -- unless this cast is a
        /// discharge, in which case there is nothing to load and the chamber is
        /// about to be spent.
        /// </summary>
        public override bool CheckBeginCast(GameLiving selectedTarget)
        {
            if (!base.CheckBeginCast(selectedTarget))
                return false;

            if (Caster is not GamePlayer player || Armed() != null)
                return true;

            ChamberLoader.Open(player, Spell);
            player.Out.SendMessage("Select the first spell for your " + Spell.Name + ".",
                eChatType.CT_Spell, eChatLoc.CL_SystemWindow);

            return true;
        }

        /// <summary>
        /// The animation has ended. Take what was clicked into the chamber and
        /// arm it, or say plainly that nothing went in.
        /// </summary>
        public override void FinishSpellCast(GameLiving target)
        {
            if (Caster is not GamePlayer player)
                return;

            // A discharge closes nothing; no window was opened for it.
            if (Armed() != null)
                return;

            ChamberLoader.Loading loaded = ChamberLoader.Close(player);

            Caster.Mana -= PowerCost(target);

            if (loaded == null || loaded.Empty)
            {
                MessageToCaster("No spells were loaded into " + Spell.Name + ".",
                    eChatType.CT_Spell);
                return;
            }

            PrimarySpell = loaded.Primary;
            PrimarySpellLine = loaded.PrimaryLine;
            SecondarySpell = loaded.Secondary;
            SecondarySpellLine = loaded.SecondaryLine;
            EffectSlot = Orb(Spell.Name);

            MessageToCaster("Your " + Spell.Name + " is ready for use.", eChatType.CT_Spell);

            GameSpellEffect effect = CreateSpellEffect(Caster, 1);
            effect.Start(Caster);
            SendEffectAnimation(Caster, 0, false, 1);
            player.Out.SendWarlockChamberEffect(player);
        }

        /// <summary>
        /// Fire what is inside. An unloaded chamber does nothing here -- the
        /// loading happened during the cast and the arming when it finished.
        /// </summary>
        public override bool StartSpell(GameLiving target)
        {
            GameSpellEffect effect = Armed();

            if (effect == null || effect.SpellHandler is not GaherisChamberSpellHandler chamber)
                return true;

            GameLiving at = (Caster as GamePlayer)?.TargetObject as GameLiving ?? target;

            if (at == null)
            {
                MessageToCaster("You must have a target!", eChatType.CT_SpellResisted);
                return false;
            }

            Fire(chamber.PrimarySpell, chamber.PrimarySpellLine, at);
            Fire(chamber.SecondarySpell, chamber.SecondarySpellLine, at);

            // Spent. A chamber is a bank, not a buff.
            effect.Cancel(false);

            if (Caster is GamePlayer player)
                player.Out.SendWarlockChamberEffect(player);

            return true;
        }

        private void Fire(Spell spell, SpellLine line, GameLiving at)
        {
            if (spell == null || line == null)
                return;

            ScriptMgr.CreateSpellHandler(Caster, spell, line)?.StartSpell(at);
        }

        protected override GameSpellEffect CreateSpellEffect(GameLiving target, double effectiveness)
        {
            return new GameSpellEffect(this, 0, 0, effectiveness);
        }
    }
}
