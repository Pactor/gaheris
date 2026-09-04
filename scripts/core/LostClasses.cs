using System;
using System.Collections.Generic;
using DOL.Events;
using DOL.GS.PlayerClass;
using DOL.GS.Realm;
using DOL.GS.ServerProperties;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// The six classes the core ships switched off.
    ///
    /// Heretic, Warlock, Vampiir and all three Maulers cannot be made on a
    /// stock OpenDAoC: clicking Continue on the creation screen just returns
    /// you to the character list, and the log says
    ///
    ///     Wrong class: 58, realm:3 on character creation
    ///     Wrong race: 12, class:58 on character creation
    ///
    /// Two separate gates, both in the core, both deliberate and both blank.
    ///
    /// The first is GlobalConstants.STARTING_CLASSES_DICT, where each of the
    /// six is commented out of its realm's list. That dictionary is static
    /// readonly, but readonly only stops the field being reassigned -- the
    /// Lists inside are ordinary mutable lists, so they can be added to at
    /// startup.
    ///
    /// The second is each class's own EligibleRaces, which is an empty list
    /// with the real races commented out just above:
    ///
    ///     public override List&lt;PlayerRace&gt; EligibleRaces => new List&lt;PlayerRace&gt;()
    ///     {
    ///         // PlayerRace.Celt, PlayerRace.Lurikeen, PlayerRace.Shar,
    ///     };
    ///
    /// That one cannot be mutated -- it is expression-bodied and hands back a
    /// fresh empty list every time it is read. But it can be replaced, because
    /// ScriptMgr.FindCharacterClass walks GameServerScripts, which is
    ///
    ///     m_compiledScripts.Values.Concat(new[] { typeof(GameServer).Assembly })
    ///
    /// -- scripts first, core last -- and returns on the first match. So a
    /// script class carrying the same [CharacterClass] id is found before the
    /// core's and is used in its place. Each of the six below is that: the
    /// core class, subclassed, with the races it always had put back exactly
    /// as the comments record them.
    ///
    /// The data was never the problem. All six have their specialisations,
    /// spell lines, spells and abilities in the database already, and trainers
    /// standing in the world -- they were only ever locked at the door.
    /// </summary>
    public static class LostClasses
    {
        [GameServerStartedEvent]
        public static void OnServerStarted(DOLEvent e, object sender, EventArgs args)
        {
            int races = RestoreRaces();
            int opened = 0;

            opened += Allow(eRealm.Albion,   eCharacterClass.Heretic);
            opened += Allow(eRealm.Albion,   eCharacterClass.MaulerAlb);
            opened += Allow(eRealm.Midgard,  eCharacterClass.Warlock);
            opened += Allow(eRealm.Midgard,  eCharacterClass.MaulerMid);
            opened += Allow(eRealm.Hibernia, eCharacterClass.Vampiir);
            opened += Allow(eRealm.Hibernia, eCharacterClass.MaulerHib);

            int retired = RetireBaseClasses();

            Console.WriteLine("Lost classes: " + opened + " reopened, " + races +
                              " races restored, " + retired + " base classes retired");
        }

        [ServerProperty("gaheris", "gaheris_no_base_classes",
            "Take the base classes off the creation screen, so a character is " +
            "the class it was made as. Live retired archetypes years ago -- you " +
            "pick a Vampiir and you are one, rather than a Stalker who visits a " +
            "trainer at level five. False restores them.", true)]
        public static bool NO_BASE_CLASSES;

        /// <summary>
        /// Take Stalker, Fighter, Mage and the rest off the creation screen.
        ///
        /// Picking Stalker made a Stalker -- correctly, and the character
        /// select screen said so -- but there is no reason to offer the choice
        /// when the archetype step no longer exists. A character should be the
        /// class it was created as.
        ///
        /// Which ones are base classes is not a list kept here. Every one of
        /// them answers HasAdvancedFromBaseClass with false and every advanced
        /// class answers true, so the core is asked rather than second-guessed
        /// -- and a class added to a later core is handled without this needing
        /// to know about it.
        /// </summary>
        private static int RetireBaseClasses()
        {
            if (!NO_BASE_CLASSES)
                return 0;

            int removed = 0;

            foreach (List<eCharacterClass> classes in GlobalConstants.STARTING_CLASSES_DICT.Values)
            {
                for (int i = classes.Count - 1; i >= 0; i--)
                {
                    ICharacterClass found = ScriptMgr.FindCharacterClass((int) classes[i]);

                    if (found == null || found.HasAdvancedFromBaseClass())
                        continue;

                    classes.RemoveAt(i);
                    removed++;
                }
            }

            // Say what is actually left, because "30 retired" was true and a
            // Stalker was still created two minutes later. If a base class
            // survives, this is where it will show.
            foreach (KeyValuePair<eRealm, List<eCharacterClass>> realm
                     in GlobalConstants.STARTING_CLASSES_DICT)
            {
                List<string> left = new();

                foreach (eCharacterClass c in realm.Value)
                {
                    ICharacterClass found = ScriptMgr.FindCharacterClass((int) c);

                    if (found != null && !found.HasAdvancedFromBaseClass())
                        left.Add(c + "(" + (int) c + ")");
                }

                Console.WriteLine("  " + realm.Key + ": " + realm.Value.Count +
                                  " classes offered" +
                                  (left.Count > 0
                                      ? ", STILL BASE: " + string.Join(", ", left)
                                      : ", no base classes remain"));
            }

            return removed;
        }

        /// <summary>
        /// Put back the starting stats of the races the core commented out.
        ///
        /// Six of them are missing from GlobalConstants.STARTING_STATS_DICT --
        /// Half Ogre, Frostalf, Shar and the three Minotaurs -- and character
        /// creation reads that dictionary by race with no guard:
        ///
        ///     Dictionary&lt;eStat, int&gt; raceStats =
        ///         GlobalConstants.STARTING_STATS_DICT[(eRace) character.Race];
        ///
        /// A missing race therefore throws KeyNotFoundException inside
        /// IsCharacterValid, which catches everything, marks the character
        /// invalid and returns. The player is dropped back to the character
        /// list with no message and nothing in the log except the exception --
        /// which is exactly how a Shar Vampiir failed while a Lurikeen one
        /// worked.
        ///
        /// The numbers are the core's own, taken from the commented lines
        /// directly above the live ones, not invented.
        ///
        /// This also matters for the Maulers: their races include Korazh,
        /// Deifrang and Graoch, which are the three Minotaurs, so all three
        /// would have failed the same way.
        /// </summary>
        private static int RestoreRaces()
        {
            int added = 0;

            added += Stats(eRace.HalfOgre,         90, 70, 40, 40, 60, 60, 60, 60);
            added += Stats(eRace.Frostalf,         55, 55, 55, 60, 60, 75, 60, 60);
            added += Stats(eRace.Shar,             60, 80, 50, 50, 60, 60, 60, 60);
            added += Stats(eRace.AlbionMinotaur,   80, 70, 50, 40, 60, 60, 60, 60);
            added += Stats(eRace.MidgardMinotaur,  80, 70, 50, 40, 60, 60, 60, 60);
            added += Stats(eRace.HiberniaMinotaur, 80, 70, 50, 40, 60, 60, 60, 60);

            return added;
        }

        private static int Stats(eRace race, int str, int con, int dex, int qui,
                                 int intel, int pie, int emp, int chr)
        {
            if (GlobalConstants.STARTING_STATS_DICT.ContainsKey(race))
                return 0;

            GlobalConstants.STARTING_STATS_DICT[race] = new Dictionary<eStat, int>
            {
                { eStat.STR, str }, { eStat.CON, con },
                { eStat.DEX, dex }, { eStat.QUI, qui },
                { eStat.INT, intel }, { eStat.PIE, pie },
                { eStat.EMP, emp }, { eStat.CHR, chr },
            };

            return 1;
        }

        private static int Allow(eRealm realm, eCharacterClass charClass)
        {
            if (!GlobalConstants.STARTING_CLASSES_DICT.TryGetValue(realm, out List<eCharacterClass> classes))
                return 0;

            if (classes.Contains(charClass))
                return 0;

            classes.Add(charClass);
            return 1;
        }
    }
}
