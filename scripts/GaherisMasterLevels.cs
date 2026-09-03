using System;
using System.Collections.Generic;
using DOL.AI.Brain;
using DOL.Events;
using DOL.GS.PacketHandler;
using DOL.GS.ServerProperties;

namespace DOL.GS.Scripts
{
    /// <summary>
    /// Master Levels, actually reachable.
    ///
    /// OpenDAoC ships the whole apparatus and none of the content. There is an
    /// MLGranted flag, an MLLevel, an MLExperience counter, a ten-entry XP
    /// curve, a Master Level window, ML step tracking, and the ML
    /// specialisations themselves -- and in the entire codebase exactly one
    /// thing sets MLGranted and exactly one thing adds MLExperience, and both
    /// of them are the GM command. The trials were never implemented.
    ///
    /// The Arbiter is the clearest symptom. On live you spoke to him once and
    /// were on the path. Here, DOL.GS.Arbiter inherits Researcher, which has
    /// no Interact of its own, and Arbiter's own Interact does nothing but
    /// print two lines of flavour text. He cannot start anybody, and every
    /// scholar downstream of him is waiting on a flag he never sets. Head
    /// Scholar Mabyle does not answer at all for the same reason one step
    /// further along: DOL.GS.HeadScholar is an empty subclass of Researcher.
    ///
    /// So this supplies the two missing halves. The Arbiter enrols you, and
    /// your whole group with you, because on a co-operative server a raid
    /// entrance that admits one person at a time is not an entrance. And ML
    /// experience comes from killing Atlantis-grade things, since the trials
    /// that would otherwise award it do not exist.
    /// </summary>
    public class GaherisArbiter : Arbiter
    {
        /// <summary>
        /// How far a group member can stand and still be enrolled. Far enough
        /// that nobody has to shuffle into a doorway, short enough that it is
        /// still the group that came here together.
        /// </summary>
        private const int WITH_YOU = 2000;

        /// <summary>
        /// The MLLine value that means no discipline chosen.
        ///
        /// MLLine is an index and every value from 0 up names a real
        /// discipline, so there is no natural way to say "none". Past the end
        /// of the list is unambiguous: nothing matches it, so the player holds
        /// no Master Level spells and the Arbiter offers the choice again.
        /// </summary>
        public const byte NO_PATH = 255;

        public override bool Interact(GamePlayer player)
        {
            // The welcome is for people who have not heard it. Arbiter.Interact
            // puts two popup windows on the screen every single time it runs,
            // so calling it unconditionally means somebody already on the path
            // has to sit through the introduction again before reaching the
            // thing they came back for. Once enrolled, go straight to the
            // disciplines.
            bool newcomer = !(player.MLGranted && player.MLLevel >= 1);

            if (newcomer)
            {
                if (!base.Interact(player))
                    return false;
            }
            else if (!Greet(player))
                return false;

            int enrolled = 0;

            if (Enrol(player))
                enrolled++;

            if (player.Group != null)
            {
                foreach (GamePlayer mate in player.Group.GetPlayersInTheGroup())
                {
                    if (mate == null || mate == player)
                        continue;

                    if (mate.ObjectState != GameObject.eObjectState.Active)
                        continue;

                    if (!mate.IsWithinRadius(this, WITH_YOU))
                        continue;

                    if (Enrol(mate))
                        enrolled++;
                }
            }

            // One popup, always.
            //
            // Three separate SayTo calls in a single interaction is three popup
            // windows in the same tick, and the client shows one of them. That
            // is why the disciplines stopped appearing for anybody already
            // enrolled: the progress line was landing on top of the list. The
            // whole conversation goes out as one message now.
            string text = string.Empty;

            if (enrolled > 1)
                text += "Your company has begun the trials with you.\n\n";

            // Speaking to him re-applies what you hold, whatever put it there.
            //
            // Demyphon does the advancing -- that is DOLSharp's arrangement and
            // it is two lines in his ReceiveItem -- but coming here afterwards
            // is how a lot of people remember it, and a rank whose spells never
            // arrived is the exact failure this whole thing was reported as. A
            // refresh costs nothing and closes that gap from either direction.
            if (player.MLGranted && player.MLLevel > 0)
                Announce(player);

            text += Promote(player) ?? Standing(player);
            text += PathList(player);

            SayTo(player, eChatLoc.CL_PopupWindow, text);
            return true;
        }

