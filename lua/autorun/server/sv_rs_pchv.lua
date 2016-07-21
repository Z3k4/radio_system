	local function CanPlayerHearVoice(player,talker)
		if talker:GetActiveWeapon():GetClass() == "radio_system" && talker:GetActiveWeapon():GetEnabled() then
			if player:GetActiveWeapon():GetClass() == "radio_system" then
				local pfrequence = player:GetActiveWeapon():GetFrequence()
				local tfrequence = talker:GetActiveWeapon():GetFrequence()
				if pfrequence == tfrequence then
					return true, false
				else
					return false
				end
			else
				return false
			end
		end
	end

	hook.Add("PlayerCanHearPlayersVoice","RS_PlayerCanHearVoice",CanPlayerHearVoice)