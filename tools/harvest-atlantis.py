#!/usr/bin/env python3
"""
Harvests Atlantis mob placements from CapnBry's Bestiary.

The upstream OpenDAoC world data carries 70 mobs across the whole of Atlantis
against 97,737 in the world as a whole -- the zones exist and are empty. This
site indexed them off radar captures in 2002-2004 and, usefully, numbers its
zones the same way the game does, so the coordinates drop straight in.

Polite by construction: one request a second, identified, and each mob fetched
once however many zones it turns up in.

Writes: /tmp/atlantis-mobs.json
"""
import json, re, time, urllib.request, urllib.error, sys

BASE = "http://capnbry.net/daoc/"
AGENT = "gaheris-server-import/1.0 (personal DAoC server; contact via github.com/Pactor/gaheris)"
DELAY = 1.0

# zone -> (our RegionID, OffsetX*8192, OffsetY*8192), from our own zones table.
ZONES = {
    70: (70, 524288, 524288, "Ruins of Atlantis"),
    71: (71, 524288, 524288, "Ruinerar av Atlantis"),
    72: (72, 524288, 524288, "Scrios de Atlantis"),
    73: (73, 262144, 524288, "Oceanus Hesperos"),
    74: (73, 327680, 524288, "Mesothalassa"),
    75: (73, 327680, 458752, "Oceanus Boreal"),
    76: (73, 327680, 589824, "Oceanus Notos"),
    77: (73, 393216, 524288, "Oceanus Anatole"),
    81: (73, 294912, 393216, "Stygian Delta"),
    82: (73, 229376, 393216, "Land of Atum"),
    83: (83, 8192, 8192, "Halls of Ma'ati"),
    84: (73, 458752, 524288, "Typhon's Reach"),
    85: (73, 524288, 524288, "Ashen Isles"),
    86: (73, 360448, 655360, "Green Glades"),
    87: (73, 425984, 655360, "Arbor Glen"),
    88: (88, 8192, 8192, "the Great Pyramid of Stygia"),
    89: (89, 8192, 8192, "Deep Volcanus"),
    90: (90, 8192, 8192, "City of Aerus"),
}


def get(url):
    req = urllib.request.Request(url, headers={"User-Agent": AGENT})
    for attempt in range(3):
        try:
            with urllib.request.urlopen(req, timeout=45) as r:
                return r.read().decode("utf-8", "replace")
        except Exception as e:
            if attempt == 2:
                print("  FAILED %s (%s)" % (url, e), file=sys.stderr)
                return None
            time.sleep(3)
    return None


# ---------------------------------------------------------------- mob ids
ids = {}
for z in sorted(ZONES):
    page = get(BASE + "mobs.php?z=%d" % z)
    time.sleep(DELAY)

    if not page:
        continue

    found = set(int(m) for m in re.findall(r"mobs\.php\?z=%d&m=(\d+)" % z, page))
    for m in found:
        ids.setdefault(m, z)

    print("zone %-4d %-30s %d mobs" % (z, ZONES[z][3], len(found)), flush=True)

print("\nunique mobs to fetch: %d" % len(ids), flush=True)
print("estimated time: %.0f minutes\n" % (len(ids) * DELAY / 60.0), flush=True)

# ---------------------------------------------------------------- details
out = []
done = 0

for mob_id in sorted(ids):
    xml = get(BASE + "mobs.php?f=xml&m=%d" % mob_id)
    time.sleep(DELAY)
    done += 1

    if done % 50 == 0:
        print("  %d/%d fetched, %d placements" % (done, len(ids), len(out)), flush=True)

    if not xml:
        continue

    name = re.search(r"<name>(.*?)</name>", xml, re.S)
    tag = re.search(r"<typetag>(.*?)</typetag>", xml, re.S)
    name = name.group(1).strip() if name else None
    tag = tag.group(1).strip() if tag else ""

    if not name:
        continue

    for seen in re.finditer(r"<mobseen>(.*?)</mobseen>", xml, re.S):
        block = seen.group(1)

        def field(f):
            m = re.search(r"<%s>(-?\d+)</%s>" % (f, f), block)
            return int(m.group(1)) if m else None

        z = field("zone")

        if z not in ZONES:
            continue

        x, y, zz, lvl = field("x"), field("y"), field("z"), field("level")

        if x is None or y is None:
            continue

        region, ox, oy, zname = ZONES[z]

        out.append({
            "mob_id": mob_id,
            "name": name,
            "typetag": tag,
            "zone": z,
            "zone_name": zname,
            "region": region,
            "x": ox + x,
            "y": oy + y,
            "z": zz if zz is not None else 0,
            "level": lvl if lvl is not None else 0,
        })

with open("/tmp/atlantis-mobs.json", "w", encoding="utf-8") as fh:
    json.dump(out, fh, indent=1)

print("\nDONE: %d placements from %d mobs" % (len(out), len(ids)))
by_zone = {}
for r in out:
    by_zone[r["zone_name"]] = by_zone.get(r["zone_name"], 0) + 1
for zn in sorted(by_zone, key=lambda k: -by_zone[k]):
    print("  %-32s %d" % (zn, by_zone[zn]))
