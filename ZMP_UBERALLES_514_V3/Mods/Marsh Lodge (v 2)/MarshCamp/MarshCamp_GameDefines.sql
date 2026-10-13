--==========================================================================================================================
-- BUILDS
--==========================================================================================================================
INSERT OR REPLACE INTO Builds		
		(Type,				ShowInPedia, ShowInTechTree, ImprovementType, 			Description, 				Help, Recommendation, Time, EntityEvent, OrderPriority, HotKey, IconIndex, 	IconAtlas)
SELECT 	'BUILD_LODGE_MARSH',ShowInPedia, ShowInTechTree, 'IMPROVEMENT_LODGE_MARSH', 'TXT_KEY_BUILD_LODGE_MARSH', Help, Recommendation, Time, EntityEvent, OrderPriority, HotKey,	1, 	'JAR_MARSHCAMP_ATLAS'
FROM Builds WHERE Type='BUILD_CAMP';
UPDATE Builds SET PrereqTech= (SELECT PrereqTech FROM Builds WHERE Type ='BUILD_REMOVE_MARSH')
WHERE Type ='BUILD_LODGE_MARSH';
------------------------------
-- Unit_Builds
------------------------------
INSERT INTO Unit_Builds	
		(UnitType, 	BuildType)
SELECT 	 Type,		'BUILD_LODGE_MARSH' FROM Units WHERE Class='UNITCLASS_WORKER';
--==========================================================================================================================
-- ICON ATLASES
--==========================================================================================================================
-- IconTextureAtlases
--------------------------------------------------------------------------------------------------------------------------
INSERT INTO IconTextureAtlases 
		(Atlas, 						IconSize, 	Filename, 						IconsPerRow, 	IconsPerColumn)
VALUES	('JAR_MARSHCAMP_ATLAS', 		256, 		'MarshCampAtlas256.dds',		2,				1),
		('JAR_MARSHCAMP_ATLAS', 		64, 		'MarshCampAtlas064.dds',		2, 				1),
		('JAR_MARSHCAMP_ATLAS', 		45, 		'MarshCampAtlas045.dds',		2, 				1);
--==========================================================================================================================
-- ArtDefine_LandmarkTypes
--==========================================================================================================================
INSERT INTO ArtDefine_LandmarkTypes 
		(Type, 								LandmarkType,	FriendlyName)
VALUES	('ART_DEF_IMPROVEMENT_MARSHCAMP','Improvement', 	'JARCAST_MARSH_CAMP');
------------------------------
-- ArtDefine_StrategicView
------------------------------	
INSERT INTO ArtDefine_StrategicView (StrategicViewType, TileType, Asset)
SELECT 'ART_DEF_IMPROVEMENT_MARSHCAMP', 'Improvement', 'sv_MarshCamp.dds';
--==========================================================================================================================
-- IMPROVEMENT GRAPHICS
--==========================================================================================================================
-- ArtDefine_Landmarks
----------------------------------------------------------
INSERT INTO ArtDefine_Landmarks
(Era, 	State, 					Scale,	ImprovementType,				LayoutHandler,	ResourceType,				Model,				TerrainContour) VALUES
('Any', 'UnderConstruction',	1,  'ART_DEF_IMPROVEMENT_MARSHCAMP',	'SNAPSHOT',		'ART_DEF_RESOURCE_NONE',	'hb_eom_camp.fxsxml',	1),
('Any', 'Constructed',			0.7,  'ART_DEF_IMPROVEMENT_MARSHCAMP',	'SNAPSHOT',		'ART_DEF_RESOURCE_NONE',	'MarshCamp.fxsxml',		0),
('Any', 'Pillaged',				0.7,  'ART_DEF_IMPROVEMENT_MARSHCAMP',	'SNAPSHOT',		'ART_DEF_RESOURCE_NONE',	'MarshCamp_P.fxsxml',	0);
--=======================================================================================================================
-- IMPROVEMENT
--=======================================================================================================================
INSERT OR REPLACE INTO Improvements
		(Type,						Description, 						Civilopedia, 							Help,	ArtDefineTag,						PillageGold, IconAtlas,	PortraitIndex)
SELECT	'IMPROVEMENT_LODGE_MARSH',	'TXT_KEY_IMPROVEMENT_LODGE_MARSH', 	'TXT_KEY_IMPROVEMENT_LODGE_MARSH_TEXT', Help,	'ART_DEF_IMPROVEMENT_MARSHCAMP',	PillageGold, 'JAR_MARSHCAMP_ATLAS', 0
FROM Improvements  WHERE Type= 'IMPROVEMENT_LUMBERMILL';

