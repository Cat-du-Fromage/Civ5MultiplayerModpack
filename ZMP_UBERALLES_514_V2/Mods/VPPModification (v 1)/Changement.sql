-- support VP
--==========================================================================================================================
-- GAZEBO COMMUNITY PATCH
--==========================================================================================================================
-- COMMUNITY
------------------------------------------------------------
--CREATE TABLE IF NOT EXISTS COMMUNITY (Type TEXT, Value INTEGER);

--Dummy Policies

--INSERT INTO COMMUNITY (Type, Value)
--VALUES ('CBPMC_MORERELIGION', 1);


UPDATE GameSpeeds SET ResearchPercent = '110' WHERE Type = 'GAMESPEED_STANDARD';
--UPDATE Build_TechTimeChanges SET TimeChange = '-100' WHERE TechType = 'TECH_MACHINERY';
--UPDATE Buildings SET AllowsProductionTradeRoutes = '1' WHERE Type = 'BUILDING_FORGE';
--UPDATE Buildings SET AllowsProductionTradeRoutes = '1' WHERE BuildingClass = 'BUILDINGCLASS_FORGE';

INSERT INTO Build_TechTimeChanges
			("BuildType", "TechType", "TimeChange")
VALUES		('BUILD_REMOVE_JUNGLE', 'TECH_POTTERY', '-200'),
			('BUILD_REMOVE_FOREST', 'TECH_POTTERY', '-200'),
			('BUILD_REMOVE_MARSH',	'TECH_POTTERY', '-200');

--NO FUTUR UNITS
--DELETE FROM UnitClasses WHERE Type = 'UNITCLASS_XCOM_SQUAD';
--Autocracy Balance

--UPDATE Policies SET VassalsNoRebel = 'false' WHERE Type = 'POLICY_UNIVERSAL_HEALTHCARE_A';
--UPDATE Policies SET VassalCSBonusModifier = '30' WHERE Type = 'POLICY_UNIVERSAL_HEALTHCARE_A';

--Era tech changes

--UPDATE Eras SET ResearchPercent = '25' WHERE Type = 'ERA_MEDIEVAL';
--UPDATE Eras SET ResearchPercent = '20' WHERE Type = 'ERA_RENAISSANCE';
--UPDATE Eras SET ResearchPercent = '15' WHERE Type = 'ERA_INDUSTRIAL';
--UPDATE Eras SET ResearchPercent = '10' WHERE Type = 'ERA_MODERN';
--UPDATE Eras SET ResearchPercent = '5' WHERE Type = 'ERA_POSTMODERN';
--UPDATE Eras SET ResearchPercent = '20' WHERE Type = 'ERA_FUTURE';

--Nuclear Weapon changes
UPDATE Units SET Cost = '5500' WHERE Type = 'UNIT_ATOMIC_BOMB';
UPDATE Units SET Cost = '10000' WHERE Type = 'UNIT_NUCLEAR_MISSILE';


UPDATE GameSpeeds SET DealDuration = '30' WHERE Type = 'GAMESPEED_STANDARD';
UPDATE GameSpeeds SET MinimumVassalLiberateTurns = '10' WHERE Type = 'GAMESPEED_STANDARD';
UPDATE GameSpeeds SET MinimumVassalTurns = '10' WHERE Type = 'GAMESPEED_STANDARD';

--WORLD

UPDATE Worlds SET NumNaturalWonders = '10' WHERE Type = 'WORLDSIZE_HUGE';
UPDATE Worlds SET NumNaturalWonders = '8' WHERE Type = 'WORLDSIZE_LARGE';

--UPDATE Worlds SET TargetNumCities = '7' WHERE Type = 'WORLDSIZE_HUGE';
--UPDATE Worlds SET EstimatedNumCities = '156' WHERE Type = 'WORLDSIZE_HUGE';

--AMBRE

INSERT INTO Resource_YieldChangeFromMonopoly
			(ResourceType,				YieldType,				Yield)
VALUES		('RESOURCE_AMBER',			'YIELD_CULTURE',		'2');

UPDATE Resources SET MonopolyHappiness = '0' WHERE Type = 'RESOURCE_AMBER';
UPDATE Resources SET Help = 'TXT_KEY_RESOURCE_MONOPOLY_YIELD_CULTURE' WHERE Type = 'RESOURCE_AMBER';

--WORLD

UPDATE Worlds SET NumCitiesTechCostMod = '6' WHERE Type = 'WORLDSIZE_HUGE';
UPDATE Worlds SET NumCitiesTechCostMod = '6' WHERE Type = 'WORLDSIZE_LARGE';

UPDATE Worlds SET NumCitiesPolicyCostMod = '6' WHERE Type = 'WORLDSIZE_HUGE';
UPDATE Worlds SET NumCitiesPolicyCostMod = '6' WHERE Type = 'WORLDSIZE_LARGE';

--CHANGE MAX RELIGION

UPDATE Defines SET Value = 100 WHERE Name = 'RELIGION_MAXIMUM_PER_PLAYER_DIVISOR';
UPDATE Defines SET Value = 12 WHERE Name = 'RELIGION_MAXIMUM_CAP';

UPDATE Worlds SET MaxActiveReligions = 10 WHERE Type = 'WORLDSIZE_HUGE';
UPDATE Worlds SET MaxActiveReligions = 10 WHERE Type = 'WORLDSIZE_LARGE';

--HONNOR Balance

INSERT INTO Policy_YieldFromBorderGrowth
	(PolicyType, YieldType, Yield)
VALUES
	('POLICY_DISCIPLINE', 'YIELD_CULTURE', 15),
	('POLICY_HONOR_FINISHER', 'YIELD_CULTURE', 15);

--Buff Pioneer
--INSERT INTO Unit_BuildOnFound
--		("UnitType",		"BuildingClassType") 
--VALUES	('UNIT_PIONEER', 'BUILDINGCLASS_WALLS'),
--		('UNIT_PIONEER', 'BUILDINGCLASS_HERBALIST'),
--		('UNIT_PIONEER', 'BUILDINGCLASS_COLOSSEUM'),
--		('UNIT_PIONEER', 'BUILDINGCLASS_CARAVANSARY'),
--		('UNIT_PIONEER', 'BUILDINGCLASS_TEMPLE'),
--		('UNIT_PIONEER', 'BUILDINGCLASS_LIGHTHOUSE'),
--		('UNIT_PIONEER', 'BUILDINGCLASS_BATH'),
--		('UNIT_PIONEER', 'BUILDINGCLASS_AMPHITHEATER'),
--		('UNIT_PIONEER', 'BUILDINGCLASS_AQUEDUCT');

UPDATE Worlds
SET MaxActiveReligions = 10
WHERE Type = 'WORLDSIZE_HUGE' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE' AND Value= 1 );
UPDATE Worlds
SET MaxActiveReligions = 10
WHERE Type = 'WORLDSIZE_LARGE' AND EXISTS (SELECT * FROM COMMUNITY WHERE Type='COMMUNITY_CORE_BALANCE' AND Value= 1 );





