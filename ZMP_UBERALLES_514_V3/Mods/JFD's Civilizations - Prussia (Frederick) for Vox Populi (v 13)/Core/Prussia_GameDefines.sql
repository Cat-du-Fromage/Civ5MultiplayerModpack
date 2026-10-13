--==========================================================================================================================	
-- BUILDINGS
--==========================================================================================================================	
-- Buildings
------------------------------	
INSERT INTO Buildings
		(Type, 								BuildingClass, Cost,GoldMaintenance, 	PrereqTech,			Description, 								Civilopedia, 											Help, 												Strategy,												TrainedFreePromotion,		 	SpecialistType,			SpecialistCount,	ArtDefineTag,	MinAreaSize, ConquestProb, HurryCostModifier, PortraitIndex, 	IconAtlas,						CitySupplyFlat,	DistressFlatReduction)
SELECT	('BUILDING_PRUSSIAN_KRIEGSSCHULE'),	BuildingClass, 900,	GoldMaintenance-1, 	'TECH_METALLURGY',	('TXT_KEY_BUILDING_PRUSSIAN_KRIEGSSCHULE'), ('TXT_KEY_CIV5_BUILDINGS_PRUSSIAN_KRIEGSSCHULE_TEXT'), ('TXT_KEY_BUILDING_PRUSSIAN_KRIEGSSCHULE_HELP'), 	('TXT_KEY_BUILDING_PRUSSIAN_KRIEGSSCHULE_STRATEGY'),	'PROMOTION_PRUSSIAN_GOOSESTEP',	'SPECIALIST_SCIENTIST', SpecialistCount+1,	ArtDefineTag,	MinAreaSize, ConquestProb, HurryCostModifier, 0, 				('JFD_PRUSSIA_FOR_VP_ATLAS'),	CitySupplyFlat,	DistressFlatReduction
FROM Buildings WHERE (Type = 'BUILDING_MILITARY_ACADEMY');

UPDATE Buildings SET
	Cost= (SELECT Cost FROM Buildings WHERE Type= 'BUILDING_EE_GUNSMITH'),
	PrereqTech= (SELECT PrereqTech FROM Buildings WHERE Type= 'BUILDING_EE_GUNSMITH'),
	GoldMaintenance= (SELECT GoldMaintenance-1 FROM Buildings WHERE Type= 'BUILDING_EE_GUNSMITH')
WHERE Type = 'BUILDING_PRUSSIAN_KRIEGSSCHULE' AND EXISTS (SELECT * FROM Buildings WHERE Type='BUILDING_EE_GUNSMITH');

CREATE TRIGGER IF NOT EXISTS JarPrussiaEECompatibility01 AFTER UPDATE OF Cost ON Units
WHEN NEW.Cost = 400 AND OLD.Type = 'UNIT_EE_GALLEON'
BEGIN
	UPDATE Buildings SET
		Cost= (SELECT Cost FROM Buildings WHERE Type= 'BUILDING_EE_GUNSMITH'),
		PrereqTech= (SELECT PrereqTech FROM Buildings WHERE Type= 'BUILDING_EE_GUNSMITH'),
		GoldMaintenance= (SELECT GoldMaintenance-1 FROM Buildings WHERE Type= 'BUILDING_EE_GUNSMITH')
	WHERE Type = 'BUILDING_PRUSSIAN_KRIEGSSCHULE';
END;

INSERT INTO Buildings
		(Type, 							BuildingClass, Cost, GoldMaintenance, PrereqTech, Description, 							Civilopedia, 									Help, 										Strategy,										RequiresIndustrialCityConnection,	SpecialistType,	SpecialistCount, ArtDefineTag,	MinAreaSize, ConquestProb, HurryCostModifier, PortraitIndex, 	IconAtlas)
SELECT	('BUILDING_STAATSEISENBAHN'),	BuildingClass, Cost, GoldMaintenance, PrereqTech, ('TXT_KEY_BUILDING_STAATSEISENBAHN'), ('TXT_KEY_CIV5_BUILDINGS_STAATSEISENBAHN_TEXT'), ('TXT_KEY_BUILDING_STAATSEISENBAHN_HELP'), ('TXT_KEY_BUILDING_STAATSEISENBAHN_STRATEGY'),	RequiresIndustrialCityConnection,	SpecialistType, SpecialistCount, ArtDefineTag,	MinAreaSize, ConquestProb, HurryCostModifier, 1, 				('JFD_PRUSSIA_FOR_VP_ATLAS')	
FROM Buildings WHERE (Type = 'BUILDING_COALING_STATION');
UPDATE Buildings SET CityConnectionTradeRouteModifier = 5 WHERE Type = 'BUILDING_STAATSEISENBAHN';
------------------------------	
-- Building_Flavors
------------------------------		
INSERT INTO Building_Flavors 	
		(BuildingType, 						FlavorType, 				Flavor)
VALUES	('BUILDING_PRUSSIAN_KRIEGSSCHULE',	'FLAVOR_MILITARY_TRAINING', 25),
		('BUILDING_PRUSSIAN_KRIEGSSCHULE',	'FLAVOR_CULTURE', 15);

INSERT INTO Building_Flavors 	
		(BuildingType, 				FlavorType,		Flavor)
SELECT	'BUILDING_STAATSEISENBAHN',	FlavorType,		Flavor
FROM Building_Flavors WHERE (BuildingType = 'BUILDING_COALING_STATION');
------------------------------	
-- Building_ClassesNeededInCity
------------------------------		
INSERT INTO Building_ClassesNeededInCity 	
		(BuildingType, 						BuildingClassType)
SELECT	('BUILDING_PRUSSIAN_KRIEGSSCHULE'),	BuildingClassType
FROM Building_ClassesNeededInCity WHERE (BuildingType = 'BUILDING_MILITARY_ACADEMY');

INSERT INTO Building_ClassesNeededInCity 	
		(BuildingType, 					BuildingClassType)
