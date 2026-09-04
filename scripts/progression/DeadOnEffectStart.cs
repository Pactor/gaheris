using DOL.Database;
using DOL.GS.PacketHandler;
using DOL.GS.Spells;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// Two more spells whose whole body sits in OnEffectStart(GameSpellEffect),
    /// the callback duration spells stopped reaching in the ECS rewrite.
    ///
    /// Both were found by re-running the deliverability sweep with a rule that
    /// the first pass got wrong. That pass treated "the handler mentions
    /// CreateSpellEffect" as proof its OnEffectStart is reached. Defining that
    /// method is not enough -- something has to *call* it -- and the corrected
    /// sweep turned up these two along with confirmation that a good many
    /// suspects were fine.
    ///
    /// The repair is the same shape in both: override CreateECSEffect so the
    /// effect that really gets built is one of ours, and do the work in
    /// OnStartEffect and OnStopEffect, which are reached. That is cleaner than
    /// the timer the Vampiir's buffs use, because the effect ending is a real
    /// event rather than a guess at the duration.
    /// </summary>
    [SpellHandler(eSpellType.WaterBreathing)]
    public class WaterBreathingThatWorks : WaterBreathingSpellHandler
    {
        public WaterBreathingThatWorks(GameLiving caster, Spell spell, SpellLine line)
            : base(caster, spell, line) { }

        public override ECSGameSpellEffect CreateECSEffect(in ECSGameEffectInitParams initParams)
        {
            return ECSGameEffectFactory.Create(initParams, static (in i) => new WaterBreathingEffect(i));
        }
    }

    /// <summary>
    /// Breathing underwater, and swimming faster while you do.
    ///
    /// Nine spells carry this type and they are not obscure: the Bard's Music,
    /// the Minstrel's Instruments, the Skald's Battlesongs, a potion, an item
    /// effect and a Sojourner master level. Every one of them told the player
    /// "You find yourself able to move freely and breathe water like air!" and
    /// then let them drown exactly as before.
    /// </summary>
    public class WaterBreathingEffect : ECSGameSpellEffect
    {
        public WaterBreathingEffect(in ECSGameEffectInitParams initParams)
            : base(initParams) { }

        public override void OnStartEffect()
        {
            base.OnStartEffect();

            if (Owner is not GamePlayer player || SpellHandler?.Spell == null)
                return;

            player.CanBreathUnderWater = true;
            player.BaseBuffBonusCategory[eProperty.WaterSpeed] += (int) SpellHandler.Spell.Value;
            player.Out.SendUpdateMaxSpeed();

            string said = string.IsNullOrEmpty(SpellHandler.Spell.Message1)
                ? "You find yourself able to move freely and breathe water like air!"
                : SpellHandler.Spell.Message1;

            player.Out.SendMessage(said, eChatType.CT_Spell, eChatLoc.CL_SystemWindow);
        }

        public override void OnStopEffect()
        {
            base.OnStopEffect();

            if (Owner is not GamePlayer player || SpellHandler?.Spell == null)
                return;

            // Core's own exception, kept: the Mythirian of Ektaktos grants this
            // by itself, so a spell running out must not take it away.
            DbInventoryItem worn = player.Inventory?.GetItem((eInventorySlot) 37);

            if (worn == null || !worn.Name.ToLower().Contains("ektaktos"))
                player.CanBreathUnderWater = false;

            player.BaseBuffBonusCategory[eProperty.WaterSpeed] -= (int) SpellHandler.Spell.Value;
            player.Out.SendUpdateMaxSpeed();

            if (player.IsDiving && !player.CanBreathUnderWater)
            {
                player.Out.SendMessage(
                    "With a gulp and a gasp you realize that you are unable to breathe underwater any longer!",
                    eChatType.CT_SpellExpires, eChatLoc.CL_SystemWindow);
            }
        }
    }

    /// <summary>
    /// The Sojourner's Ancient Transmuter, which never appeared.
    ///
    /// The core handler builds the merchant in its constructor and then calls
    /// AddToWorld only from the dead callback, so casting it summoned nothing
    /// at all. Every class can walk the Sojourner path, so this is everyone's.
    ///
    /// The merchant is rebuilt here rather than reused because the core's is a
    /// private field. Its stock, ML_transmuteritems, is the core's own.
    /// </summary>
    [SpellHandler(eSpellType.AncientTransmuter)]
    public class AncientTransmuterThatAppears : AncientTransmuterSpellHandler
    {
        private GameMerchant _shop;

        public AncientTransmuterThatAppears(GameLiving caster, Spell spell, SpellLine line)
            : base(caster, spell, line) { }

        public override ECSGameSpellEffect CreateECSEffect(in ECSGameEffectInitParams initParams)
        {
            return ECSGameEffectFactory.Create(initParams, static (in i) => new AncientTransmuterEffect(i));
        }

        public void Summon()
        {
            if (Caster is not GamePlayer caster || _shop != null)
                return;

            _shop = new GameMerchant
            {
                X = caster.X + Util.Random(20, 40) - Util.Random(20, 40),
                Y = caster.Y + Util.Random(20, 40) - Util.Random(20, 40),
                Z = caster.Z,
                CurrentRegion = caster.CurrentRegion,
                Heading = (ushort) ((caster.Heading + 2048) % 4096),
                Level = 1,
                Realm = caster.Realm,
                Name = "Ancient Transmuter",
                Model = 993,
                MaxSpeedBase = 0,
                GuildName = string.Empty,
                Size = 50,
                TradeItems = new MerchantTradeItems("ML_transmuteritems"),
            };

            _shop.Flags |= GameNPC.eFlags.PEACE;
            _shop.AddToWorld();
        }

        public void Dismiss()
        {
            if (_shop == null)
                return;

            _shop.Delete();
            _shop = null;
        }
    }

    public class AncientTransmuterEffect : ECSGameSpellEffect
    {
        public AncientTransmuterEffect(in ECSGameEffectInitParams initParams)
            : base(initParams) { }

        public override void OnStartEffect()
        {
            base.OnStartEffect();
            (SpellHandler as AncientTransmuterThatAppears)?.Summon();
        }

        public override void OnStopEffect()
        {
            base.OnStopEffect();
            (SpellHandler as AncientTransmuterThatAppears)?.Dismiss();
        }
    }
}
