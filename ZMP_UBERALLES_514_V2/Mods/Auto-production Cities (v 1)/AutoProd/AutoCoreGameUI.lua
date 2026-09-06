--============================================================
--AUTOMATISER DIEGO
--============================================================
function OnEnterCityScreenAutoCity()

local pSelectedCity = UI.GetHeadSelectedCity()
local iSelectedCity = pSelectedCity:GetID()

		if pSelectedCity:IsProductionAutomated() == true or pSelectedCity:IsPuppet() then
		ContextPtr:SetHide(true)
		elseif pSelectedCity:IsProductionAutomated() == false then
		ContextPtr:SetHide(false)
		end
end
Events.SerialEventEnterCityScreen.Add(OnEnterCityScreenAutoCity)
--============================================================
--Cache l'onglet quand on sort de la ville
--============================================================
function OnExitCityScreenAutoCity()
ContextPtr:SetHide(true)
end
Events.SerialEventExitCityScreen.Add(OnExitCityScreenAutoCity)
Events.SerialEventDawnOfManHide.Add(OnExitCityScreenAutoCity)
--============================================================
--Met la ville en puppet quand on click sur l'onglet
--============================================================
function InitAutoCity()
local pSelectedCity = UI.GetHeadSelectedCity()
local iSelectedCity = pSelectedCity:GetID()
	Network.SendDoTask(iSelectedCity, TaskTypes.TASK_SET_AUTOMATED_PRODUCTION, -1, -1, true, false, false, false)
	pSelectedCity:SetProductionAutomated(true)
	--pSelectedCity:ClearOrderQueue()
	ContextPtr:SetHide(true)
end
Controls.AutoCity:RegisterCallback(Mouse.eLClick, InitAutoCity)