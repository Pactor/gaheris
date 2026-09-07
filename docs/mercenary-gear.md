# What a hire will and will not wear

Reported as a Skald refusing scale and chain she is trained for.

---

## The bug

`MercenaryLoadout.Build` collected a class's abilities like this:

```csharp
foreach (Ability ability in abilities)
{
    if (ability != null && ability.SpecLevelRequirement <= level)
        loadout.Abilities.Add(ability);
}
```

and `Learn()` fed every one of them to `AddAbility`, which is an
**unconditional overwrite**:

```csharp
int oldLevel = oldAbility.Level;
oldAbility.Level = ability.Level;
```

A class carries more than one career specialisation and they overlap. The
Skald has both, and `classxspecialization` hands them back in this order:

```
SkaldCareer > CharacterStyleUserCareer > VikingCareer
```

`SkaldCareer` grants `MidArmor 4` -- chain. `VikingCareer` grants `MidArmor 3`
-- studded. VikingCareer is read **last**, so the Skald ended up trained for
studded and refused everything above it.

Core never had the problem, because a player is levelled into these one at a
time and `RefreshSpecDependantSkills` only ever raises:

```csharp
if (!HasAbility(ab.KeyName) || GetAbility(ab.KeyName).Level < ab.Level)
    AddAbility(ab, sendMessages);
```

A hire is built at its level in one pass, so the same rule has to be applied
here. It now keeps the **best** grant of each ability across every career the
class holds.

### Who else it hit

Only four classes had a career order that lost, but two of them badly:

| Class | Was | Should be | Wrong from |
|---|---|---|---|
| Skald | studded | chain | level 1 |
| Thane | studded | chain | level 1 |
| **Cleric** | leather | chain | level 10 |
| **Minstrel** | leather | chain | level 10 |

A level 50 Cleric or Minstrel hire was standing in leather.

Warden, Druid, Paladin, Armsman, Warrior, Mercenary, Hero, Champion, Scout,
Hunter, Ranger and Bard also hold two overlapping careers and were correct
only by luck of row order. They are no longer luck.

---

## What each hire is trained for

Straight out of `specxability`, which is the same table the game reads for a
player. Level is the character's, not a spec level -- career specialisations
gate on character level (`CareerSpecialization.GetSpecLevelForLiving` returns
`living.Level`).

### Albion

| Hire | 1 | 10 | 15 | 20 |
|---|---|---|---|---|
| Armsman | studded | chain (5) | plate (15) | plate |
| Paladin | studded | chain | chain | plate |
| Mercenary | chain | chain | chain | chain |
| Reaver | chain | chain | chain | chain |
| Cleric | leather | studded | studded | **chain** |
| Minstrel | leather | studded | studded | **chain** |
| Scout | leather | studded | studded | studded |
| Infiltrator | leather | leather | leather | leather |
| Friar | leather | leather | leather | leather |
| Mauler | leather | leather | leather | leather |
| Wizard, Theurgist, Cabalist, Sorcerer, Necromancer, Heretic | cloth | cloth | cloth | cloth |

### Midgard

| Hire | 1 | 10 | 15 | 20 |
|---|---|---|---|---|
| Warrior | chain | chain | chain | chain |
| Thane | chain | chain | chain | chain |
| Skald | chain | chain | chain | chain |
| Valkyrie | chain | chain | chain | chain |
| Berserker | studded | studded | studded | studded |
| Savage | studded | studded | studded | studded |
| Hunter | studded | studded | studded | studded |
| Healer | leather | studded | studded | **chain** |
| Shaman | leather | studded | studded | **chain** |
| Shadowblade | leather | leather | leather | leather |
| Mauler of Midgard | leather | leather | leather | leather |
| Runemaster, Spiritmaster, Bonedancer, Warlock | cloth | cloth | cloth | cloth |

### Hibernia

