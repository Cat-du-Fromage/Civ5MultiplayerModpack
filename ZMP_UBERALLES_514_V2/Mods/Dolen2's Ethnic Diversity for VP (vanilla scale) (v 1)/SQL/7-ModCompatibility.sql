/*

	Ethnic Diversity
	Mod Compatibility file
	by Nutty (2016)

	Adjust size, formation, number of figures for various mods

*/
--UPDATE ArtDefine_UnitMemberInfos SET Scale = ? WHERE Type = '';
--UPDATE ArtDefine_UnitInfoMemberInfos SET NumMembers = ? WHERE UnitMemberInfoType = '';
--UPDATE ArtDefine_UnitMemberInfos SET Model = '' WHERE Type = '';
--UPDATE ArtDefine_UnitInfos SET Formation = '' WHERE Type = '';

UPDATE ArtDefine_UnitMemberInfos SET Model = 'battle_galley.fxsxml' WHERE Type = 'ART_DEF_UNIT_MEMBER_U_BYZANTIUM_DROMON';
UPDATE ArtDefine_UnitMemberInfos SET Scale = 0.09 WHERE Type = 'ART_DEF_UNIT_MEMBER_U_BYZANTIUM_DROMON';

UPDATE ArtDefine_UnitMemberInfos SET Model = 'gurkha.fxsxml' WHERE Type = 'ART_DEF_UNIT_MERC_GUERILLA';
UPDATE ArtDefine_UnitMemberInfos SET Scale = 0.12 WHERE Type = 'ART_DEF_UNIT_MERC_GUERILLA';

UPDATE ArtDefine_UnitMemberInfos SET Model = 'mod_spanish_galleon.fxsxml' WHERE Type = 'ART_DEF_UNIT_MEMBER_SPAIN_ARMADA';
UPDATE ArtDefine_UnitMemberInfos SET Scale = 0.18 WHERE Type = 'ART_DEF_UNIT_MEMBER_SPAIN_ARMADA';

-- ============================================================================
-- Enlightenment Era / Vox Populi Explorer compatibility
-- ============================================================================
-- Current Enlightenment Era uses UNIT_EE_ADVENTURER for the gameplay unit,
-- while its model intentionally retains the legacy ArtDefine name
-- ART_DEF_UNIT_EE_EXPLORER.
--
-- These UPDATEs are harmless when the corresponding unit does not exist.
-- The EXISTS checks prevent assigning an ArtDefine that is absent from the DB.

UPDATE Units
SET UnitArtInfo = 'ART_DEF_UNIT_EE_EXPLORER'
WHERE Type = 'UNIT_EE_ADVENTURER'
  AND EXISTS (
      SELECT 1
      FROM ArtDefine_UnitInfos
      WHERE Type = 'ART_DEF_UNIT_EE_EXPLORER'
  );

-- ============================================================================
-- Vox Populi Explorer compatibility (updated VP naming)
-- ============================================================================
-- VP renamed its Explorer art ART_DEF_UNIT_EXPLORER_CBP -> ART_DEF_UNIT_VP_EXPLORER.
-- Ethnic Diversity still points UNIT_EXPLORER at ART_DEF_UNIT_EXPLORER_CBP, whose
-- ArtDefine_UnitInfos row is therefore never created -> the unit art is missing and
-- the engine falls back to the Spearman model. Recreate that art define from the
-- current VP explorer art (falling back to the base-game explorer) and relink its
-- bandeirante members. Every statement no-ops cleanly if the sources are absent.

-- 1) Register ART_DEF_UNIT_EXPLORER_CBP by copying the shell of the current VP explorer.
INSERT OR REPLACE INTO ArtDefine_UnitInfos
    (Type, DamageStates, Formation, UnitFlagAtlas, UnitFlagIconOffset, IconAtlas, PortraitIndex)
SELECT 'ART_DEF_UNIT_EXPLORER_CBP', DamageStates, Formation, UnitFlagAtlas, UnitFlagIconOffset, IconAtlas, PortraitIndex
FROM ArtDefine_UnitInfos
WHERE Type IN ('ART_DEF_UNIT_VP_EXPLORER', 'ART_DEF_UNIT_EXPLORER')
ORDER BY (Type = 'ART_DEF_UNIT_VP_EXPLORER') DESC
LIMIT 1;

-- 2) Give it a strategic-view icon.
INSERT OR REPLACE INTO ArtDefine_StrategicView (StrategicViewType, TileType, Asset)
SELECT 'ART_DEF_UNIT_EXPLORER_CBP', TileType, Asset
FROM ArtDefine_StrategicView
WHERE StrategicViewType IN ('ART_DEF_UNIT_VP_EXPLORER', 'ART_DEF_UNIT_EXPLORER')
ORDER BY (StrategicViewType = 'ART_DEF_UNIT_VP_EXPLORER') DESC
LIMIT 1;

-- 3) Rebuild its member links cleanly (dedupe) from the bandeirante members that exist.
DELETE FROM ArtDefine_UnitInfoMemberInfos WHERE UnitInfoType = 'ART_DEF_UNIT_EXPLORER_CBP';
INSERT INTO ArtDefine_UnitInfoMemberInfos (UnitInfoType, UnitMemberInfoType, NumMembers)
SELECT 'ART_DEF_UNIT_EXPLORER_CBP', Type, 1
FROM ArtDefine_UnitMemberInfos
WHERE Type IN ('ART_DEF_UNIT_MEMBER_BANDEIRANTE',
               'ART_DEF_UNIT_MEMBER_BANDEIRANTE_2',
               'ART_DEF_UNIT_MEMBER_BANDEIRANTE_3');

-- 4) Point the VP Explorer at the (now valid) art define.
UPDATE Units SET UnitArtInfo = 'ART_DEF_UNIT_EXPLORER_CBP' WHERE Type = 'UNIT_EXPLORER';