        /// <summary>
        /// Everything GameObject.Interact enforces, and none of the talking.
        ///
        /// C# has no way to reach a grandparent's implementation, so a subclass
        /// that wants GameNPC's interact contract without Arbiter's two popup
        /// windows has to keep the contract itself: the distance check that
        /// stops you conversing from across the zone, and the notifications
        /// quests and scripts listen for.
        /// </summary>
        private bool Greet(GamePlayer player)
        {
            if (player.Client.Account.PrivLevel == 1 &&
                !IsWithinRadius(player, InteractDistance))
            {
                player.Out.SendMessage("You are too far away to speak to " +
                                       GetName(0, true) + ".",
                                       eChatType.CT_System, eChatLoc.CL_SystemWindow);
                Notify(GameObjectEvent.InteractFailed, this, new InteractEventArgs(player));
                return false;
            }

            Notify(GameObjectEvent.Interact, this, new InteractEventArgs(player));
            player.Notify(GameObjectEvent.InteractWith, player, new InteractWithEventArgs(this));

            TurnTo(player, 5000);
            return true;
        }

        /// <summary>
        /// Raise the player one rank, if the next one is paid for.
        ///
        /// One per conversation, deliberately. A Master Level is taught, and
        /// being taught five of them is five lessons -- which is what buying
        /// five credits and speaking to him five times means. Handing over
        /// every rank at once on a single right-click made the credits feel
        /// like they had done nothing.
        ///
        /// Returns what to say, or null if there was nothing to give.
        /// </summary>
        private string Promote(GamePlayer player)
        {
            if (!player.MLGranted || player.MLLevel >= GamePlayer.ML_MAX_LEVEL)
                return null;

            long needed = player.GetMLExperienceForLevel(player.MLLevel + 1);

            if (needed <= 0 || player.MLExperience < needed)
                return null;

            player.MLExperience -= needed;
            player.MLLevel++;

            if (player.MLLevel >= GamePlayer.ML_MAX_LEVEL)
                player.MLExperience = 0;

            player.SaveIntoDatabase();

            player.Out.SendMessage("You have reached Master Level " + player.MLLevel + ".",
                                   eChatType.CT_Important, eChatLoc.CL_SystemWindow);

            Announce(player);

            string more = player.MLLevel < GamePlayer.ML_MAX_LEVEL &&
                          player.MLExperience >= player.GetMLExperienceForLevel(player.MLLevel + 1)
                ? " You have earned another. Speak again when you are ready for it."
                : string.Empty;

            return "You are Master Level " + player.MLLevel + " and what it teaches is yours." +
                   more + "\n" + Learned(player) + "\n";
        }

        /// <summary>
        /// Where the player stands when there is nothing to hand over.
        ///
        /// Refusing in silence is what this did before, and from the other side
        /// of the screen a silent refusal and a broken NPC look identical. He
        /// has the numbers, so he says them.
        /// </summary>
        private string Standing(GamePlayer player)
        {
            if (!player.MLGranted)
                return string.Empty;

            if (player.MLLevel >= GamePlayer.ML_MAX_LEVEL)
                return "There is nothing further I can teach you. You are Master Level " +
                       GamePlayer.ML_MAX_LEVEL + ".\n" + Learned(player) + "\n";

            long needed = player.GetMLExperienceForLevel(player.MLLevel + 1);
            long have = player.MLExperience;
            int percent = needed > 0 ? (int) (100L * have / needed) : 0;

            return "You are Master Level " + player.MLLevel + ". The next asks " +
                   needed + " and you have " + have + " -- " + percent + " in the " +
                   "hundred. Earn it against the creatures of this place, nothing " +
                   "under the forty-fifth season counting, or buy the credit from " +
                   "Demyphon and bring it back to me.\n" + Learned(player) + "\n";
        }

        /// <summary>
        /// What the player actually holds, said plainly.
        ///
        /// Worth its own line because a rank and the spells behind it are not
        /// the same thing, and when they disagree this is the only way to see
        /// it from inside the game.
        /// </summary>
        private static string Learned(GamePlayer player)
        {
            string path = PathOf(player);

            if (path == null)
                return "You have taken no discipline yet, so there is nothing to teach you.";

            List<Spell> known = new();

            foreach (Spell spell in SkillBase.GetSpellList(path))
            {
                if (spell != null && spell.Level <= player.MLLevel)
                    known.Add(spell);
            }

            if (known.Count == 0)
                return "Of the " + path + " you hold nothing yet; its first art comes higher up.";

            string text = "Of the " + path + " you hold " + known.Count + ":";

            foreach (Spell spell in known)
                text += "\n    " + spell.Name + "  (Master Level " + spell.Level + ")";

            return text;
        }

