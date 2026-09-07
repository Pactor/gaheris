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

**Weapons are not**, and that is an inconsistency rather than a decision.
`MercenaryLoadout.CanWield` delegates to
`GameServer.ServerRules.CheckAbilityToUseItem`, which opens with:

```csharp
if (!ServerProperties.Properties.ALLOW_CROSS_REALM_ITEMS)
{
    if (item.Realm != 0 && item.Realm != (int) living.Realm)
        return false;
}
```

`allow_cross_realm_items` is **False** on this server. So a hire is refused
another realm's weapon on realm alone -- and even past that gate, the
proficiency mapping is realm-locked too: an Albion slashing sword asks for
`Weapon_Slashing`, which a Skald has never had. Only with the property on does
core map the equivalents (Slashing / Blades / Swords, Crushing / Blunt /
Hammers, Polearms / Celtic Spear / Spears, and so on).

Two ways to make hires cross-realm on weapons:

1. Turn `allow_cross_realm_items` on. One row, core does the rest -- but it
   applies to players as well as hires.
2. Do the equivalence mapping for hires only, in `CanWield`. Players unchanged,
   at the cost of carrying a copy of core's table.

Not decided yet.
