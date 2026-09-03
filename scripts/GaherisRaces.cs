using System;
using System.Collections.Generic;
using DOL.Events;
using DOL.GS.PlayerClass;
using DOL.GS.Realm;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// The races the core trimmed out of its own classes.
    ///
    /// Six races are commented out of GlobalConstants.STARTING_STATS_DICT, and
    /// wherever one of them appeared in a class's EligibleRaces the whole line
    /// was commented out with it and replaced by a shorter one. Twenty classes
    /// lost at least one race that way, and two -- Bainshee and Valkyrie --
    /// lost every race they had, so they could not be created at all despite
    /// being perfectly present everywhere else.
    ///
    /// That is why a Shar Ranger was refused with "Wrong race: 18, class:50":
    /// ClassRanger reads
    ///
    ///     //PlayerRace.Celt, PlayerRace.Elf, PlayerRace.Lurikeen, PlayerRace.Shar,
    ///       PlayerRace.Celt, PlayerRace.Elf, PlayerRace.Lurikeen,
    ///
    /// with the real list directly above the trimmed one.
    ///
    /// Each class below restores the union of both lines -- everything the core
    /// itself records as belonging there. Nothing is invented; every race name
    /// is copied from the file it came from. These win over the core's versions
    /// because ScriptMgr.FindCharacterClass walks the script assemblies before
    /// the core one and returns on the first match.
    ///
    /// This file is generated from the core's own sources. Regenerate rather
    /// than edit by hand.
    /// </summary>
    [CharacterClass((int) eCharacterClass.Armsman, "Armsman", "Fighter", "Armswoman")]
    public class GaherisRacesArmsman : ClassArmsman
    {
        public override List<PlayerRace> EligibleRaces => new()
        {
            PlayerRace.Korazh, PlayerRace.Avalonian, PlayerRace.Briton, PlayerRace.HalfOgre, PlayerRace.Highlander, PlayerRace.Inconnu, PlayerRace.Saracen,
        };
    }

    [CharacterClass((int) eCharacterClass.Cabalist, "Cabalist", "Mage")]
    public class GaherisRacesCabalist : ClassCabalist
    {
        public override List<PlayerRace> EligibleRaces => new()
        {
            PlayerRace.Avalonian, PlayerRace.Briton, PlayerRace.HalfOgre, PlayerRace.Inconnu, PlayerRace.Saracen,
        };
    }

    [CharacterClass((int) eCharacterClass.Heretic, "Heretic", "Acolyte")]
    public class GaherisRacesHeretic : ClassHeretic
    {
        public override List<PlayerRace> EligibleRaces => new()
        {
            PlayerRace.Korazh, PlayerRace.Avalonian, PlayerRace.Briton, PlayerRace.Inconnu,
        };
    }

    [CharacterClass((int) eCharacterClass.MaulerAlb, "Mauler", "Fighter")]
    public class GaherisRacesMaulerAlb : ClassMaulerAlb
    {
        public override List<PlayerRace> EligibleRaces => new()
        {
            PlayerRace.Korazh, PlayerRace.Briton, PlayerRace.Inconnu,
        };
    }

    [CharacterClass((int) eCharacterClass.Mercenary, "Mercenary", "Fighter")]
    public class GaherisRacesMercenary : ClassMercenary
    {
        public override List<PlayerRace> EligibleRaces => new()
        {
            PlayerRace.Korazh, PlayerRace.Avalonian, PlayerRace.Briton, PlayerRace.HalfOgre, PlayerRace.Highlander, PlayerRace.Inconnu, PlayerRace.Saracen,
        };
    }

    [CharacterClass((int) eCharacterClass.Sorcerer, "Sorcerer", "Mage", "Sorceress")]
    public class GaherisRacesSorcerer : ClassSorcerer
    {
        public override List<PlayerRace> EligibleRaces => new()
        {
            PlayerRace.Avalonian, PlayerRace.Briton, PlayerRace.HalfOgre, PlayerRace.Inconnu, PlayerRace.Saracen,
        };
    }

    [CharacterClass((int) eCharacterClass.Theurgist, "Theurgist", "Elementalist")]
    public class GaherisRacesTheurgist : ClassTheurgist
    {
        public override List<PlayerRace> EligibleRaces => new()
        {
            PlayerRace.Avalonian, PlayerRace.Briton, PlayerRace.HalfOgre,
        };
    }

    [CharacterClass((int) eCharacterClass.Wizard, "Wizard", "Elementalist")]
    public class GaherisRacesWizard : ClassWizard
    {
        public override List<PlayerRace> EligibleRaces => new()
        {
            PlayerRace.Avalonian, PlayerRace.Briton, PlayerRace.HalfOgre,
        };
    }

    [CharacterClass((int) eCharacterClass.Bainshee, "Bainshee", "Magician")]
    public class GaherisRacesBainshee : ClassBainshee
    {
        public override List<PlayerRace> EligibleRaces => new()
        {
            PlayerRace.Celt, PlayerRace.Elf, PlayerRace.Lurikeen,
        };
    }

    [CharacterClass((int) eCharacterClass.Blademaster, "Blademaster", "Guardian")]
    public class GaherisRacesBlademaster : ClassBlademaster
    {
        public override List<PlayerRace> EligibleRaces => new()
        {
            PlayerRace.Celt, PlayerRace.Elf, PlayerRace.Firbolg, PlayerRace.Graoch, PlayerRace.Shar,
        };
    }

    [CharacterClass((int) eCharacterClass.Champion, "Champion", "Guardian")]
    public class GaherisRacesChampion : ClassChampion
    {
        public override List<PlayerRace> EligibleRaces => new()
        {
            PlayerRace.Celt, PlayerRace.Elf, PlayerRace.Lurikeen, PlayerRace.Shar,
        };
    }

    [CharacterClass((int) eCharacterClass.Hero, "Hero", "Guardian", "Heroine")]
    public class GaherisRacesHero : ClassHero
    {
        public override List<PlayerRace> EligibleRaces => new()
        {
            PlayerRace.Celt, PlayerRace.Firbolg, PlayerRace.Graoch, PlayerRace.Lurikeen, PlayerRace.Shar, PlayerRace.Sylvan,
        };
    }

    [CharacterClass((int) eCharacterClass.MaulerHib, "Mauler", "Guardian")]
    public class GaherisRacesMaulerHib : ClassMaulerHib
    {
        public override List<PlayerRace> EligibleRaces => new()
        {
            PlayerRace.Celt, PlayerRace.Graoch, PlayerRace.Lurikeen,
        };
    }

    [CharacterClass((int) eCharacterClass.Mentalist, "Mentalist", "Magician")]
    public class GaherisRacesMentalist : ClassMentalist
    {
        public override List<PlayerRace> EligibleRaces => new()
        {
            PlayerRace.Celt, PlayerRace.Elf, PlayerRace.Lurikeen, PlayerRace.Shar,
        };
    }

    [CharacterClass((int) eCharacterClass.Ranger, "Ranger", "Stalker")]
    public class GaherisRacesRanger : ClassRanger
    {
        public override List<PlayerRace> EligibleRaces => new()
        {
            PlayerRace.Celt, PlayerRace.Elf, PlayerRace.Lurikeen, PlayerRace.Shar,
        };
    }

    [CharacterClass((int) eCharacterClass.Vampiir, "Vampiir", "Stalker")]
    public class GaherisRacesVampiir : ClassVampiir
    {
        public override List<PlayerRace> EligibleRaces => new()
        {
            PlayerRace.Celt, PlayerRace.Lurikeen, PlayerRace.Shar,
        };
    }

    [CharacterClass((int) eCharacterClass.Warden, "Warden", "Naturalist")]
    public class GaherisRacesWarden : ClassWarden
    {
        public override List<PlayerRace> EligibleRaces => new()
        {
            PlayerRace.Celt, PlayerRace.Firbolg, PlayerRace.Graoch, PlayerRace.Sylvan,
        };
    }

    [CharacterClass((int) eCharacterClass.MaulerMid, "Mauler", "Viking")]
    public class GaherisRacesMaulerMid : ClassMaulerMid
    {
        public override List<PlayerRace> EligibleRaces => new()
        {
            PlayerRace.Kobold, PlayerRace.Deifrang, PlayerRace.Norseman,
        };
    }

    [CharacterClass((int) eCharacterClass.Valkyrie, "Valkyrie", "Viking")]
    public class GaherisRacesValkyrie : ClassValkyrie
    {
        public override List<PlayerRace> EligibleRaces => new()
        {
            PlayerRace.Dwarf, PlayerRace.Frostalf, PlayerRace.Norseman,
        };
    }

    [CharacterClass((int) eCharacterClass.Warlock, "Warlock", "Mystic")]
    public class GaherisRacesWarlock : ClassWarlock
    {
        public override List<PlayerRace> EligibleRaces => new()
        {
            PlayerRace.Frostalf, PlayerRace.Kobold, PlayerRace.Norseman,
        };
    }

}
