-- JFD_Prussia_Functions
-- Author: JFD
-- DateCreated: 5/4/2014 12:54:31 AM
--==========================================================================================================================
-- INCLUDES
--==========================================================================================================================
--include("PlotIterators")
--==========================================================================================================================
-- UTILITY FUNCTIONS
--==========================================================================================================================
-- GLOBALS
----------------------------------------------------------------------------------------------------------------------------

--==========================================================================================================================
-- UNIQUE FUNCTIONS
--==========================================================================================================================
-- GLOBAL
----------------------------------------------------------------------------------------------------------------------------
--[[local activePlayerID                   = Game.GetActivePlayer()
local activePlayer	                   = Players[activePlayerID]
local mathCeil		                   = math.ceil

local traitPrussiaID                   = GameInfoTypes["TRAIT_JFD_PRUSSIA"]
local policyPrussiaHohendriedbergMarch = GameInfoTypes["POLICY_JFD_PRUSSIA"]
----------------------------------------------------------------------------------------------------------------------------
-- PRUSSIAN UA -- edited from code snippet by Enginseer (using CPDLL hooks only) (this is fine because VP is the mod's dependency)
----------------------------------------------------------------------------------------------------------------------------
function Prussia_HohenfriedbergMarch()
    for iPlayerLoop = 0, GameDefines.MAX_MAJOR_CIVS-1, 1 do
        local pPlayer = Players[iPlayerLoop]
        if (pPlayer:HasTrait(traitPrussiaID)) then
            pPlayer:GrantPolicy(policyPrussiaHohendriedbergMarch, true)
        end
    end
end

if (Modding.OpenSaveData().GetValue("Prussia_HohenfriedbergMarch_PolicySet") == nil) then
    Prussia_HohenfriedbergMarch()
    Modding.OpenSaveData().SetValue("Prussia_HohenfriedbergMarch_PolicySet", 1)
end]]
--=======================================================================================================================
--=======================================================================================================================
