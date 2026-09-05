using System;
using DOL.AI.Brain;
using DOL.Events;
using DOL.GS.Effects;
using DOL.GS.PacketHandler;
using DOL.GS.ServerProperties;
using DOL.GS.Spells;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// Four Master Level abilities that did nothing at all, and the correction
    /// of an earlier attempt here that also did nothing.
    ///
    /// Every class in the game reaches all four -- ML lines are shared -- so
    /// this is everybody's, not one class's.
    ///
    ///   Spymaster 7   Lookout                +100 stealth beside a seated ally
    ///   Spymaster 10  Blanket of Camouflage  stealths the group
    ///   Convoker 6    Battlewarder           plants a warder that fights for you
    ///   Stormlord 6   Focusing Winds         locks a storm in place
    ///
    /// **What the first attempt got wrong.** These were read as effects that
    /// worked but never *ended*, because each core handler registers its
    /// breaking conditions on `Moving`, `AttackFinished` and `CastStarting` --
    /// events nothing raises. So watches were added to end them, hung off
    /// `OnEffectStart(GameSpellEffect)` to sit beside the core's own code.
    ///
    /// That callback is never reached either. All four core handlers derive
    /// from `SpellHandler` or `MasterlevelHandling`, neither of which builds a
    /// legacy `GameSpellEffect`, and none of the four calls `CreateSpellEffect`
    /// itself -- `SpellHandler.OnDurationEffectApply` builds an
    /// `ECSGameSpellEffect` instead. So the callback holding the core's work
    /// never ran, and the watches added to it never started.
    ///
    /// The effects were not too strong. They were **absent**: no stealth bonus,
    /// no group camouflage, no warder, no locked storm.
    ///
    /// Same mistake that hid Phaseshift, from the same wrong belief -- that a
    /// Master Level handler builds a legacy effect. Only the font and mine
    /// subclasses do.
    ///
    /// **The repair**, for all four: override `CreateECSEffect` so the effect
    /// really built is one of ours, do the core's work in `OnStartEffect`, undo
    /// it in `OnStopEffect`, and start the watches where they will actually
    /// run. Both halves in one place, because both were lost together.
    ///
    /// Two more ride the same dead events and are **not** holds: Forceful
    /// Zephyr and Phaseshift absorb the blow rather than ending. They live in
    /// `Phaseshift.cs` and `docs/master-levels.md`; Zephyr cannot be cast on
    /// this server at all, needing an enemy player.
    /// </summary>
    internal static class MasterLevelHolds
    {
        [ServerProperty("progression", "ml_holds_log",
            "Log when a Master Level effect starts, and when moving, attacking " +
            "or casting brings one to an end.", false)]
        public static bool LOG;

        public static void Say(string what)
        {
            if (LOG)
                Console.WriteLine("ML: " + what);
        }
    }

    // ----------------------------------------------------------------- Stormlord 6

    /// <summary>
    /// Focusing Winds. Locks a storm in place while the caster stands still --
    /// "Now the vortex of this storm is locked!" -- and no storm was ever
    /// locked, because the line that does it sat in the dead callback.
    /// </summary>
    [SpellHandler(eSpellType.FocusingWinds)]
    public class FocusingWindsHeld : FocusingWindsSpellHandler
    {
        public FocusingWindsHeld(GameLiving caster, Spell spell, SpellLine line)
            : base(caster, spell, line) { }

        public override ECSGameSpellEffect CreateECSEffect(in ECSGameEffectInitParams initParams)
        {
            return ECSGameEffectFactory.Create(initParams, static (in i) => new FocusingWindsEffect(i));
        }
    }

    public class FocusingWindsEffect : ECSGameSpellEffect
    {
        private MovementWatch _watch;

        public FocusingWindsEffect(in ECSGameEffectInitParams initParams) : base(initParams) { }

        public override void OnStartEffect()
        {
            base.OnStartEffect();

            GameLiving caster = SpellHandler?.Caster;

            if (Owner is not GameStorm storm || caster == null)
                return;

            storm.Movable = false;
            MasterLevelHolds.Say("a storm is locked by " + caster.Name);

            if (caster is GamePlayer said)
            {
                said.Out.SendMessage("Now the vortex of this storm is locked!",
                    eChatType.CT_System, eChatLoc.CL_SystemWindow);
            }

            _watch = new MovementWatch(caster, why =>
            {
                MasterLevelHolds.Say("the storm is released -- " + why);

                if (caster is GamePlayer moved)
                {
                    moved.Out.SendMessage("You are moving. Your concentration fades.",
                        eChatType.CT_SpellExpires, eChatLoc.CL_SystemWindow);
                }

                End();
            });

            _watch.Start();
        }

        public override void OnStopEffect()
        {
            base.OnStopEffect();

            _watch?.Stop();
            _watch = null;

            if (Owner is GameStorm storm)
                storm.Movable = true;
        }
    }

    // ---------------------------------------------------------------- Spymaster 10

    /// <summary>
    /// Blanket of Camouflage. Stealths the caster's group and drops off anyone
    /// who moves, attacks or casts. Nobody was ever stealthed.
    ///
    /// The core also keeps the effect in a single field while one handler
    /// serves the whole group in turn, so each member overwrote the last.
    /// Every effect here is its own object, so that cannot happen.
    /// </summary>
    [SpellHandler(eSpellType.BlanketOfCamouflage)]
    public class GroupstealthHeld : GroupstealthHandler
    {
        public GroupstealthHeld(GameLiving caster, Spell spell, SpellLine line)
            : base(caster, spell, line) { }

        public override ECSGameSpellEffect CreateECSEffect(in ECSGameEffectInitParams initParams)
        {
            return ECSGameEffectFactory.Create(initParams, static (in i) => new GroupstealthEffect(i));
        }
    }

    public class GroupstealthEffect : ECSGameSpellEffect
    {
        private MovementWatch _watch;

        public GroupstealthEffect(in ECSGameEffectInitParams initParams) : base(initParams) { }

        public override void OnStartEffect()
        {
            base.OnStartEffect();

            if (Owner is not GamePlayer hidden)
                return;

            hidden.Stealth(true);
            MasterLevelHolds.Say(hidden.Name + " is camouflaged");

            _watch = new MovementWatch(hidden, why =>
            {
                MasterLevelHolds.Say(hidden.Name + " loses camouflage -- " + why);
                hidden.Out.SendMessage("Your camouflage fades!",
                    eChatType.CT_SpellResisted, eChatLoc.CL_SystemWindow);
                End();
            },
            () => hidden.IsStealthed,
            onMove: true, onAttack: true, onCast: true);

            _watch.Start();
        }

        public override void OnStopEffect()
        {
            base.OnStopEffect();

            _watch?.Stop();
            _watch = null;

            if (Owner is GamePlayer hidden && hidden.IsStealthed)
                hidden.Stealth(false);
        }
    }

    // ----------------------------------------------------------------- Spymaster 7

    /// <summary>
    /// Lookout. The Spymaster hides beside a seated companion and gains a
    /// hundred points of stealth; either of them moving ends it. Neither the
    /// bonus nor the ending ever happened.
    ///
    /// Two watches, because either party can end it, which is what the core
    /// registered as well.
    /// </summary>
    [SpellHandler(eSpellType.Loockout)]
    public class LookoutThatEnds : LoockoutSpellHandler
    {
        public LookoutThatEnds(GameLiving caster, Spell spell, SpellLine line)
            : base(caster, spell, line) { }

        public override ECSGameSpellEffect CreateECSEffect(in ECSGameEffectInitParams initParams)
        {
            return ECSGameEffectFactory.Create(initParams, static (in i) => new LookoutEffect(i));
        }
    }

    public class LookoutEffect : ECSGameSpellEffect
    {
        private const int BORROWED_STEALTH = 100;

        private MovementWatch _sitter;
        private MovementWatch _scout;
        private GameLiving _scoutLiving;
        private bool _given;

        public LookoutEffect(in ECSGameEffectInitParams initParams) : base(initParams) { }

        public override void OnStartEffect()
        {
            base.OnStartEffect();

            if (Owner is not GamePlayer sat || SpellHandler?.Caster is not GamePlayer scout)
                return;

            _scoutLiving = scout;
            scout.BaseBuffBonusCategory[eProperty.Skill_Stealth] += BORROWED_STEALTH;
            _given = true;

            // The companion marker the core raises alongside it.
            new LoockoutOwner().Start(scout);

            MasterLevelHolds.Say(scout.Name + " keeps watch beside " + sat.Name);

            void Ends(GameLiving who, string why)
            {
                MasterLevelHolds.Say(who.Name + " ends the watch -- " + why);

                if (who is GamePlayer told)
                {
                    told.Out.SendMessage("You are moving. Your concentration fades!",
                        eChatType.CT_SpellResisted, eChatLoc.CL_SystemWindow);
                }

                End();
            }

            _sitter = new MovementWatch(sat, why => Ends(sat, why));
            _scout = new MovementWatch(scout, why => Ends(scout, why));
            _sitter.Start();
            _scout.Start();
        }

        public override void OnStopEffect()
        {
            base.OnStopEffect();

            _sitter?.Stop();
            _scout?.Stop();
            _sitter = null;
            _scout = null;

            if (_given && _scoutLiving != null)
            {
                _scoutLiving.BaseBuffBonusCategory[eProperty.Skill_Stealth] -= BORROWED_STEALTH;
                _given = false;

                global::DOL.GS.Spells.SpellHandler
                    .FindStaticEffectOnTarget(_scoutLiving, typeof(LoockoutOwner))?.Cancel(false);
            }
        }
    }

    // ------------------------------------------------------------------ Convoker 6

    /// <summary>
    /// Battlewarder. Plants a warder at the ground target that fights for the
    /// caster while he stands still. No warder was ever planted.
    ///
    /// The core builds the body in its constructor and calls AddToWorld only
    /// from the dead callback -- the same shape as the Ancient Transmuter. It
    /// is rebuilt here because the core's is a private field.
    /// </summary>
    [SpellHandler(eSpellType.Battlewarder)]
    public class BattlewarderThatEnds : BattlewarderSpellHandler
    {
        public BattlewarderThatEnds(GameLiving caster, Spell spell, SpellLine line)
            : base(caster, spell, line) { }

        public override ECSGameSpellEffect CreateECSEffect(in ECSGameEffectInitParams initParams)
        {
            return ECSGameEffectFactory.Create(initParams, static (in i) => new BattlewarderEffect(i));
        }
    }

    public class BattlewarderEffect : ECSGameSpellEffect
    {
        private GameNPC _warder;
        private MovementWatch _watch;
        private GameLiving _caster;

        public BattlewarderEffect(in ECSGameEffectInitParams initParams) : base(initParams) { }

        public override void OnStartEffect()
        {
            base.OnStartEffect();

            _caster = SpellHandler?.Caster;

            if (_caster is not GamePlayer caster)
                return;

            if (!caster.GroundTarget.IsValid || !caster.GroundTargetInView)
            {
                caster.Out.SendMessage("Your area target is out of range. Set a closer ground position.",
                    eChatType.CT_SpellResisted, eChatLoc.CL_SystemWindow);
                End();
                return;
            }

            _warder = new GameNPC
            {
                CurrentRegion = caster.CurrentRegion,
                Heading = (ushort) ((caster.Heading + 2048) % 4096),
                Level = 70,
                Realm = caster.Realm,
                Name = "Battle Warder",
                Model = 993,
                MaxSpeedBase = 0,
                GuildName = string.Empty,
                Size = 50,
                X = caster.GroundTarget.X,
                Y = caster.GroundTarget.Y,
                Z = caster.GroundTarget.Z,
            };

            _warder.AddBrain(new MLBrain());
            _warder.AddToWorld();

            MasterLevelHolds.Say(caster.Name + " plants a Battle Warder");

            GameEventMgr.AddHandler(_warder, GameLivingEvent.Dying, new DOLEventHandler(WarderFell));

            _watch = new MovementWatch(caster, why =>
            {
                MasterLevelHolds.Say("the Battle Warder is dismissed -- " + why);
                caster.Out.SendMessage("Your concentration fades.",
                    eChatType.CT_SpellExpires, eChatLoc.CL_SystemWindow);
                End();
            },
            onMove: true, onAttack: true, onCast: true);

            _watch.Start();
        }

        public override void OnStopEffect()
        {
            base.OnStopEffect();

            _watch?.Stop();
            _watch = null;

            if (_warder != null)
            {
                GameEventMgr.RemoveHandler(_warder, GameLivingEvent.Dying, new DOLEventHandler(WarderFell));
                _warder.Delete();
                _warder = null;
            }
        }

        /// <summary>Dying is one of the few events this server still raises.</summary>
        private void WarderFell(DOLEvent e, object sender, EventArgs args)
        {
            if (_caster is GamePlayer player)
            {
                player.Out.SendMessage("Your Battle Warder has fallen!",
                    eChatType.CT_SpellExpires, eChatLoc.CL_SystemWindow);
            }

            MasterLevelHolds.Say("the Battle Warder has fallen");
            End();
        }
    }
}