SELECT	('BUILDING_STAATSEISENBAHN'),	BuildingClassType
FROM Building_ClassesNeededInCity WHERE (BuildingType = 'BUILDING_COALING_STATION');
------------------------------	
-- Building_YieldChanges
------------------------------		
INSERT INTO Building_YieldChanges 	
		(BuildingType, 						YieldType,			Yield)
VALUES	('BUILDING_PRUSSIAN_KRIEGSSCHULE',	'YIELD_SCIENCE',	2),
		('BUILDING_PRUSSIAN_KRIEGSSCHULE',	'YIELD_CULTURE',	2),
		('BUILDING_STAATSEISENBAHN',		'YIELD_PRODUCTION',	3),
		('BUILDING_STAATSEISENBAHN',		'YIELD_GOLD',		3),
		('BUILDING_STAATSEISENBAHN',		'YIELD_SCIENCE',	3);
------------------------------	
-- Building_YieldModifiers
------------------------------
INSERT INTO Building_YieldModifiers
		(BuildingType, 				YieldType, Yield)
SELECT	'BUILDING_STAATSEISENBAHN', YieldType, Yield
FROM Building_YieldModifiers WHERE (BuildingType = 'BUILDING_COALING_STATION');
--------------------------------
-- Building_YieldFromInternalTR
--------------------------------
INSERT INTO Building_YieldFromInternalTR
		(BuildingType, 				YieldType, Yield)
SELECT	'BUILDING_STAATSEISENBAHN', YieldType, Yield
FROM Building_YieldFromInternalTR WHERE BuildingType = 'BUILDING_COALING_STATION';
------------------------------	
-- Building_DomainFreeExperiences
------------------------------
INSERT INTO Building_DomainFreeExperiences 	
		(BuildingType, 						DomainType, Experience)
SELECT	('BUILDING_PRUSSIAN_KRIEGSSCHULE'),	DomainType, Experience+15
FROM Building_DomainFreeExperiences WHERE (BuildingType = 'BUILDING_MILITARY_ACADEMY');
------------------------------	
-- Building_DomainProductionModifiers
------------------------------
INSERT INTO Building_DomainProductionModifiers 	
		(BuildingType, 						DomainType, Modifier)
SELECT	('BUILDING_PRUSSIAN_KRIEGSSCHULE'),	DomainType, Modifier
FROM Building_DomainProductionModifiers WHERE (BuildingType = 'BUILDING_MILITARY_ACADEMY');
------------------------------	
-- Building_SpecialistYieldChangesLocal
------------------------------
INSERT INTO Building_SpecialistYieldChangesLocal
		(BuildingType,				SpecialistType,			YieldType,			Yield)
VALUES	('BUILDING_STAATSEISENBAHN','SPECIALIST_ENGINEER',	'YIELD_CULTURE',	1),
		('BUILDING_STAATSEISENBAHN','SPECIALIST_ENGINEER',	'YIELD_SCIENCE',	2);
--==========================================================================================================================	
-- PROMOTIONS
--==========================================================================================================================	
-- UnitPromotions
------------------------------
INSERT INTO UnitPromotions 
		(Type, 										Description, 								Help, 											Sound, 				CannotBeChosen, 	IgnoreZOC,  LostWithUpgrade,	MovesChange,	PortraitIndex, 	IconAtlas, 				PediaType, 			PediaEntry)
VALUES	('PROMOTION_JFD_DEATHS_HEAD', 				'TXT_KEY_PROMOTION_JFD_DEATHS_HEAD', 		'TXT_KEY_PROMOTION_JFD_DEATHS_HEAD_HELP', 		'AS2D_IF_LEVELUP', 	1, 					1, 			0, 					0,				0, 				'JFD_PRUSSIA_PI_ATLAS',	'PEDIA_ATTRIBUTES', 'TXT_KEY_PROMOTION_JFD_DEATHS_HEAD'),
		('PROMOTION_PRUSSIAN_GOOSESTEP',			'TXT_KEY_PROMOTION_PRUSSIAN_GOOSESTEP', 	'TXT_KEY_PROMOTION_PRUSSIAN_GOOSESTEP_HELP', 	'AS2D_IF_LEVELUP', 	1, 					0, 			0, 					1,				2, 				'JFD_PRUSSIA_PI_ATLAS',	'PEDIA_MELEE', 		'TXT_KEY_PROMOTION_PRUSSIAN_GOOSESTEP'),
		('PROMOTION_PRUSSIAN_DISCIPLINE',			'TXT_KEY_PROMOTION_PRUSSIAN_DISCIPLINE', 	'TXT_KEY_PROMOTION_PRUSSIAN_DISCIPLINE_HELP', 	'AS2D_IF_LEVELUP', 	1, 					0, 			0, 					0,				1, 				'JFD_PRUSSIA_PI_ATLAS',	'PEDIA_MELEE', 		'TXT_KEY_PROMOTION_PRUSSIAN_DISCIPLINE');

UPDATE UnitPromotions SET NearbyEnemyCombatMod = -10, NearbyEnemyCombatRange = 2 WHERE Type = 'PROMOTION_JFD_DEATHS_HEAD';
UPDATE UnitPromotions SET CombatPercent = 15, GreatGeneralCombatModifier = 15 WHERE Type = 'PROMOTION_PRUSSIAN_DISCIPLINE';
--------------------------------	
-- UnitPromotions_UnitCombats
--------------------------------	
INSERT INTO UnitPromotions_UnitCombats
		(PromotionType, UnitCombatType)
VALUES	('PROMOTION_PRUSSIAN_GOOSESTEP', 'UNITCOMBAT_MELEE'),
		('PROMOTION_PRUSSIAN_GOOSESTEP', 'UNITCOMBAT_GUN'),
		('PROMOTION_PRUSSIAN_DISCIPLINE', 'UNITCOMBAT_MELEE'),
		('PROMOTION_PRUSSIAN_DISCIPLINE', 'UNITCOMBAT_GUN');
