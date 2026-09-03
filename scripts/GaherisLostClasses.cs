using System;
using System.Collections.Generic;
using DOL.Events;
using DOL.GS.PlayerClass;
using DOL.GS.Realm;

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
            int opened = 0;

            opened += Allow(eRealm.Albion,   eCharacterClass.Heretic);
            opened += Allow(eRealm.Albion,   eCharacterClass.MaulerAlb);
            opened += Allow(eRealm.Midgard,  eCharacterClass.Warlock);
            opened += Allow(eRealm.Midgard,  eCharacterClass.MaulerMid);
            opened += Allow(eRealm.Hibernia, eCharacterClass.Vampiir);
            opened += Allow(eRealm.Hibernia, eCharacterClass.MaulerHib);

            Console.WriteLine("Lost classes: " + opened + " reopened for character creation");
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

    // Each of these exists only to hand back the races the core commented out.
    // The [CharacterClass] id is what makes it win over the core's version;
    // everything else about the class is inherited untouched.

    [CharacterClass((int) eCharacterClass.Vampiir, "Vampiir", "Stalker")]
    public class GaherisVampiir : ClassVampiir
    {
        public override List<PlayerRace> EligibleRaces => new()
        {
            PlayerRace.Celt, PlayerRace.Lurikeen, PlayerRace.Shar,
        };
    }

    [CharacterClass((int) eCharacterClass.Heretic, "Heretic", "Acolyte")]
    public class GaherisHeretic : ClassHeretic
    {
        public override List<PlayerRace> EligibleRaces => new()
        {
            PlayerRace.Korazh, PlayerRace.Avalonian, PlayerRace.Briton, PlayerRace.Inconnu,
        };
    }

    [CharacterClass((int) eCharacterClass.Warlock, "Warlock", "Mystic")]
    public class GaherisWarlock : ClassWarlock
    {
        public override List<PlayerRace> EligibleRaces => new()
        {
            PlayerRace.Frostalf, PlayerRace.Kobold, PlayerRace.Norseman,
        };
    }

    [CharacterClass((int) eCharacterClass.MaulerAlb, "Mauler", "Fighter")]
    public class GaherisMaulerAlb : ClassMaulerAlb
    {
        public override List<PlayerRace> EligibleRaces => new()
        {
            PlayerRace.Korazh, PlayerRace.Briton, PlayerRace.Inconnu,
        };
    }

    [CharacterClass((int) eCharacterClass.MaulerMid, "Mauler", "Viking")]
    public class GaherisMaulerMid : ClassMaulerMid
    {
        public override List<PlayerRace> EligibleRaces => new()
        {
            PlayerRace.Kobold, PlayerRace.Deifrang, PlayerRace.Norseman,
        };
    }

    [CharacterClass((int) eCharacterClass.MaulerHib, "Mauler", "Guardian")]
    public class GaherisMaulerHib : ClassMaulerHib
    {
        public override List<PlayerRace> EligibleRaces => new()
        {
            PlayerRace.Celt, PlayerRace.Graoch, PlayerRace.Lurikeen,
        };
    }
}
