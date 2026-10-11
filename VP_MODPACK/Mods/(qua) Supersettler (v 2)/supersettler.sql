CREATE TRIGGER SuperSettler
AFTER INSERT ON Civilization_FreeUnits
WHEN NEW.UnitClassType = 'UNITCLASS_SETTLER'

BEGIN
  
  UPDATE Civilization_FreeUnits SET UnitClassType = 'UNITCLASS_SUPERSETTLER'
    WHERE UnitClassType = 'UNITCLASS_SETTLER';

END;