--------------------------------	
-- UnitPromotions_CombatModPerAdjacentUnitCombat
--------------------------------	
INSERT INTO UnitPromotions_CombatModPerAdjacentUnitCombat
		(PromotionType, UnitCombatType, Modifier)
VALUES	('PROMOTION_PRUSSIAN_GOOSESTEP', 'UNITCOMBAT_MELEE', 10),
		('PROMOTION_PRUSSIAN_GOOSESTEP', 'UNITCOMBAT_GUN', 10);
--==========================================================================================================================	
-- UNIT CLASS
--==========================================================================================================================
-- UnitClasses
--------------------------------
INSERT INTO UnitClasses 
		(Type, Description, DefaultUnit) 
VALUES 	('UNITCLASS_DEATHS_HEAD', 'TXT_KEY_UNIT_JFD_DEATHS_HEAD', 'UNIT_JFD_DEATHS_HEAD');
--==========================================================================================================================	
-- UNITS
--==========================================================================================================================
-- Units
--------------------------------
INSERT INTO Units 	
		(Type, 						Class,					PrereqTech, Combat,		RangedCombat,	Cost, FaithCost, RequiresFaithPurchaseEnabled, Moves, Range, CombatClass, Domain, DefaultUnitAI, Description, 						Civilopedia, 							Strategy, 									Help, 									MilitarySupport, MilitaryProduction, Pillage, IgnoreBuildingDefense, AdvancedStartCost, GoodyHutUpgradeUnitClass, CombatLimit, XPValueDefense, UnitArtInfo, 						UnitFlagIconOffset, UnitFlagAtlas,						PortraitIndex, 	IconAtlas,				MoveRate,	PurchaseCooldown)
SELECT	'UNIT_JFD_DEATHS_HEAD',		'UNITCLASS_CUIRASSIER',	PrereqTech, Combat+2,	RangedCombat+1,	Cost, FaithCost, RequiresFaithPurchaseEnabled, Moves, Range, CombatClass, Domain, DefaultUnitAI, 'TXT_KEY_UNIT_JFD_DEATHS_HEAD', 	'TXT_KEY_CIV5_JFD_DEATHS_HEAD_TEXT', 	'TXT_KEY_UNIT_JFD_DEATHS_HEAD_STRATEGY', 	'TXT_KEY_UNIT_HELP_JFD_DEATHS_HEAD', 	MilitarySupport, MilitaryProduction, Pillage, IgnoreBuildingDefense, AdvancedStartCost, GoodyHutUpgradeUnitClass, CombatLimit, XPValueDefense, 'ART_DEF_UNIT_JFD_DEATHS_HEAD',		0,					'JFD_UNIT_FLAG_DEATHS_HEAD_ATLAS',	3, 				'JFD_PRUSSIA_ATLAS',	MoveRate,	PurchaseCooldown
FROM Units WHERE Type = 'UNIT_CUIRASSIER';

INSERT INTO Units 	
		(Type, 						Class, PrereqTech, Combat,		Cost, FaithCost, RequiresFaithPurchaseEnabled, Moves, CombatClass, Domain, DefaultUnitAI, Description, 						Civilopedia, 							Strategy, 									Help, 									MilitarySupport, MilitaryProduction, Pillage, IgnoreBuildingDefense, AdvancedStartCost, CombatLimit, XPValueDefense, GoodyHutUpgradeUnitClass, UnitArtInfo, 					UnitFlagIconOffset, UnitFlagAtlas,						PortraitIndex, 	IconAtlas,				PurchaseCooldown)
SELECT	'UNIT_JFD_LANDWEHR', 		Class, PrereqTech, Combat+4,	Cost, FaithCost, RequiresFaithPurchaseEnabled, Moves, CombatClass, Domain, DefaultUnitAI, 'TXT_KEY_UNIT_JFD_LANDWEHR', 		'TXT_KEY_CIV5_JFD_LANDWEHR_TEXT', 		'TXT_KEY_UNIT_JFD_LANDWEHR_STRATEGY', 		'TXT_KEY_UNIT_HELP_JFD_LANDWEHR',		MilitarySupport, MilitaryProduction, Pillage, IgnoreBuildingDefense, AdvancedStartCost, CombatLimit, XPValueDefense, GoodyHutUpgradeUnitClass, 'ART_DEF_UNIT_JFD_LANDWEHR',		0,					'JFD_UNIT_FLAG_LANDWEHR_ATLAS',		2, 				'JFD_PRUSSIA_ATLAS',	PurchaseCooldown
FROM Units WHERE Type = 'UNIT_RIFLEMAN';

UPDATE Units SET 
	Class =  (SELECT Class FROM Units WHERE Type= 'UNIT_EE_DRAGOON'),
	Cost =  (SELECT Cost FROM Units WHERE Type= 'UNIT_EE_DRAGOON'),
	FaithCost =  (SELECT FaithCost FROM Units WHERE Type= 'UNIT_EE_DRAGOON'),
	Combat =  (SELECT Combat+2 FROM Units WHERE Type= 'UNIT_EE_DRAGOON'),
	RangedCombat =  (SELECT RangedCombat+1 FROM Units WHERE Type= 'UNIT_EE_DRAGOON'),
	PrereqTech= (SELECT PrereqTech FROM Units WHERE Type= 'UNIT_EE_DRAGOON')
WHERE Type = 'UNIT_JFD_DEATHS_HEAD' AND EXISTS (SELECT * FROM Units WHERE Type='UNIT_EE_DRAGOON');

UPDATE Unit_BuildingClassPurchaseRequireds SET BuildingClassType = 'BUILDINGCLASS_EE_GUNSMITH' 
WHERE BuildingClassType = 'BUILDINGCLASS_ARMORY' AND UnitType = 'UNIT_JFD_DEATHS_HEAD' 
AND EXISTS (SELECT * FROM Units WHERE Type='UNIT_EE_DRAGOON');

