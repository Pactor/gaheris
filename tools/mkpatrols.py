"""
Build keep patrol routes for the Old Frontiers Gaheris garrison.

Two constraints shape this:

  * Waypoints are guards' own standing positions. A synthesised circle risks
    points inside walls or off cliffs; a position a guard already occupies is
    by definition valid ground.

  * Guards are clustered by ELEVATION before a route is built. A keep garrison
    spans roughly 900 units of height -- courtyard, wall walk, tower tops -- and
    a single ground-level circuit would march the wall guards through the air.
    Each elevation band gets its own circuit, so wall guards patrol the wall and
    courtyard guards patrol the courtyard.

Every guard in a band that can form a circuit is assigned to it. Bands too
sparse to make a sensible route are left standing.

Reads two TSV exports, writes SQL.
"""

import math

MAX_RADIUS = 2200.0    # beyond this a guard belongs to no keep
Z_BAND = 150           # elevation bucket size
MIN_PER_BAND = 4       # fewer than this cannot make a circuit
MAX_WAYPOINTS = 12
PATROL_SPEED = 250

keeps = {}
for line in open("/tmp/keeps.tsv"):
    p = line.rstrip("\n").split("\t")
    if len(p) < 6:
        continue
    keeps[int(p[0])] = {"name": p[1], "region": int(p[2]),
                        "x": int(p[3]), "y": int(p[4]), "z": int(p[5])}

guards = []
for line in open("/tmp/guards.tsv"):
    p = line.rstrip("\n").split("\t")
    if len(p) < 6:
        continue
    guards.append({"id": p[0], "cls": p[1], "region": int(p[2]),
                   "x": int(p[3]), "y": int(p[4]), "z": int(p[5])})


def esc(s):
    return "'" + str(s).replace("\\", "\\\\").replace("'", "\\'") + "'"


# assign each guard to its nearest keep within range
for g in guards:
    best, bestd = None, MAX_RADIUS
    for kid, k in keeps.items():
        if k["region"] != g["region"]:
            continue
        d = math.hypot(g["x"] - k["x"], g["y"] - k["y"])
        if d < bestd:
            best, bestd = kid, d
    g["keep"] = best

paths, points, assignments = [], [], []
static = 0

for kid, k in sorted(keeps.items()):
    mine = [g for g in guards if g.get("keep") == kid]
    if not mine:
        continue

    bands = {}
    for g in mine:
        band = int(round((g["z"] - k["z"]) / float(Z_BAND)))
        bands.setdefault(band, []).append(g)

    made = 0
    for band, members in sorted(bands.items()):
        if len(members) < MIN_PER_BAND:
            static += len(members)
            continue

        ordered = sorted(members, key=lambda g: math.atan2(g["y"] - k["y"], g["x"] - k["x"]))

        # even sample around the ring, capped
        if len(ordered) <= MAX_WAYPOINTS:
            waypoints = ordered
        else:
            step = len(ordered) / float(MAX_WAYPOINTS)
            waypoints = [ordered[int(i * step)] for i in range(MAX_WAYPOINTS)]

        path_id = "Gaheris_Patrol_%d_%d" % (kid, band + 100)
        paths.append(path_id)
        for step_no, g in enumerate(waypoints, start=1):
            points.append((path_id, step_no, g["x"], g["y"], g["z"]))
        for g in members:
            assignments.append((g["id"], path_id))
        made += 1

    print("  %-22s %d elevation bands routed, %d guards" % (k["name"], made, len(mine)))

with open("/tmp/patrols.sql", "w") as out:
    out.write("DELETE FROM pathpoints WHERE PathID LIKE 'Gaheris\\_Patrol\\_%';\n")
    out.write("DELETE FROM path       WHERE PathID LIKE 'Gaheris\\_Patrol\\_%';\n")
    out.write("UPDATE mob SET PathID=NULL WHERE PathID LIKE 'Gaheris\\_Patrol\\_%';\n")

    for pid in paths:
        out.write("INSERT INTO path (PathID, PathType, LastTimeRowUpdated, Path_ID) "
                  "VALUES (%s, 3, NOW(), %s);\n" % (esc(pid), esc(pid)))

    for pid, step_no, x, y, z in points:
        out.write("INSERT INTO pathpoints (PathID, Step, X, Y, Z, MaxSpeed, WaitTime, TriggerName, "
                  "LastTimeRowUpdated, PathPoints_ID) VALUES (%s, %d, %d, %d, %d, %d, 0, '', NOW(), %s);\n"
                  % (esc(pid), step_no, x, y, z, PATROL_SPEED, esc("%s_%d" % (pid, step_no))))

    for mob_id, pid in assignments:
        out.write("UPDATE mob SET PathID=%s WHERE Mob_ID=%s;\n" % (esc(pid), esc(mob_id)))

print()
print("routes      : %d" % len(paths))
print("waypoints   : %d" % len(points))
print("patrolling  : %d" % len(assignments))
print("left static : %d  (elevation bands too sparse to route)" % static)
