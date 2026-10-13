--==========================================================================================================================
-- GAZEBO COMMUNITY PATCH
--==========================================================================================================================
-- COMMUNITY
------------------------------------------------------------
CREATE TABLE IF NOT EXISTS COMMUNITY (Type TEXT, Value INTEGER);
--==========================================================================================================================
-- TOMATEKH HISTORICAL RELIGIONS
--==========================================================================================================================
-- Civilization_Religions
------------------------------
UPDATE Civilization_Religions 
SET ReligionType = 'RELIGION_PROTESTANT_CALVINISM'
WHERE CivilizationType = 'CIVILIZATION_JFD_PRUSSIA'
AND EXISTS (SELECT * FROM Religions WHERE Type = 'RELIGION_PROTESTANT_CALVINISM');
--==========================================================================================================================
--==========================================================================================================================
-- GEDEMON R.E.D.
------------------------------	
UPDATE Civilizations SET ArtStyleSuffix = '_GERMANY'
WHERE Type = 'CIVILIZATION_JFD_PRUSSIA' AND EXISTS (SELECT * FROM Civilizations WHERE ArtStyleSuffix = '_GERMANY');
--==========================================================================================================================
-- HAZEL MAP LABELS
--==========================================================================================================================
-- ML_CivCultures
------------------------------	
CREATE TABLE IF NOT EXISTS ML_CivCultures (ID INTEGER PRIMARY KEY AUTOINCREMENT, CivType TEXT, CultureType TEXT, CultureEra TEXT DEFAULT 'ANY');
INSERT INTO ML_CivCultures
		(CivType,						CultureType,	CultureEra)
VALUES	('CIVILIZATION_JFD_PRUSSIA',	'GERMANIC',		'ANY');
--==========================================================================================================================
-- Civilization_JFD_CultureTypes
--==========================================================================================================================	
CREATE TABLE IF NOT EXISTS Civilization_JFD_CultureTypes(CivilizationType, CultureType, SubCultureType, ArtDefineTag, DecisionsTag, DefeatScreenEarlyTag, DefeatScreenMidTag, DefeatScreenLateTag, IdealsTag, SplashScreenTag,	SoundtrackTag, UnitDialogueTag);
INSERT INTO Civilization_JFD_CultureTypes
		(CivilizationType,			ArtDefineTag, CultureType, DefeatScreenEarlyTag, DefeatScreenMidTag, 			DefeatScreenLateTag, 			IdealsTag, SplashScreenTag, SoundtrackTag, UnitDialogueTag)
SELECT	'CIVILIZATION_JFD_PRUSSIA',	ArtDefineTag, CultureType, DefeatScreenEarlyTag, 'DefeatScreenMidPrussia.dds',	'DefeatScreenLatePrussia.dds', 	IdealsTag, SplashScreenTag, SoundtrackTag, UnitDialogueTag
FROM Civilization_JFD_CultureTypes WHERE CivilizationType = 'CIVILIZATION_GERMANY';
--==========================================================================================================================
-- Civilizations_YnAEMP
--==========================================================================================================================	
CREATE TABLE IF NOT EXISTS Civilizations_YnAEMP(CivilizationType, MapPrefix, X, Y, CapitalName, AltX, AltY, AltCapitalName);
INSERT INTO Civilizations_YnAEMP
		(CivilizationType,					MapPrefix,			X,		Y,		AltX,	AltY,	AltCapitalName)
VALUES	('CIVILIZATION_JFD_PRUSSIA',		'Cordiform',		41,		35,		null,	null,	null),
		('CIVILIZATION_JFD_PRUSSIA',		'EarthMk3',			29,		71,		null,	null,	null),
		('CIVILIZATION_JFD_PRUSSIA',		'EuroLarge',		45,		52,		null,	null,	null),
		('CIVILIZATION_JFD_PRUSSIA',		'EuroLargeNew',		49,		54,		null,	null,	null),
		('CIVILIZATION_JFD_PRUSSIA',		'GreatestEarth',	56,		57,		null,	null,	null),
		('CIVILIZATION_JFD_PRUSSIA',		'NorthAtlantic',	94,		44,		null,	null,	null),
		('CIVILIZATION_JFD_PRUSSIA',		'NorthWestEurope',	48,		27,		null,	null,	null),
		('CIVILIZATION_JFD_PRUSSIA',		'Yagem',			29,		72,		null,	null,	null),
		('CIVILIZATION_JFD_PRUSSIA',		'Yahem',			67,		63,		null,	null,	null);
------------------------------------------------------------------------------------------------------------------------	
-- Civilizations_YnAEMPRequestedResource
------------------------------------------------------------------------------------------------------------------------	
INSERT INTO Civilizations_YnAEMPRequestedResource
		(CivilizationType,			MapPrefix, Req1, Yield1, Req2, Yield2, Req3, Yield3, Req4, Yield4)
SELECT	'CIVILIZATION_JFD_PRUSSIA',	MapPrefix, Req1, Yield1, Req2, Yield2, Req3, Yield3, Req4, Yield4
FROM Civilizations_YnAEMPRequestedResource WHERE CivilizationType = 'CIVILIZATION_GERMANY';
--==========================================================================================================================
--==========================================================================================================================