CREATE TRIGGER IF NOT EXISTS JarPrussiaEECompatibility02 AFTER UPDATE OF Cost ON Units
WHEN NEW.Cost = 400 AND OLD.Type = 'UNIT_EE_GALLEON'
BEGIN
	UPDATE Units SET 
		Class =  (SELECT Class FROM Units WHERE Type= 'UNIT_EE_DRAGOON'),
		Cost =  (SELECT Cost FROM Units WHERE Type= 'UNIT_EE_DRAGOON'),
		FaithCost =  (SELECT FaithCost FROM Units WHERE Type= 'UNIT_EE_DRAGOON'),
		Combat =  (SELECT Combat+5 FROM Units WHERE Type= 'UNIT_EE_DRAGOON'),
		RangedCombat =  (SELECT RangedCombat+3 FROM Units WHERE Type= 'UNIT_EE_DRAGOON'),
		PrereqTech= (SELECT PrereqTech FROM Units WHERE Type= 'UNIT_EE_DRAGOON')
	WHERE Type = 'UNIT_JFD_DEATHS_HEAD';
	
	UPDATE Unit_BuildingClassPurchaseRequireds SET BuildingClassType = 'BUILDINGCLASS_EE_GUNSMITH' 
	WHERE BuildingClassType = 'BUILDINGCLASS_ARMORY' AND UnitType = 'UNIT_JFD_DEATHS_HEAD';
END;
--------------------------------	
-- UnitGameplay2DScripts
--------------------------------	
INSERT INTO UnitGameplay2DScripts 	
		(UnitType, 					SelectionSound, FirstSelectionSound)
SELECT	'UNIT_JFD_DEATHS_HEAD', 	SelectionSound, FirstSelectionSound
FROM UnitGameplay2DScripts WHERE UnitType = 'UNIT_CUIRASSIER';	
	
INSERT INTO UnitGameplay2DScripts 	
		(UnitType, 					SelectionSound, FirstSelectionSound)
SELECT	'UNIT_JFD_LANDWEHR', 		SelectionSound, FirstSelectionSound
FROM UnitGameplay2DScripts WHERE UnitType = 'UNIT_RIFLEMAN';
--------------------------------		
-- Unit_AITypes
--------------------------------	
INSERT INTO Unit_AITypes 	
		(UnitType, 					UnitAIType)
SELECT	'UNIT_JFD_DEATHS_HEAD', 	UnitAIType
FROM Unit_AITypes WHERE UnitType = 'UNIT_CUIRASSIER';
	
INSERT INTO Unit_AITypes 	
		(UnitType, 					UnitAIType)
SELECT	'UNIT_JFD_LANDWEHR',		UnitAIType
FROM Unit_AITypes WHERE UnitType = 'UNIT_RIFLEMAN';	
--------------------------------	
-- Unit_ClassUpgrades
--------------------------------		
INSERT INTO Unit_ClassUpgrades 	
		(UnitType, 					UnitClassType)
SELECT	'UNIT_JFD_DEATHS_HEAD', 	UnitClassType
FROM Unit_ClassUpgrades WHERE UnitType = 'UNIT_CUIRASSIER';

INSERT INTO Unit_ClassUpgrades 	
		(UnitType, 					UnitClassType)
SELECT	'UNIT_JFD_LANDWEHR',		UnitClassType
FROM Unit_ClassUpgrades WHERE UnitType = 'UNIT_RIFLEMAN';

UPDATE Unit_ClassUpgrades SET UnitClassType = (SELECT UnitClassType FROM Unit_ClassUpgrades WHERE UnitType= 'UNIT_EE_DRAGOON')
WHERE UnitType = 'UNIT_JFD_DEATHS_HEAD' AND EXISTS (SELECT * FROM Units WHERE Type='UNIT_EE_DRAGOON');

UPDATE Units SET
ObsoleteTech = (select a.ObsoleteTech from Units a, Unit_ClassUpgrades b, UnitClasses c WHERE b.UnitType='UNIT_JFD_DEATHS_HEAD' and b.UnitClassType=c.Type and c.DefaultUnit=a.Type)
WHERE Type = 'UNIT_JFD_DEATHS_HEAD';

UPDATE Units SET
ObsoleteTech = (select a.ObsoleteTech from Units a, Unit_ClassUpgrades b, UnitClasses c WHERE b.UnitType='UNIT_JFD_LANDWEHR' and b.UnitClassType=c.Type and c.DefaultUnit=a.Type)
WHERE Type = 'UNIT_JFD_LANDWEHR';

CREATE TRIGGER IF NOT EXISTS JarPrussiaEECompatibility03 AFTER UPDATE OF Cost ON Units
WHEN NEW.Cost = 400 AND OLD.Type = 'UNIT_EE_GALLEON'
BEGIN
	UPDATE Unit_ClassUpgrades SET UnitClassType = (SELECT UnitClassType FROM Unit_ClassUpgrades WHERE UnitType= 'UNIT_EE_DRAGOON')
	WHERE UnitType = 'UNIT_JFD_DEATHS_HEAD';
	
	UPDATE Units SET
	ObsoleteTech = (select a.ObsoleteTech from Units a, Unit_ClassUpgrades b, UnitClasses c WHERE b.UnitType='UNIT_JFD_DEATHS_HEAD' and b.UnitClassType=c.Type and c.DefaultUnit=a.Type)
	WHERE Type = 'UNIT_JFD_DEATHS_HEAD';
END;
--------------------------------	
-- Unit_ResourceQuantityRequirements
--------------------------------		
INSERT INTO Unit_ResourceQuantityRequirements 	
		(UnitType, 					ResourceType)
SELECT	'UNIT_JFD_DEATHS_HEAD', 	ResourceType
FROM Unit_ResourceQuantityRequirements WHERE UnitType = 'UNIT_CUIRASSIER';
--------------------------------	
-- Unit_Flavors
--------------------------------	
INSERT INTO Unit_Flavors 	
		(UnitType, 					FlavorType, Flavor)
