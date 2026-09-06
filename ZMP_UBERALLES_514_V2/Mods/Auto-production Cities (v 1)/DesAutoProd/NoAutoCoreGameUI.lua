--============================================================
--AUTOMATISER DIEGO
--============================================================
function OnEnterCityScreenNoAuto()

local pSelectedCity = UI.GetHeadSelectedCity()
local iSelectedCity = pSelectedCity:GetID()

		if pSelectedCity:IsProductionAutomated() == false or pSelectedCity:IsPuppet() then
		ContextPtr:SetHide(true)
		elseif pSelectedCity:IsProductionAutomated() == true then
		ContextPtr:SetHide(false)
		end
end
Events.SerialEventEnterCityScreen.Add(OnEnterCityScreenNoAuto)
--============================================================
--Cache l'onglet quand on sort de la ville
--============================================================
function OnExitCityScreenNoAuto()
ContextPtr:SetHide(true)
end
Events.SerialEventExitCityScreen.Add(OnExitCityScreenNoAuto)
Events.SerialEventDawnOfManHide.Add(OnExitCityScreenNoAuto)
--============================================================
--Met la ville en puppet quand on click sur l'onglet
--============================================================
function InitNoAuto()

local pSelectedCity = UI.GetHeadSelectedCity()
local iSelectedCity = pSelectedCity:GetID()

	Network.SendDoTask(iSelectedCity, TaskTypes.TASK_SET_AUTOMATED_PRODUCTION, -1, -1, false, false, false, false)
	pSelectedCity:SetProductionAutomated(false)
	ContextPtr:SetHide(true)

end
Controls.NoAutoCity:RegisterCallback(Mouse.eLClick, InitNoAuto)