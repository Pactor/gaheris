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
    ///     // 'StartSpell' takes a target but we're not even using it.
    ///     // Can't be tested since Warlocks aren't functional.
    ///
    /// The discharge half of it survives -- given an armed chamber it will
    /// fire what is inside. What a refactor took away is the loading half: the
    /// override that swallowed the two spells clicked during the chamber's own
    /// cast. Without it a chamber always arms empty, which is what loading one
    /// does today.
    ///
    /// This replaces the core's handler rather than patching it, which works
    /// because ScriptMgr.CacheSpellHandlerConstructor walks GameServerScripts
    /// -- the compiled scripts first and the core assembly last -- and returns
    /// the first match. So a [SpellHandler(eSpellType.Chamber)] here simply
    /// wins.
    ///
    /// The mechanic, as live had it: the chamber is a long cast, and during
    /// that animation the Warlock clicks a primary and a secondary spell,
    /// which are taken into it instead of being cast. When the animation ends
    /// the chamber is armed and floats above him. Casting it again later fires
    /// both instantly, and spends it.
    ///
    /// Loading is opened here and closed here; the swallowing itself is in the
    /// skill packet handler, which is the only place that sees the click.
    /// </summary>
    [SpellHandler(eSpellType.Chamber)]
    public class GaherisChamberSpellHandler : SpellHandler
    {
        private ChamberLoader.Loading m_loaded;

        public GaherisChamberSpellHandler(GameLiving caster, Spell spell, SpellLine line)
            : base(caster, spell, line)
        {
        }

        /// <summary>Whatever this chamber was armed with.</summary>
        public Spell PrimarySpell => m_loaded?.Primary;
        public SpellLine PrimarySpellLine => m_loaded?.PrimaryLine;
        public Spell SecondarySpell => m_loaded?.Secondary;
        public SpellLine SecondarySpellLine => m_loaded?.SecondaryLine;

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

            if (Caster is not GamePlayer player)
                return true;

            if (Armed() != null)
                return true;

            ChamberLoader.Open(player, Spell);
            player.Out.SendMessage(
                "Select the first spell for your " + Spell.Name + ".",
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
            {
                base.FinishSpellCast(target);
                return;
            }

            // A discharge closes nothing -- no window was opened for it.
            if (m_discharging)
            {
                base.FinishSpellCast(target);
                return;
            }

            m_loaded = ChamberLoader.Close(player);

            Caster.Mana -= PowerCost(target);

            if (m_loaded == null || m_loaded.Empty)
            {
                MessageToCaster("No spells were loaded into " + Spell.Name + ".",
                    eChatType.CT_Spell);
                return;
            }

            MessageToCaster("Your " + Spell.Name + " is ready for use.", eChatType.CT_Spell);

            GameSpellEffect effect = CreateSpellEffect(Caster, 1);
            effect.Start(Caster);
            SendEffectAnimation(Caster, 0, false, 1);
            player.Out.SendWarlockChamberEffect(player);
        }

        private bool m_discharging;

        /// <summary>
        /// Fire what is inside, if anything is. An unarmed chamber does
        /// nothing here -- the loading happened during the cast and the
        /// arming happened when it finished.
        /// </summary>
        public override bool StartSpell(GameLiving target)
        {
            GameSpellEffect effect = Armed();

            if (effect == null)
                return true;

            if (effect.SpellHandler is not GaherisChamberSpellHandler chamber)
                return true;

            GameLiving at = (Caster as GamePlayer)?.TargetObject as GameLiving ?? target;

            if (at == null)
            {
                MessageToCaster("You must have a target!", eChatType.CT_SpellResisted);
                return false;
            }

            m_discharging = true;
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

            ISpellHandler handler = ScriptMgr.CreateSpellHandler(Caster, spell, line);
            handler?.StartSpell(at);
        }

        protected override GameSpellEffect CreateSpellEffect(GameLiving target, double effectiveness)
        {
            return new GameSpellEffect(this, 0, 0, effectiveness);
        }
    }
}