SELECT	'UNIT_JFD_DEATHS_HEAD',		FlavorType, Flavor+2
FROM Unit_Flavors WHERE UnitType = 'UNIT_CUIRASSIER';

INSERT INTO Unit_Flavors 	
		(UnitType, 					FlavorType, Flavor)
SELECT	'UNIT_JFD_LANDWEHR', 		FlavorType, Flavor+2
FROM Unit_Flavors WHERE UnitType = 'UNIT_RIFLEMAN';	
--------------------------------
-- Unit_FreePromotions
--------------------------------	
INSERT INTO Unit_FreePromotions 	
		(UnitType, 					PromotionType)
SELECT	'UNIT_JFD_DEATHS_HEAD',		PromotionType
FROM Unit_FreePromotions WHERE UnitType = 'UNIT_CUIRASSIER';

INSERT INTO Unit_FreePromotions 
		(UnitType, 					PromotionType)
VALUES	('UNIT_JFD_DEATHS_HEAD', 	'PROMOTION_JFD_DEATHS_HEAD');

INSERT INTO Unit_FreePromotions
		(UnitType, 					PromotionType)
SELECT	'UNIT_JFD_LANDWEHR',		PromotionType
FROM Unit_FreePromotions WHERE UnitType = 'UNIT_RIFLEMAN';

INSERT INTO Unit_FreePromotions -- Landwehr now gets Stalwart
		(UnitType, 				PromotionType)
VALUES	('UNIT_JFD_LANDWEHR', 	'PROMOTION_STALWART');
--==========================================================================================================================	
-- LEADERS
--==========================================================================================================================	
-- Leaders
--------------------------------			
INSERT INTO Leaders 
		(Type, 						Description, 							Civilopedia, 							CivilopediaTag, 								ArtDefineTag, 						VictoryCompetitiveness, WonderCompetitiveness, 	MinorCivCompetitiveness, 	Boldness, 	DiploBalance, 	WarmongerHate, 	DenounceWillingness, 	DoFWillingness, Loyalty, 	Neediness, 	Forgiveness, 	Chattiness, Meanness, 	IconAtlas, 				PortraitIndex)
VALUES	('LEADER_JFD_FREDERICK', 	'TXT_KEY_LEADER_JFD_FREDERICK_DESC', 	'TXT_KEY_LEADER_JFD_FREDERICK_PEDIA', 	'TXT_KEY_CIVILOPEDIA_LEADERS_JFD_FREDERICK', 	'Janboruta_Frederick_Scene.xml',	9, 						8, 						6, 							7, 			8, 				6, 				4, 						7, 				8, 			5, 			5, 				4, 			3, 			'JFD_PRUSSIA_ATLAS', 	1);

UPDATE Leaders SET VictoryCompetitiveness = 9, WonderCompetitiveness = 8, MinorCivCompetitiveness = 6, Boldness = 7, DiploBalance = 8, WarmongerHate = 6, DenounceWillingness = 4, DoFWillingness = 7, Loyalty = 8, Neediness = 5, Forgiveness = 5, Chattiness = 4, Meanness = 3 WHERE Type = 'LEADER_JFD_FREDERICK';
--------------------------------		
-- Leader_MajorCivApproachBiases
--------------------------------						
INSERT INTO Leader_MajorCivApproachBiases 
		(LeaderType, 				MajorCivApproachType, 				Bias)
VALUES	('LEADER_JFD_FREDERICK', 	'MAJOR_CIV_APPROACH_WAR', 			4),
		('LEADER_JFD_FREDERICK', 	'MAJOR_CIV_APPROACH_HOSTILE', 		4),
		('LEADER_JFD_FREDERICK', 	'MAJOR_CIV_APPROACH_DECEPTIVE', 	4),
		('LEADER_JFD_FREDERICK', 	'MAJOR_CIV_APPROACH_GUARDED', 		4),
		('LEADER_JFD_FREDERICK', 	'MAJOR_CIV_APPROACH_AFRAID', 		3),
		('LEADER_JFD_FREDERICK', 	'MAJOR_CIV_APPROACH_FRIENDLY', 		8),
		('LEADER_JFD_FREDERICK', 	'MAJOR_CIV_APPROACH_NEUTRAL', 		8);
--------------------------------	
-- Leader_MajorCivApproachBiases
--------------------------------							
INSERT INTO Leader_MinorCivApproachBiases 
		(LeaderType, 				MinorCivApproachType, 				Bias)
VALUES	('LEADER_JFD_FREDERICK', 	'MINOR_CIV_APPROACH_IGNORE', 		6),
		('LEADER_JFD_FREDERICK', 	'MINOR_CIV_APPROACH_FRIENDLY', 		6),
		('LEADER_JFD_FREDERICK', 	'MINOR_CIV_APPROACH_PROTECTIVE', 	6),
		('LEADER_JFD_FREDERICK', 	'MINOR_CIV_APPROACH_CONQUEST', 		5),
		('LEADER_JFD_FREDERICK', 	'MINOR_CIV_APPROACH_BULLY', 		4);
--------------------------------	
-- Leader_Flavors
--------------------------------							
INSERT INTO Leader_Flavors 
		(LeaderType, 				FlavorType, 						Flavor)