INSERT OR REPLACE INTO Language_en_US (Tag, Text) VALUES
('TXT_KEY_IMPROVEMENT_LODGE_MARSH', 	'Lodge'),
('TXT_KEY_IMPROVEMENT_LODGE_MARSH_TEXT', 'Throughout history, marshes have often served as sites for camps, sometimes by necessity, sometimes by strategy. Nomadic groups and early settlers occasionally established temporary camps in marshlands to take advantage of abundant fish, waterfowl, and reeds for building materials.'),
('TXT_KEY_BUILD_LODGE_MARSH', 		'Construct a [LINK=IMPROVEMENT_LODGE_MARSH]Marsh Camp[\LINK]');

INSERT OR REPLACE INTO Improvement_ValidFeatures
(ImprovementType, 			FeatureType) VALUES
('IMPROVEMENT_LODGE_MARSH', 'FEATURE_MARSH');

INSERT OR REPLACE INTO Improvement_Yields 	
(ImprovementType, 			YieldType,			Yield) VALUES
('IMPROVEMENT_LODGE_MARSH',	'YIELD_PRODUCTION',	1);

INSERT INTO Improvement_TechYieldChanges
		(ImprovementType,			TechType,			YieldType,	Yield)
SELECT	'IMPROVEMENT_LODGE_MARSH',	'TECH_GUILDS',		'YIELD_GOLD',	1 UNION ALL
SELECT	'IMPROVEMENT_LODGE_MARSH',	'TECH_ECONOMICS',	'YIELD_GOLD',	1 UNION ALL
SELECT	'IMPROVEMENT_LODGE_MARSH',	'TECH_ECONOMICS',	'YIELD_PRODUCTION',	1 UNION ALL
SELECT	'IMPROVEMENT_LODGE_MARSH',	'TECH_SCIENTIFIC_THEORY','YIELD_SCIENCE',1;

DELETE FROM Building_FeatureYieldChanges WHERE FeatureType= 'FEATURE_MARSH'
AND BuildingType IN (SELECT Type FROM Buildings WHERE BuildingClass = 'BUILDINGCLASS_WINDMILL')
AND NOT EXISTS (SELECT * FROM Eras WHERE Type='ERA_ENLIGHTENMENT');

DELETE FROM Building_FeatureYieldChanges WHERE FeatureType= 'FEATURE_MARSH'
AND BuildingType IN (SELECT Type FROM Buildings WHERE BuildingClass = 'BUILDINGCLASS_WORKSHOP')
AND EXISTS (SELECT * FROM Eras WHERE Type='ERA_ENLIGHTENMENT');

INSERT INTO Building_FeatureYieldChanges
		(BuildingType, FeatureType, 	YieldType, Yield)
SELECT	BuildingType, 'FEATURE_MARSH',	YieldType, Yield
FROM Building_FeatureYieldChanges WHERE FeatureType= 'FEATURE_FOREST'
AND BuildingType IN (SELECT Type FROM Buildings WHERE BuildingClass = 'BUILDINGCLASS_THEATRE');

INSERT OR REPLACE INTO Policy_ImprovementYieldChanges
		(PolicyType,	ImprovementType,			YieldType,	Yield)
SELECT	 PolicyType,	'IMPROVEMENT_LODGE_MARSH',YieldType,	Yield
FROM Policy_ImprovementYieldChanges WHERE ImprovementType = 'IMPROVEMENT_LUMBERMILL';

INSERT OR REPLACE INTO Belief_ImprovementYieldChanges
		(BeliefType, 	ImprovementType, 			YieldType, Yield)
SELECT	 BeliefType,	'IMPROVEMENT_LODGE_MARSH',YieldType, Yield
FROM Belief_ImprovementYieldChanges WHERE ImprovementType = 'IMPROVEMENT_LUMBERMILL';

INSERT OR REPLACE INTO Building_ImprovementYieldChanges
		(BuildingType, ImprovementType, 			YieldType, Yield)
SELECT	BuildingType, 'IMPROVEMENT_LODGE_MARSH', 	YieldType, Yield
FROM Building_ImprovementYieldChanges WHERE ImprovementType='IMPROVEMENT_LUMBERMILL';

INSERT OR REPLACE INTO Building_ImprovementYieldChangesGlobal
		(BuildingType, ImprovementType, 			YieldType, Yield)
