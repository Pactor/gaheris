using DOL.GS.ServerProperties;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// Switches for the parts of this that not every server wants.
    ///
    /// These are real server properties, so they show up in /serverproperties
    /// alongside everything else and are changed the same way -- no editing a
    /// script and restarting to turn a feature on.
    /// </summary>
    public static class GaherisSettings
    {
        /// <summary>
        /// Whether hired companions draw on Atlantis -- the Master Level lines.
        ///
        /// OFF by default, and deliberately so. Trials of Atlantis is content a
        /// server chooses to run; on one that never opened it, a hire casting
        /// Stormlord is not a bonus, it is a bug the operator cannot explain.
        /// Turning it on gives each hire the Master Level path its role would
        /// actually have walked -- a healer Perfecter, a pet class Convoker, a
        /// caster Stormlord -- and nothing else changes.
        ///
        /// Artifacts need no switch: they are items, so a hire wears one the
        /// moment you hand it over, exactly like any other piece of gear.
        ///
        ///     /serverproperty gaheris_atlantis true
        /// </summary>
        [ServerProperty("gaheris", "gaheris_atlantis",
            "Do hired companions draw on Atlantis (Master Level) lines?", false)]
        public static bool ATLANTIS;

        /// <summary>
        /// Log every buff a hire casts: who, at whom, which spell, which slot.
        ///
        /// A diagnostic, off by default and meant to come out again. It is
        /// here because a Cleric and a Shaman kept buffing over each other
        /// after the fix that was supposed to stop them, and reasoning about
        /// which pair of spells is fighting has already produced one wrong
        /// answer. This produces the actual pair.
        ///
        ///     /serverproperty gaheris_log_buffs true
        /// </summary>
        [ServerProperty("gaheris", "gaheris_log_buffs",
            "Log every buff a hired companion casts, for diagnosing buff loops.", false)]
        public static bool LOG_BUFFS;
    }
}