VALUES	('LEADER_JFD_FREDERICK', 	'FLAVOR_OFFENSE', 					9),
		('LEADER_JFD_FREDERICK', 	'FLAVOR_DEFENSE', 					5),
		('LEADER_JFD_FREDERICK', 	'FLAVOR_CITY_DEFENSE', 				5),
		('LEADER_JFD_FREDERICK', 	'FLAVOR_MILITARY_TRAINING', 		9),
		('LEADER_JFD_FREDERICK', 	'FLAVOR_RECON', 					6),
		('LEADER_JFD_FREDERICK', 	'FLAVOR_RANGED', 					4),
		('LEADER_JFD_FREDERICK', 	'FLAVOR_MOBILE', 					7),
		('LEADER_JFD_FREDERICK', 	'FLAVOR_NAVAL', 					4),
		('LEADER_JFD_FREDERICK', 	'FLAVOR_NAVAL_RECON', 				4),
		('LEADER_JFD_FREDERICK', 	'FLAVOR_NAVAL_GROWTH', 				4),
		('LEADER_JFD_FREDERICK', 	'FLAVOR_NAVAL_TILE_IMPROVEMENT', 	4),
		('LEADER_JFD_FREDERICK', 	'FLAVOR_AIR', 						5),
		('LEADER_JFD_FREDERICK', 	'FLAVOR_EXPANSION', 				7),
		('LEADER_JFD_FREDERICK', 	'FLAVOR_GROWTH', 					6),
		('LEADER_JFD_FREDERICK', 	'FLAVOR_TILE_IMPROVEMENT', 			6),
		('LEADER_JFD_FREDERICK', 	'FLAVOR_INFRASTRUCTURE', 			4),
		('LEADER_JFD_FREDERICK', 	'FLAVOR_PRODUCTION', 				6),
		('LEADER_JFD_FREDERICK', 	'FLAVOR_GOLD', 						6),
		('LEADER_JFD_FREDERICK', 	'FLAVOR_SCIENCE', 					5),
		('LEADER_JFD_FREDERICK', 	'FLAVOR_CULTURE', 					5),
		('LEADER_JFD_FREDERICK', 	'FLAVOR_HAPPINESS', 				6),
		('LEADER_JFD_FREDERICK', 	'FLAVOR_GREAT_PEOPLE', 				6),
		('LEADER_JFD_FREDERICK', 	'FLAVOR_WONDER', 					6),
		('LEADER_JFD_FREDERICK', 	'FLAVOR_RELIGION', 					4),
		('LEADER_JFD_FREDERICK', 	'FLAVOR_DIPLOMACY', 				8),
		('LEADER_JFD_FREDERICK', 	'FLAVOR_SPACESHIP', 				4),
		('LEADER_JFD_FREDERICK', 	'FLAVOR_WATER_CONNECTION', 			4),
		('LEADER_JFD_FREDERICK', 	'FLAVOR_NUKE', 						2),
		('LEADER_JFD_FREDERICK', 	'FLAVOR_USE_NUKE', 					2),
		('LEADER_JFD_FREDERICK', 	'FLAVOR_ESPIONAGE', 				5),
		('LEADER_JFD_FREDERICK', 	'FLAVOR_AIRLIFT', 					2),
		('LEADER_JFD_FREDERICK', 	'FLAVOR_I_TRADE_DESTINATION', 		5),
		('LEADER_JFD_FREDERICK', 	'FLAVOR_I_TRADE_ORIGIN', 			5),
		('LEADER_JFD_FREDERICK', 	'FLAVOR_I_SEA_TRADE_ROUTE', 		5),
		('LEADER_JFD_FREDERICK', 	'FLAVOR_I_LAND_TRADE_ROUTE', 		5),
		('LEADER_JFD_FREDERICK', 	'FLAVOR_ARCHAEOLOGY', 				5),
		('LEADER_JFD_FREDERICK', 	'FLAVOR_AIR_CARRIER', 				5);
--------------------------------	
-- Leader_Traits
--------------------------------	
INSERT INTO Leader_Traits 
		(LeaderType, 				TraitType)
VALUES	('LEADER_JFD_FREDERICK', 	'TRAIT_JFD_PRUSSIA');
--==========================================================================================================================	
-- TRAITS
--==========================================================================================================================	
-- Traits
--------------------------------	
INSERT INTO Traits 
		(Type, 						Description, 						ShortDescription)
VALUES	('TRAIT_JFD_PRUSSIA', 		'TXT_KEY_TRAIT_JFD_PRUSSIA', 		'TXT_KEY_TRAIT_JFD_PRUSSIA_SHORT');
UPDATE Traits SET IsOddEraScaler = 1 WHERE Type = 'TRAIT_JFD_PRUSSIA'; -- For the era scaling of specialist bonus Great General points
--------------------------------
-- Trait_SpecialistYieldChanges
--------------------------------
INSERT INTO Trait_SpecialistYieldChanges
		(TraitType, SpecialistType, YieldType, Yield)
SELECT	'TRAIT_JFD_PRUSSIA', Type, 'YIELD_GREAT_GENERAL_POINTS', 1
FROM Specialists WHERE Type <> 'SPECIALIST_CITIZEN';
--------------------------------
-- Trait_DomainProductionModifiersPerSpecialist
--------------------------------
INSERT INTO Trait_DomainProductionModifiersPerSpecialist
		(TraitType, DomainType, Modifier)
VALUES	('TRAIT_JFD_PRUSSIA', 'DOMAIN_LAND', 5);
--------------------------------
-- Trait_FreePromotionUnitCombats
--------------------------------
INSERT INTO Trait_FreePromotionUnitCombats
		(TraitType, UnitCombatType, PromotionType)
SELECT	'TRAIT_JFD_PRUSSIA','UNITCOMBAT_MELEE',	'PROMOTION_PRUSSIAN_DISCIPLINE'	UNION ALL
SELECT	'TRAIT_JFD_PRUSSIA','UNITCOMBAT_GUN',	'PROMOTION_PRUSSIAN_DISCIPLINE';
--==========================================================================================================================	
-- CIVILIZATIONS
--==========================================================================================================================	
-- Civilizations
--------------------------------		
INSERT INTO Civilizations 	
		(Type, 						DerivativeCiv,			Description, 					ShortDescription, 						Adjective, 								Civilopedia, 						CivilopediaTag, 			DefaultPlayerColor, 		ArtDefineTag, ArtStyleType, ArtStyleSuffix, ArtStylePrefix, IconAtlas, 				PortraitIndex, 	AlphaIconAtlas, 			SoundtrackTag, 	MapImage, 						DawnOfManQuote, 						DawnOfManImage)
