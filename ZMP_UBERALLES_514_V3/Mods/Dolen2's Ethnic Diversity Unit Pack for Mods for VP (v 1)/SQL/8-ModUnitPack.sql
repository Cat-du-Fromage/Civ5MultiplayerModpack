/*

	Ethnic Diversity
	Mod Compatibility file
	by Nutty (2016)

	Adjust size, formation, number of figures for various mods

*/

--Prehistoric Era
UPDATE Units SET UnitArtInfo = UnitArtInfo || '_ED' WHERE Type IN 
	('UNIT_AUTOCHTHON', 'UNIT_HUNTER', 'UNIT_SAVAGE');
UPDATE Units SET UnitArtInfo = 'ART_DEF_UNIT_CAVEMAN_ED' WHERE Type = 'UNIT_CAVEMAN';

--Renaissance Era Revised
UPDATE Units SET UnitArtInfo = 'ART_DEF_UNIT_2HANDER_ED' WHERE Type = 'UNIT_2HANDER';

--Enlightenment Era
UPDATE Units SET UnitArtInfo = UnitArtInfo || '_ED' WHERE Type IN 
	('UNIT_EE_CARRACK', 'UNIT_EE_CUIRASSIER', 'UNIT_EE_LINE_INFANTRY', 'UNIT_EE_SKIRMISHER'); --'UNIT_EE_FIELD_GUN'
UPDATE Units SET UnitArtInfo = 'ART_DEF_UNIT_EE_GALLEON_ED' WHERE Type = 'UNIT_EE_GALLEON';

-- ----------------------------------------------------------------------------
-- Enlightenment Era Explorer compatibility (updated EE naming)
-- ----------------------------------------------------------------------------
-- The updated "(overhaul) Enlightenment Era for VP" renamed the recon unit
-- UNIT_EE_EXPLORER -> UNIT_EE_ADVENTURER, while KEEPING the old graphic name
-- ART_DEF_UNIT_EE_EXPLORER (conquistador_musket models). When this "for Mods"
-- pack is active the explorer ended up showing the Spearman model, so we
-- explicitly re-assert a valid explorer art here. This pack loads last, so it
-- has the final word. Every statement is guarded / idempotent and no-ops when
-- Enlightenment Era is not enabled.

-- 1) Point the gameplay unit at the conquistador art define.
UPDATE Units SET UnitArtInfo = 'ART_DEF_UNIT_EE_EXPLORER'
WHERE Type = 'UNIT_EE_ADVENTURER'
  AND EXISTS (SELECT 1 FROM ArtDefine_UnitInfos WHERE Type = 'ART_DEF_UNIT_EE_EXPLORER');

-- 1b) There are no per-civ ethnic variants of the EE explorer, so ethnic
--     cultural variation only risks a bad fallback (the Spearman). Force the
--     base conquistador art for this one unit.
UPDATE Units SET UnitArtInfoCulturalVariation = 0 WHERE Type = 'UNIT_EE_ADVENTURER';

-- 2) Defensive: keep the four explorer members on the conquistador models
--    (no-ops if the member rows are absent). Guards against any prior mod
--    overwriting the Model column.
UPDATE ArtDefine_UnitMemberInfos SET Model = 'conquistador_musket_1.fxsxml' WHERE Type = 'ART_DEF_UNIT_MEMBER_EE_EXPLORER_1';
UPDATE ArtDefine_UnitMemberInfos SET Model = 'conquistador_musket_2.fxsxml' WHERE Type = 'ART_DEF_UNIT_MEMBER_EE_EXPLORER_2';
UPDATE ArtDefine_UnitMemberInfos SET Model = 'conquistador_musket_3.fxsxml' WHERE Type = 'ART_DEF_UNIT_MEMBER_EE_EXPLORER_3';
UPDATE ArtDefine_UnitMemberInfos SET Model = 'conquistador_musket_4.fxsxml' WHERE Type = 'ART_DEF_UNIT_MEMBER_EE_EXPLORER_4';

-- 3) Rebuild the unit->member links cleanly so the explorer can never be left
--    with duplicate or missing members (the missing-member state is what fell
--    back to the Spearman model). Only links to members that actually exist.
DELETE FROM ArtDefine_UnitInfoMemberInfos WHERE UnitInfoType = 'ART_DEF_UNIT_EE_EXPLORER';
INSERT INTO ArtDefine_UnitInfoMemberInfos (UnitInfoType, UnitMemberInfoType, NumMembers)
SELECT 'ART_DEF_UNIT_EE_EXPLORER', Type,
       CASE Type
           WHEN 'ART_DEF_UNIT_MEMBER_EE_EXPLORER_1' THEN 2
           WHEN 'ART_DEF_UNIT_MEMBER_EE_EXPLORER_2' THEN 1
           WHEN 'ART_DEF_UNIT_MEMBER_EE_EXPLORER_3' THEN 2
           WHEN 'ART_DEF_UNIT_MEMBER_EE_EXPLORER_4' THEN 1
       END
FROM ArtDefine_UnitMemberInfos
WHERE Type IN ('ART_DEF_UNIT_MEMBER_EE_EXPLORER_1', 'ART_DEF_UNIT_MEMBER_EE_EXPLORER_2',
               'ART_DEF_UNIT_MEMBER_EE_EXPLORER_3', 'ART_DEF_UNIT_MEMBER_EE_EXPLORER_4');

--Future Worlds
UPDATE Units SET UnitArtInfo = UnitArtInfo || '_ED' WHERE Type IN 
	('UNIT_FUTURE_SOLDIER', 'UNIT_FW_HOVERTANK', 
	'UNIT_FW_BIOTROOPER', 'UNIT_FW_DRONE_FIGHTER_2', 'UNIT_FW_HYBRID_DRONE', 
	'UNIT_FW_NANOHIVE', 'UNIT_FW_RAILGUN_TANK', 'UNIT_FW_SUPERCARRIER', 'UNIT_FW_VERTOL');

--Vox Populi
UPDATE Units SET UnitArtInfo = UnitArtInfo || '_ED' WHERE Type = 'UNIT_ARMORED_CAR';
	--('UNIT_ARMORED_CAR', 'UNIT_COLONIST', 'UNIT_PIONEER', 'UNIT_ZEPPELIN');
UPDATE Units SET UnitArtInfo = 'ART_DEF_UNIT_EXPLORER_CBP' WHERE Type = 'UNIT_EXPLORER' AND MoveRate = 'BIPED';
