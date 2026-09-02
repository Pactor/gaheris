using System;
using System.Collections.Generic;
using DOL.Database;
using DOL.GS.Quests;

namespace DOL.GS
{
    /// <summary>
    /// The gap between DOLSharp and OpenDAoC, in one place.
    ///
    /// The artifact system was written against DOLSharp and OpenDAoC has moved
    /// on. Rather than edit several thousand lines of ported code -- which
    /// makes it impossible to diff against upstream later -- everything the
    /// port expects and this server no longer has is supplied here.
    ///
    /// Each one is a real difference, not a rename:
    /// </summary>
    public static class ArtifactCompat
    {
        /// <summary>
        /// DOLSharp had this on GamePlayer. It answers whether any version of
        /// an artifact exists that this class and realm could actually be
        /// given -- there is no point offering a caster a warrior's sword.
        /// </summary>
        public static bool CanReceiveArtifact(this GamePlayer player, string artifactID)
        {
            if (player == null || string.IsNullOrEmpty(artifactID))
                return false;

            Dictionary<string, DbItemTemplate> versions = ArtifactMgr.GetArtifactVersions(
                artifactID, (eCharacterClass) player.CharacterClass.ID, player.Realm);

            return versions != null && versions.Count > 0;
        }

        /// <summary>
        /// DOLSharp: CharacterClass.GetSalutation(Gender), which produced the
        /// gendered class name a scholar greets you by. OpenDAoC has no such
        /// method, so this falls back to the class name -- "well met,
        /// Armsman" rather than "well met, Armswoman".
        /// </summary>
        public static string Salutation(this GamePlayer player)
        {
            return player?.CharacterClass?.Name ?? "traveller";
        }

        /// <summary>
        /// DOLSharp exposed the quest collections as properties. OpenDAoC
        /// keeps them private behind lock objects and hands out copies.
        /// </summary>
        public static List<AbstractQuest> QuestList(this GamePlayer player)
        {
            return player != null ? player.GetActiveQuests() : new List<AbstractQuest>();
        }

        public static List<AbstractQuest> QuestListFinished(this GamePlayer player)
        {
            return player != null ? player.GetFinishedQuests() : new List<AbstractQuest>();
        }

        /// <summary>
        /// DOLSharp had Spell.Delve, which appended a spell's description to
        /// an item's delve panel. OpenDAoC builds delve text elsewhere, so
        /// this writes the one line the artifact panel actually wants.
        /// </summary>
        public static void Delve(this Spell spell, List<string> delve)
        {
            if (spell == null || delve == null)
                return;

            delve.Add("Level Requirement:");
            delve.Add("- " + spell.Level + " Level");

            if (!string.IsNullOrEmpty(spell.Description))
                delve.Add(spell.Description);
        }
    }
}