SELECT	'CIVILIZATION_JFD_PRUSSIA',	'CIVILIZATION_GERMANY',	'TXT_KEY_CIV_JFD_PRUSSIA_DESC', 'TXT_KEY_CIV_JFD_PRUSSIA_SHORT_DESC', 	'TXT_KEY_CIV_JFD_PRUSSIA_ADJECTIVE', 	'TXT_KEY_CIV5_JFD_PRUSSIA_TEXT_1', 	'TXT_KEY_CIV5_JFD_PRUSSIA', 'PLAYERCOLOR_JFD_PRUSSIA', 	ArtDefineTag, ArtStyleType, ArtStyleSuffix, ArtStylePrefix, 'JFD_PRUSSIA_ATLAS', 	0, 				'JFD_PRUSSIA_ALPHA_ATLAS', 	'Germany', 		'Janboruta_MapPrussia512.dds', 	'TXT_KEY_CIV5_DOM_JFD_FREDERICK_TEXT', 	'Janboruta_Frederick_DOM.dds'
FROM Civilizations WHERE Type = 'CIVILIZATION_GERMANY';
--------------------------------	
-- Civilization_CityNames
--------------------------------	
INSERT INTO Civilization_CityNames 
		(CivilizationType, 				CityName)
VALUES	('CIVILIZATION_JFD_PRUSSIA',	'TXT_KEY_CITY_NAME_JFD_PRUSSIA_01'),
		('CIVILIZATION_JFD_PRUSSIA',	'TXT_KEY_CITY_NAME_JFD_PRUSSIA_02'),
		('CIVILIZATION_JFD_PRUSSIA',	'TXT_KEY_CITY_NAME_JFD_PRUSSIA_03'),
		('CIVILIZATION_JFD_PRUSSIA',	'TXT_KEY_CITY_NAME_JFD_PRUSSIA_04'),
		('CIVILIZATION_JFD_PRUSSIA',	'TXT_KEY_CITY_NAME_JFD_PRUSSIA_05'),
		('CIVILIZATION_JFD_PRUSSIA',	'TXT_KEY_CITY_NAME_JFD_PRUSSIA_06'),
		('CIVILIZATION_JFD_PRUSSIA',	'TXT_KEY_CITY_NAME_JFD_PRUSSIA_07'),
		('CIVILIZATION_JFD_PRUSSIA',	'TXT_KEY_CITY_NAME_JFD_PRUSSIA_08'),
		('CIVILIZATION_JFD_PRUSSIA',	'TXT_KEY_CITY_NAME_JFD_PRUSSIA_09'),
		('CIVILIZATION_JFD_PRUSSIA',	'TXT_KEY_CITY_NAME_JFD_PRUSSIA_10'),
		('CIVILIZATION_JFD_PRUSSIA',	'TXT_KEY_CITY_NAME_JFD_PRUSSIA_11'),
		('CIVILIZATION_JFD_PRUSSIA',	'TXT_KEY_CITY_NAME_JFD_PRUSSIA_12'),
		('CIVILIZATION_JFD_PRUSSIA',	'TXT_KEY_CITY_NAME_JFD_PRUSSIA_13'),	
		('CIVILIZATION_JFD_PRUSSIA',	'TXT_KEY_CITY_NAME_JFD_PRUSSIA_14'),
		('CIVILIZATION_JFD_PRUSSIA',	'TXT_KEY_CITY_NAME_JFD_PRUSSIA_15'),
		('CIVILIZATION_JFD_PRUSSIA',	'TXT_KEY_CITY_NAME_JFD_PRUSSIA_16'),
		('CIVILIZATION_JFD_PRUSSIA',	'TXT_KEY_CITY_NAME_JFD_PRUSSIA_17'),
		('CIVILIZATION_JFD_PRUSSIA',	'TXT_KEY_CITY_NAME_JFD_PRUSSIA_18'),
		('CIVILIZATION_JFD_PRUSSIA',	'TXT_KEY_CITY_NAME_JFD_PRUSSIA_19'),
		('CIVILIZATION_JFD_PRUSSIA',	'TXT_KEY_CITY_NAME_JFD_PRUSSIA_20'),
		('CIVILIZATION_JFD_PRUSSIA',	'TXT_KEY_CITY_NAME_JFD_PRUSSIA_21'),
		('CIVILIZATION_JFD_PRUSSIA',	'TXT_KEY_CITY_NAME_JFD_PRUSSIA_22'),
		('CIVILIZATION_JFD_PRUSSIA',	'TXT_KEY_CITY_NAME_JFD_PRUSSIA_23'),
		('CIVILIZATION_JFD_PRUSSIA',	'TXT_KEY_CITY_NAME_JFD_PRUSSIA_24'),
		('CIVILIZATION_JFD_PRUSSIA',	'TXT_KEY_CITY_NAME_JFD_PRUSSIA_25'),
		('CIVILIZATION_JFD_PRUSSIA',	'TXT_KEY_CITY_NAME_JFD_PRUSSIA_26'),
		('CIVILIZATION_JFD_PRUSSIA',	'TXT_KEY_CITY_NAME_JFD_PRUSSIA_27'),
		('CIVILIZATION_JFD_PRUSSIA',	'TXT_KEY_CITY_NAME_JFD_PRUSSIA_28'),
		('CIVILIZATION_JFD_PRUSSIA',	'TXT_KEY_CITY_NAME_JFD_PRUSSIA_29'),
		('CIVILIZATION_JFD_PRUSSIA',	'TXT_KEY_CITY_NAME_JFD_PRUSSIA_30'),
		('CIVILIZATION_JFD_PRUSSIA',	'TXT_KEY_CITY_NAME_JFD_PRUSSIA_31'),
		('CIVILIZATION_JFD_PRUSSIA',	'TXT_KEY_CITY_NAME_JFD_PRUSSIA_32'),
		('CIVILIZATION_JFD_PRUSSIA',	'TXT_KEY_CITY_NAME_JFD_PRUSSIA_33');