        /// <summary>
        /// The disciplines -- offered only while there is a choice to make.
        ///
        /// DOLSharp puts the choice behind "MLGranted && MLLevel == 0" and
        /// never raises it again; changing path afterwards costs a Star of
        /// Destiny, which is Demyphon's business. Listing all eight on every
        /// visit to somebody who settled the question long ago is noise on top
        /// of the thing they actually came for.
        /// </summary>
        private string PathList(GamePlayer player)
        {
            // Offered while there is a choice to make, and only then.
            //
            // Two ways to have one. Master Level 0 is DOLSharp's: on the path,
            // none of it walked, discipline still open. The other is a Star of
            // Destiny, which sets MLLine past the end of the list -- so PathOf
            // finds nothing and the choice is open again at whatever rank the
            // player has reached, which is the entire point of buying one.
            if (!player.MLGranted)
                return string.Empty;

            if (player.MLLevel > 0 && PathOf(player) != null)
                return string.Empty;

            string text = "\nName a discipline and its arts open to you as you rise:\n";

            foreach ((string key, string what) in Paths)
                text += "  [" + key + "] -- " + what + "\n";

            return text;
        }

        /// <summary>
        /// The eight Master Level paths, and what each one is for.
        ///
        /// Not class restricted, which is how it worked -- any class may walk
        /// any of them, some merely suit better.
        /// </summary>
        private static readonly (string Key, string What)[] Paths =
        {
            ("Banelord",     "curses, snares and the unmaking of a foe's defences"),
            ("Battlemaster", "the close fight: footwork, guard and the killing blow"),
            ("Convoker",     "summoning -- wards, weapons and servants called from nothing"),
            ("Perfecter",    "mending: healing, cures and calling the fallen back"),
            ("Sojourner",    "movement, reach and passage others cannot take"),
            ("Spymaster",    "stealth, poison and the knife nobody sees"),
            ("Stormlord",    "the sky turned against them -- storms, roots and ruin"),
            ("Warlord",      "holding a line, and keeping those behind it alive"),
        };

        public override bool WhisperReceive(GameLiving source, string text)
        {
            // Ours first, then the base class. Arbiter.WhisperReceive returns
            // false on every branch it handles, so calling it first would eat
            // the answer before we ever saw it.
            if (source is GamePlayer player &&
                player.IsWithinRadius(this, WorldMgr.INTERACT_DISTANCE) &&
                Choose(player, (text ?? string.Empty).Trim()))
                return true;

            return base.WhisperReceive(source, text);
        }

        /// <summary>
        /// Take up a path. True if the whisper was a path name.
        ///
        /// MLLine is a position, not a name: RefreshSpecDependantSkills counts
        /// Master Level entries as it walks the career and keeps the one whose
        /// count matches. The career is a dictionary, so the order is whatever
        /// it yields -- which means the only safe way to set MLLine is to walk
        /// it exactly as that loop does and take the index we land on. Working
        /// the number out from the order of the eight names above would sooner
        /// or later hand somebody the wrong discipline.
        /// </summary>
        private bool Choose(GamePlayer player, string said)
        {
            string wanted = null;

            foreach ((string key, string _) in Paths)
            {
                if (key.Equals(said, StringComparison.OrdinalIgnoreCase))
                {
                    wanted = key;
                    break;
                }
            }

            if (wanted == null)
                return false;

            if (!player.MLGranted)
            {
                SayTo(player, eChatLoc.CL_PopupWindow,
                      "Begin the trials first. A discipline is no use to " +
                      "somebody with no standing to practise it.");
                return true;
            }

            byte index = 0;
            bool found = false;

            foreach (KeyValuePair<Specialization, int> entry in
                     SkillBase.GetSpecializationCareer(player.CharacterClass.ID))
            {
                if (entry.Key is not IMasterLevelsSpecialization)
                    continue;

                if (entry.Key.KeyName == wanted)
                {
                    found = true;
                    break;
                }

                index++;
            }

            if (!found)
            {
                SayTo(player, eChatLoc.CL_PopupWindow,
                      "That discipline is closed to you.");
                return true;
            }

            if (player.MLLine == index && PathOf(player) == wanted)
            {
                SayTo(player, eChatLoc.CL_PopupWindow,
                      "You already walk that path.");
                return true;
            }

            player.MLLine = index;

            // The choice confers the first rank, as it does in DOLSharp:
            //
            //     player.MLLine = (byte)index;
            //     player.MLLevel = 1;
            //     player.RefreshSpecDependantSkills(true);
            if (player.MLLevel < 1)
                player.MLLevel = 1;

            player.SaveIntoDatabase();
            player.RefreshSpecDependantSkills(true);

            player.Out.SendMessage("You have taken up the path of the " + wanted + ".",
                                   eChatType.CT_Important, eChatLoc.CL_SystemWindow);

            Announce(player);

            SayTo(player, eChatLoc.CL_PopupWindow,
                  "So be it. You are of the " + wanted + " now.\n" + Learned(player));
            return true;
        }

