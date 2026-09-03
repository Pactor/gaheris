-- Turn /level back on, at 20.
--
-- slash_level_target was 0, which is how the core spells "disabled", so the
-- command existed and did nothing.
--
-- 20 is the classic value: far enough up that a new character skips the part
-- everybody has already played, and far short of anywhere the group content
-- starts. slash_level_requirement stays at 50, so it is a reward for having
-- taken one character the whole way rather than a free start for anybody.
--
-- allow_cata_slash_level is turned on with it. Leaving it off would let every
-- class but Heretic, Valkyrie, Bainshee, Vampiir, Warlock and Mauler use the
-- command, which is a rule nobody would guess from the outside and which reads
-- as the command being broken for those classes.
UPDATE serverproperty SET Value = '20'   WHERE `Key` = 'slash_level_target';
UPDATE serverproperty SET Value = 'True' WHERE `Key` = 'allow_cata_slash_level';