--------------------------------	
-- Civilization_FreeBuildingClasses
--------------------------------			
INSERT INTO Civilization_FreeBuildingClasses 
		(CivilizationType, 				BuildingClassType)
SELECT	'CIVILIZATION_JFD_PRUSSIA', 	BuildingClassType
FROM Civilization_FreeBuildingClasses WHERE CivilizationType = 'CIVILIZATION_GERMANY';
--------------------------------		
-- Civilization_FreeTechs
--------------------------------			
INSERT INTO Civilization_FreeTechs 
		(CivilizationType, 				TechType)
SELECT	'CIVILIZATION_JFD_PRUSSIA', 	TechType
FROM Civilization_FreeTechs WHERE CivilizationType = 'CIVILIZATION_GERMANY';
--------------------------------	
-- Civilization_FreeUnits
--------------------------------		
INSERT INTO Civilization_FreeUnits 
		(CivilizationType, 				UnitClassType, Count, UnitAIType)
SELECT	'CIVILIZATION_JFD_PRUSSIA', 	UnitClassType, Count, UnitAIType
FROM Civilization_FreeUnits WHERE CivilizationType = 'CIVILIZATION_GERMANY';
--------------------------------	
-- Civilization_Leaders
--------------------------------		
INSERT INTO Civilization_Leaders 
		(CivilizationType, 				LeaderheadType)
VALUES	('CIVILIZATION_JFD_PRUSSIA', 	'LEADER_JFD_FREDERICK');
--------------------------------	
-- Civilization_UnitClassOverrides 
--------------------------------
INSERT INTO Civilization_UnitClassOverrides
		(CivilizationType, 			UnitClassType, 			UnitType)
SELECT	'CIVILIZATION_JFD_PRUSSIA', 'UNITCLASS_RIFLEMAN', 	'UNIT_JFD_LANDWEHR' UNION ALL
SELECT	'CIVILIZATION_JFD_PRUSSIA', 'UNITCLASS_CUIRASSIER', 'UNIT_JFD_DEATHS_HEAD';

UPDATE Civilization_UnitClassOverrides SET 
	UnitClassType =  (SELECT Class FROM Units WHERE Type= 'UNIT_EE_DRAGOON')
WHERE UnitType = 'UNIT_JFD_DEATHS_HEAD' AND EXISTS (SELECT * FROM Units WHERE Type='UNIT_EE_DRAGOON');

CREATE TRIGGER IF NOT EXISTS JarPrussiaEECompatibility04 AFTER UPDATE OF Cost ON Units
WHEN NEW.Cost = 400 AND OLD.Type = 'UNIT_EE_GALLEON'
BEGIN
	UPDATE Civilization_UnitClassOverrides SET 
		UnitClassType =  (SELECT Class FROM Units WHERE Type= 'UNIT_EE_DRAGOON')
	WHERE UnitType = 'UNIT_JFD_DEATHS_HEAD';
END;
--------------------------------	
-- Civilization_BuildingClassOverrides
--------------------------------	
INSERT INTO Civilization_BuildingClassOverrides
		(CivilizationType, 			BuildingClassType, 					BuildingType)
SELECT	'CIVILIZATION_JFD_PRUSSIA', 'BUILDINGCLASS_MILITARY_ACADEMY', 	'BUILDING_PRUSSIAN_KRIEGSSCHULE' UNION ALL
SELECT	'CIVILIZATION_JFD_PRUSSIA', 'BUILDINGCLASS_COALING_STATION', 	'BUILDING_STAATSEISENBAHN';
--------------------------------	
-- Civilization_Religions
--------------------------------			
INSERT INTO Civilization_Religions 
		(CivilizationType, 				ReligionType)
SELECT	'CIVILIZATION_JFD_PRUSSIA', 	ReligionType			
FROM Civilization_Religions WHERE CivilizationType = 'CIVILIZATION_GERMANY';	
--------------------------------	
-- Civilization_SpyNames
--------------------------------	
INSERT INTO Civilization_SpyNames 
		(CivilizationType, 				SpyName)
VALUES	('CIVILIZATION_JFD_PRUSSIA', 	'TXT_KEY_SPY_NAME_JFD_PRUSSIA_0'),	
		('CIVILIZATION_JFD_PRUSSIA', 	'TXT_KEY_SPY_NAME_JFD_PRUSSIA_1'),
		('CIVILIZATION_JFD_PRUSSIA', 	'TXT_KEY_SPY_NAME_JFD_PRUSSIA_2'),
		('CIVILIZATION_JFD_PRUSSIA', 	'TXT_KEY_SPY_NAME_JFD_PRUSSIA_3'),
		('CIVILIZATION_JFD_PRUSSIA', 	'TXT_KEY_SPY_NAME_JFD_PRUSSIA_4'),
		('CIVILIZATION_JFD_PRUSSIA', 	'TXT_KEY_SPY_NAME_JFD_PRUSSIA_5'),
		('CIVILIZATION_JFD_PRUSSIA', 	'TXT_KEY_SPY_NAME_JFD_PRUSSIA_6'),
		('CIVILIZATION_JFD_PRUSSIA', 	'TXT_KEY_SPY_NAME_JFD_PRUSSIA_7'),
		('CIVILIZATION_JFD_PRUSSIA', 	'TXT_KEY_SPY_NAME_JFD_PRUSSIA_8'),
		('CIVILIZATION_JFD_PRUSSIA', 	'TXT_KEY_SPY_NAME_JFD_PRUSSIA_9');
--------------------------------------------------------------------------------------------------------------------------
-- Civilization_Start_Region_Avoid
--------------------------------------------------------------------------------------------------------------------------
INSERT INTO Civilization_Start_Region_Avoid
		(CivilizationType, 				RegionType)
VALUES	('CIVILIZATION_JFD_PRUSSIA', 	'REGION_JUNGLE'),
		('CIVILIZATION_JFD_PRUSSIA', 	'REGION_DESERT');
--==========================================================================================================================
--==========================================================================================================================