        /// <summary>Which path a player currently walks, or null.</summary>
        public static string PathOf(GamePlayer player)
        {
            if (player == null || !player.MLGranted)
                return null;

            byte index = 0;

            foreach (KeyValuePair<Specialization, int> entry in
                     SkillBase.GetSpecializationCareer(player.CharacterClass.ID))
            {
                if (entry.Key is not IMasterLevelsSpecialization)
                    continue;

                if (index == player.MLLine)
                    return entry.Key.KeyName;

                index++;
            }

            return null;
        }

        /// <summary>Puts one person on the path. True if this changed anything.</summary>
        private bool Enrol(GamePlayer player)
        {
            if (player.MLGranted)
                return false;

            // Enrolment sets the flag and nothing else. Master Level 1 arrives
            // with the choice of discipline, not before it -- which is how
            // DOLSharp does it, and the reason is that MLLevel 0 IS the "no
            // discipline chosen yet" state. MLLine defaults to 0, so there is
            // no value of it that means unchosen; the rank is what carries
            // that. Granting Master Level 1 at enrolment quietly locked every
            // player into whichever discipline sat first in their career.
            player.MLGranted = true;
            player.SaveIntoDatabase();

            player.Out.SendMessage(
                "You have begun the trials of Atlantis. Choose your discipline.",
                eChatType.CT_Important, eChatLoc.CL_SystemWindow);

            player.Out.SendMasterLevelWindow((byte) player.MLLevel);
            return true;
        }

        /// <summary>
        /// Tell the client what it does not otherwise get told.
        ///
        /// Nothing in OpenDAoC sends the Master Level window outside a dialog
        /// response, the GM command and step completion -- so a client that has
        /// just been enrolled, or that has simply logged in, has never been
        /// told the player has Master Levels and will not offer the Master
        /// Level experience bar.
        /// </summary>
        public static void Announce(GamePlayer player)
        {
            if (player?.Out == null || !player.MLGranted)
                return;

            player.RefreshSpecDependantSkills(false);

            // Push the skill list, not just the player.
            //
            // RefreshSpecDependantSkills changes what the server thinks you
            // know; SendUpdatePlayer does not carry any of it. Without this the
            // new Master Level spells were genuinely granted and genuinely
            // invisible -- the Arbiter would name them and the spell window
            // would not show them until the next login, which is how the
            // trainer does it too:
            //
            //     player.Out.SendUpdatePlayerSkills(true);   GameTrainer.cs:195
            player.Out.SendUpdatePlayerSkills(true);
            player.Out.SendUpdatePlayer();
            player.Out.SendUpdatePoints();
            player.Out.SendMasterLevelWindow((byte) player.MLLevel);

            // The company walks the Master Levels with its employer. Learn()
            // reads his MLLevel, so calling it here means a hire picks up the
            // next path spell the moment he does -- on enrolment, on taking a
            // discipline, on being granted a level, and on logging in.
            foreach (GameMercenary merc in MercenaryManager.GetCompany(player))
                merc.Learn();
        }
    }

    /// <summary>
    /// Sends the Master Level window to anyone already on the path as they
    /// enter the world, so the client knows before they ask.
    /// </summary>
    public static class MasterLevelLogin
    {
        [ScriptLoadedEvent]
        public static void OnScriptLoaded(DOLEvent e, object sender, EventArgs args)
        {
            GameEventMgr.AddHandler(GamePlayerEvent.GameEntered, new DOLEventHandler(Entered));
        }

        [ScriptUnloadedEvent]
        public static void OnScriptUnloaded(DOLEvent e, object sender, EventArgs args)
        {
            GameEventMgr.RemoveHandler(GamePlayerEvent.GameEntered, new DOLEventHandler(Entered));
        }