| Hire | 1 | 10 | 15 | 20 |
|---|---|---|---|---|
| Druid | scale | scale | scale | scale |
| Warden | scale | scale | scale | scale |
| Hero | reinforced | reinforced | **scale** | scale |
| Champion | reinforced | reinforced | reinforced | **scale** |
| Blademaster | reinforced | reinforced | reinforced | reinforced |
| Ranger | reinforced | reinforced | reinforced | reinforced |
| Bard | reinforced | reinforced | reinforced | reinforced |
| Nightshade | leather | leather | leather | leather |
| Vampiir | leather | leather | leather | leather |
| Mauler of Hibernia | leather | leather | leather | leather |
| Eldritch, Enchanter, Mentalist, Animist, Valewalker, Bainshee | cloth | cloth | cloth | cloth |

Armour ability levels are `ArmorLevel`: cloth 1, leather 2, studded and
reinforced 3, chain and scale 4, plate 5. A hire that can wear chain can wear
scale, and vice versa -- they are the same rung.

---

## Cross-realm

Armour already ignores realm for hires, on purpose. `MercenaryGear.WhyNot`
takes the best of all three:

```csharp
int allowed = Math.Max(merc.GetAbilityLevel(Abilities.AlbArmor),
              Math.Max(merc.GetAbilityLevel(Abilities.HibArmor),
                       merc.GetAbilityLevel(Abilities.MidArmor)));
```

so a Skald takes Albion chain and Hibernian scale, and the rung mapping below
it is the same one core uses.

**Weapons were not**, and that was an inconsistency rather than a decision.
`MercenaryLoadout.CanWield` delegates to
`GameServer.ServerRules.CheckAbilityToUseItem`, which opens with:

```csharp
if (!ServerProperties.Properties.ALLOW_CROSS_REALM_ITEMS)
{
    if (item.Realm != 0 && item.Realm != (int) living.Realm)
        return false;
}
```

`allow_cross_realm_items` was **False**, so a hire was refused another realm's
weapon on realm alone -- and even past that gate the proficiency mapping was
realm-locked: an Albion slashing sword asks for `Weapon_Slashing`, which no
Midgard class has ever had.

Migration `130-one-character-all-three-realms.sql` turns the property on. This
is a Gaheris server: one character walks all three realms and the drops come
back with them, so the refusal was a rule written for a server where they
could never have been there. With it on, core switches the proficiency check
from the item's realm to the wearer's and the equivalents count as the same
training:

| Item type | Albion asks for | Hibernia | Midgard |
|---|---|---|---|
| Slashing / Sword / Blades | Slashing | Blades | Swords |
| Axe / LeftAxe | Slashing | Blades | Axes |
| Crushing / Hammer / Blunt | Crushing | Blunt | Hammers |
| Polearm / Spear / CelticSpear | Polearms | CelticSpear | Spears |
| ThrustWeapon | Thrusting | Piercing | Thrusting |
| Piercing | Thrusting | Piercing | Piercing |
| TwoHanded | TwoHanded | LargeWeapons | TwoHanded |
| LargeWeapons | TwoHanded | LargeWeapons | LargeWeapons |

Bows are deliberately **not** equivalenced, in core or here -- a longbow still
asks for `Weapon_Longbows`. That is live behaviour and it stays, so a Hunter
still cannot pick up a Scout's bow.

Head armour is the one piece core keeps realm-locked even with the property on:

```csharp
if (ALLOW_CROSS_REALM_ITEMS && item.Item_Type != (int) eEquipmentItems.HEAD)
```

The property applies to players as well as hires, which on a co-operative
server is the point rather than a side effect. It is read at boot, so it needs
a restart.

One thing worth knowing about that branch: with the property on, the armour
check reads `player.Realm` with no null test, so passing a non-player living
through `CheckAbilityToUseItem` with an armour item would throw. Nothing does
-- every caller of `HasAbilityToUseItem` in core is a `GamePlayer`, and
`CanWield` is only ever reached for weapons -- but it is why armour for hires
stays in `WhyNot` rather than being handed to core.
