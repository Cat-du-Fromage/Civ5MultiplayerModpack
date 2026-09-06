UPDATE Units SET PrereqTech = 'TECH_EE_ROMANTICISM' WHERE Class = 'UNITCLASS_DIPLOMAT';
UPDATE Units SET ObsoleteTech = 'TECH_EE_ROMANTICISM' WHERE Class = 'UNITCLASS_ENVOY';

INSERT INTO Improvement_TechFreshWaterYieldChanges
	(ImprovementType, TechType, YieldType, Yield)
VALUES
	('IMPROVEMENT_TRADING_POST', 'TECH_STEAM_POWER', 'YIELD_GOLD', 3);

INSERT INTO Improvement_TechNoFreshWaterYieldChanges
	(ImprovementType, TechType, YieldType, Yield)
VALUES
	('IMPROVEMENT_FARM', 'TECH_FERTILIZER', 'YIELD_FOOD', 1);