        private static void Entered(DOLEvent e, object sender, EventArgs args)
        {
            if (sender is GamePlayer player && player.MLGranted)
                GaherisArbiter.Announce(player);
        }
    }

    /// <summary>
    /// Where Master Level experience comes from.
    ///
    /// Nothing in OpenDAoC awards it, so on the Dying event -- the same signal
    /// artifacts level from, raised by GameLiving on every death and carrying
    /// the list of players who earned the kill -- credit everyone on the path.
    ///
    /// Scaled by the level of the thing killed rather than its raw experience
    /// value. A level 50 mob is worth hundreds of thousands of experience and
    /// a Master Level costs 32,000, so paying out raw would hand somebody ML10
    /// for a single kill.
    /// </summary>
    public static class MasterLevelExperience
    {
        /// <summary>
        /// Below this, a kill is not Atlantis-grade and pays nothing. Master
        /// Levels should not be reachable by clearing a low-level camp.
        /// </summary>
        private const int WORTHY = 45;

        [ServerProperty("gaheris", "gaheris_ml_xp_per_level",
            "Master Level experience earned per level of the creature killed. " +
            "A Master Level costs 32,000, so 10 is roughly 53 kills of a level " +
            "60 creature per Master Level. 0 turns Master Level progress off.", 10)]
        public static int ML_XP_PER_LEVEL;

        [ScriptLoadedEvent]
        public static void OnScriptLoaded(DOLEvent e, object sender, EventArgs args)
        {
            GameEventMgr.AddHandler(GameLivingEvent.Dying, new DOLEventHandler(Died));
        }

        [ScriptUnloadedEvent]
        public static void OnScriptUnloaded(DOLEvent e, object sender, EventArgs args)
        {
            GameEventMgr.RemoveHandler(GameLivingEvent.Dying, new DOLEventHandler(Died));
        }

        private static void Died(DOLEvent e, object sender, EventArgs args)
        {
            try
            {
                if (ML_XP_PER_LEVEL <= 0)
                    return;

                if (sender is not GameNPC dead || args is not DyingEventArgs death)
                    return;

                // Nothing is owed for killing something's summoned help.
                if (dead.Brain is IControlledBrain || dead is GameMercenary)
                    return;

                if (dead.Level < WORTHY)
                    return;

                long earned = dead.Level * ML_XP_PER_LEVEL;

                if (earned <= 0)
                    return;

                foreach (GamePlayer player in Earners(death))
                    Award(player, earned);
            }
            catch (Exception)
            {
                // A Master Level is never worth losing a kill over.
            }
        }

        /// <summary>
        /// Everyone this kill counts for. PlayerKillers is the list the core
        /// builds for experience; where it is absent -- a kill finished by a
        /// hired companion, which is not a pet and so credits nobody --
        /// GaherisLoot resolves the employer, the same way it does for loot.
        /// </summary>
        private static IEnumerable<GamePlayer> Earners(DyingEventArgs death)
        {
            if (death.PlayerKillers != null && death.PlayerKillers.Count > 0)
            {
                foreach (GamePlayer player in death.PlayerKillers)
                {
                    if (player != null && player.ObjectState == GameObject.eObjectState.Active)
                        yield return player;
                }

                yield break;
            }

            if (GaherisLoot.Credit(death.Killer) is GamePlayer credited &&
                credited.ObjectState == GameObject.eObjectState.Active)
            {
                yield return credited;
            }
        }

        private static void Award(GamePlayer player, long earned)
        {
            if (!player.MLGranted || player.MLLevel >= GamePlayer.ML_MAX_LEVEL)
                return;

            long before = player.MLExperience;
            long needed = player.GetMLExperienceForLevel(player.MLLevel + 1);

            player.MLExperience += earned;

            // Deliberately does not promote. Experience is earned in the field
            // and the rank is conferred by the Arbiter, so the bar fills here
            // and fills no further until he hands the level over. It is also
            // how the player finds out there is a reason to go back to him.
            if (needed > 0 && before < needed && player.MLExperience >= needed)
            {
                player.MLExperience = needed;
                player.SaveIntoDatabase();

                player.Out.SendMessage(
                    "You have learned all you can alone. Return to the Arbiter " +
                    "to be raised to Master Level " + (player.MLLevel + 1) + ".",
                    eChatType.CT_Important, eChatLoc.CL_SystemWindow);

                player.Out.SendMasterLevelWindow((byte) player.MLLevel);
            }
        }
    }
}