SELECT	BuildingType, 'IMPROVEMENT_LODGE_MARSH', 	YieldType, Yield
FROM Building_ImprovementYieldChangesGlobal WHERE ImprovementType='IMPROVEMENT_LUMBERMILL';
--------------------------------------------
-- SQL TRIGGERS for strong compatibility
--------------------------------------------
CREATE TRIGGER IF NOT EXISTS Jar_CampMarsh01
AFTER INSERT ON Policy_ImprovementYieldChanges WHEN (NEW.ImprovementType ='IMPROVEMENT_LUMBERMILL')
BEGIN
	INSERT OR REPLACE  INTO Policy_ImprovementYieldChanges
			(ImprovementType, 			PolicyType, YieldType, Yield)
	SELECT	'IMPROVEMENT_LODGE_MARSH', NEW.PolicyType, NEW.YieldType, NEW.Yield;
END;

CREATE TRIGGER IF NOT EXISTS Jar_CampMarsh02
AFTER INSERT ON Belief_ImprovementYieldChanges WHEN (NEW.ImprovementType ='IMPROVEMENT_LUMBERMILL')
BEGIN
	INSERT OR REPLACE  INTO Belief_ImprovementYieldChanges
			(ImprovementType, 			BeliefType, YieldType, Yield)
	SELECT	'IMPROVEMENT_LODGE_MARSH', NEW.BeliefType, NEW.YieldType, NEW.Yield;
END;

CREATE TRIGGER IF NOT EXISTS Jar_CampMarsh03
AFTER INSERT ON Building_ImprovementYieldChanges WHEN (NEW.ImprovementType ='IMPROVEMENT_LUMBERMILL')
BEGIN
	INSERT OR REPLACE  INTO Building_ImprovementYieldChanges
			(ImprovementType, 			BuildingType, YieldType, Yield)
	SELECT	'IMPROVEMENT_LODGE_MARSH', NEW.BuildingType, NEW.YieldType, NEW.Yield;
END;

CREATE TRIGGER IF NOT EXISTS Jar_CampMarsh04
AFTER INSERT ON Building_ImprovementYieldChangesGlobal WHEN (NEW.ImprovementType ='IMPROVEMENT_LUMBERMILL')
BEGIN
	INSERT OR REPLACE  INTO Building_ImprovementYieldChangesGlobal
			(ImprovementType, 			BuildingType, YieldType, Yield)
	SELECT	'IMPROVEMENT_LODGE_MARSH', NEW.BuildingType, NEW.YieldType, NEW.Yield;
END;

CREATE TRIGGER IF NOT EXISTS Jar_CampMarsh05 AFTER INSERT ON Building_FeatureYieldChanges
	WHEN NEW.FeatureType ='FEATURE_MARSH' AND NEW.BuildingType IN (SELECT Type FROM Buildings WHERE BuildingClass = 'BUILDINGCLASS_WINDMILL')
BEGIN
	DELETE FROM Building_FeatureYieldChanges WHERE FeatureType= NEW.FeatureType AND BuildingType = NEW.BuildingType
	AND NOT EXISTS (SELECT * FROM Eras WHERE Type='ERA_ENLIGHTENMENT');
END;

CREATE TRIGGER IF NOT EXISTS Jar_CampMarsh06 AFTER INSERT ON Building_FeatureYieldChanges
	WHEN NEW.FeatureType ='FEATURE_MARSH' AND NEW.BuildingType IN (SELECT Type FROM Buildings WHERE BuildingClass = 'BUILDINGCLASS_WORKSHOP')
BEGIN
	DELETE FROM Building_FeatureYieldChanges WHERE FeatureType= NEW.FeatureType AND BuildingType = NEW.BuildingType
	AND EXISTS (SELECT * FROM Eras WHERE Type='ERA_ENLIGHTENMENT');
END;

CREATE TRIGGER IF NOT EXISTS Jar_CampMarsh07 AFTER INSERT ON Buildings
WHEN NEW.BuildingClass='BUILDINGCLASS_THEATRE' AND NEW.Type != 'BUILDING_THEATRE'
BEGIN
	INSERT INTO Building_FeatureYieldChanges
			(BuildingType, FeatureType, YieldType, Yield)
	SELECT	NEW.Type, 'FEATURE_MARSH', YieldType, Yield
	FROM Building_FeatureYieldChanges WHERE BuildingType= 'BUILDING_THEATRE' AND FeatureType= 'FEATURE_FOREST';
END;
--==========================================================================================================================
--==========================================================================================================================