#!/usr/bin/env python3
"""
Harvests Deep Volcanus (capnbry zone 89) -- the one Atlantis zone db-public
cannot fill. One request a second, identified, each mob fetched once.
"""
import json, re, time, urllib.request, sys

BASE = "http://capnbry.net/daoc/"
AGENT = "gaheris-server-import/1.0 (personal DAoC server; contact via github.com/Pactor/gaheris)"
DELAY = 1.0

# our zones table: ZoneID 89 -> RegionID 89, OffsetX 1, OffsetY 1 (x8192)
REGION, OX, OY = 89, 8192, 8192


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


page = get(BASE + "mobs.php?z=89")
ids = sorted({int(m) for m in re.findall(r"mobs\.php\?z=89&m=(\d+)", page or "")})
print("mobs to fetch: %d" % len(ids), flush=True)
time.sleep(DELAY)

out = []
for n, mid in enumerate(ids, 1):
    xml = get(BASE + "mobs.php?f=xml&m=%d" % mid)
    time.sleep(DELAY)

    if n % 15 == 0:
        print("  %d/%d" % (n, len(ids)), flush=True)

    if not xml:
        continue

    nm = re.search(r"<name>(.*?)</name>", xml, re.S)
    tg = re.search(r"<typetag>(.*?)</typetag>", xml, re.S)
    name = nm.group(1).strip() if nm else None
    tag = tg.group(1).strip() if tg else ""

    if not name:
        continue

    for seen in re.finditer(r"<mobseen>(.*?)</mobseen>", xml, re.S):
        b = seen.group(1)

        def f(k):
            m = re.search(r"<%s>(-?\d+)</%s>" % (k, k), b)
            return int(m.group(1)) if m else None

        if f("zone") != 89:
            continue

        x, y, z, lvl = f("x"), f("y"), f("z"), f("level")
        if x is None or y is None:
            continue

        out.append({"mob_id": mid, "name": name, "typetag": tag,
                    "region": REGION, "x": OX + x, "y": OY + y,
                    "z": z or 0, "level": lvl or 0})

json.dump(out, open("/tmp/volcanus.json", "w"), indent=1)
print("\n%d placements from %d mobs -> /tmp/volcanus.json" % (len(out), len(ids)))
