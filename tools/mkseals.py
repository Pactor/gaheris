"""
Adapt Eve's ServerType.PVE.DreadedSeals.sql for OpenDAoC on Old Frontiers.

The only substantive change is the loot generator scope. Eve is a New
Frontiers database and registers the seal generator for region 163, which does
not exist as a reachable place here -- imported unchanged, nothing would ever
drop. Old Frontiers is regions 1, 100 and 200, and Darkness Falls (249) is
added because it is where the economy can be proven first: 2,493 mobs and 9 of
its 10 named bosses already exist.

LootGenerator.RegionID is matched against mob.CurrentRegionID, so a generator
registered for a region applies to every mob in it.
"""

SRC = "/home/dcosper/dol-db/ServerType.PVE.DreadedSeals.sql"
DST = "/home/dcosper/opendaoc/gaheris-seals.sql"

# The generator class is also swapped. Stock LootGeneratorDreadedSeals reads
# lord.Component.Keep.BaseLevel directly, and Old Frontiers lords are mob rows
# with no Component -- it throws, the catch swallows it, and every keep lord
# drops nothing. LootGeneratorGaherisSeals (in scripts/) resolves the keep by
# proximity instead. LootMgr searches ScriptMgr.Scripts first, so the script
# class wins on name.
GEN = "DOL.GS.Scripts.LootGeneratorGaherisSeals"

OLD_BLOCK = (
    "\t('163','DOL.GS.LootGeneratorDreadedSeals','dreadedseals_new_frontiers'),\n"
    "\t('245','DOL.GS.LootGeneratorDreadedSeals','dreadedseals_labyrinth');"
)

NEW_BLOCK = (
    "\t('1','%s','dreadedseals_of_albion'),\n"
    "\t('100','%s','dreadedseals_of_midgard'),\n"
    "\t('200','%s','dreadedseals_of_hibernia'),\n"
    "\t('249','%s','dreadedseals_darkness_falls'),\n"
    "\t('245','%s','dreadedseals_labyrinth');"
) % (GEN, GEN, GEN, GEN, GEN)

HEADER = """-- ===========================================================================
--  gaheris-seals.sql
--
--  The Dreaded Seal economy: collectors, seal items, consolidation recipes,
--  loot generators and boss loot.
--
--  Adapted from Eve-of-Darkness ServerType.PVE.DreadedSeals.sql. OpenDAoC
--  already implements the mechanism -- DreadedSealCollector.cs and
--  LootGeneratorDreadedSeals.cs, with tuning properties whose defaults
--  reproduce live Gaheris exactly. Only the data was missing.
--
--  One change from upstream: the loot generator is scoped to Old Frontiers
--  (regions 1, 100, 200) plus Darkness Falls (249), instead of Eve's New
--  Frontiers region 163. Imported unchanged, nothing would drop here.
--
--  Safe to re-run: every statement is REPLACE INTO.
-- ===========================================================================

"""

text = open(SRC, encoding="utf-8").read()

if OLD_BLOCK not in text:
    raise SystemExit("loot generator block not found -- upstream file changed shape")

text = text.replace(OLD_BLOCK, NEW_BLOCK)

with open(DST, "w", encoding="utf-8") as out:
    out.write(HEADER)
    out.write(text)

print("wrote", DST)
print("loot generator regions: 1, 100, 200 (Old Frontiers), 249 (Darkness Falls), 245")
