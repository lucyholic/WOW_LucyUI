MainMenuBarLeftEndCap:Hide();
MainMenuBarRightEndCap:Hide();
SetCVar("TargetNearestUseNew", 0)

print(" ** 웰컴투상잉 **")
print("상잉UI by 루씨낭자")
print("ㄴv0.1")

local Congrats_EventFrame = CreateFrame("Frame", "CongratsFrame")
Congrats_EventFrame:RegisterEvent("PLAYER_LEVEL_UP")

Congrats_EventFrame:SetScript("OnEvent",
	function(self, event, ...)
		local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9 = ...
			print('축하합니다, ' ..UnitName("Player").. '! ' ..arg1.. '레벨이 되었습니다!')
			print('체력 ' ..arg2.. ', 마나 ' ..arg3..'만큼 늘었습니다!')
	end)

-- 무작 탱힐 징표
	
local LFGButton = CreateFrame("Button", "LFGButton", UIParent, "OptionsButtonTemplate")

LFGButton:SetText("무작인던 징표")
LFGButton:SetPoint("BOTTOMRIGHT")

function OnClick_LFGButton()
    local roles = { 
		["player"] = UnitGroupRolesAssigned("player"), 
		["party1"] = UnitGroupRolesAssigned("party1"), 
		["party2"] = UnitGroupRolesAssigned("party2"), 
		["party3"] = UnitGroupRolesAssigned("party3"), 
		["party4"] = UnitGroupRolesAssigned("party4") 
	};
	
	if (IsInLFGDungeon()) then
		SendChatMessage('ㅎㅇㅎㅇ', "INSTANCE_CHAT")
		for k,v in pairs(roles) do 
			print(UnitName(k).. ': ' ..v)
			if (v == "TANK") then
				SetRaidTarget(k, 6)
			elseif (v == "HEALER") then
				SetRaidTarget(k, 5)
			end	
		end
	end
end

LFGButton:SetScript("OnClick", OnClick_LFGButton)


-- 차단 및 해제 알림메시지 출력

local cast = CreateFrame("Frame")
cast:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")


-- 서버명 제거
local function Target(name)
	if name ~= nil then
		if string.find(name, "-") then
			return string.sub(name, 0, string.find(name, "-") - 1)
		else
			return name
		end
	else
		return UnitName("Player")
	end
end

local function Cast_event(_, _, _, combatEvent, _, _, sourceName, _, _, _, destName, _, _, spellID, spellName, _, xSpellID)
	local ListSpells = {
		-- 뎀감기
		["희생의 축복"] = true,
		["고통 억제"] = true,
		["수호 영혼"] = true,
		["기의 고치"] = true,
		["무쇠껍질"] = true,
		
		-- 공생기
		["평온"] = true,
		["재활"] = true,
		["오라 숙련"] = true,
		["신의 권능: 방벽"] = true,		
		["치유의 해일 토템"] = true,
		["정신의 고리 토템"] = true,
		["흡혈의 선물"] = true,
		["천상의 찬가"] = true,
		["고대의 인도"] = true,
		
		-- 성기사 축복류
		["보호의 축복"] = true,
		["신의 축복"] = true,
		["자유의 축복"] = true,
		["주문 수호의 축복"] = true,
		["빛의 봉화"] = true,
		["신념의 봉화"] = true,
		
		-- 회드 마나스킬
		["정신 자극"] = true,
		
		-- 블러드
		["피의 욕망"] = true,
		["시간 왜곡"] = true,
		
		-- 눈속/속거
		["눈속임"] = true;
		["속임수 거래"] = true;
	}
	
	local Messages = { }
	
	if sourceName == UnitName("Player") then	
		if combatEvent == "SPELL_INTERRUPT" or combatEvent == "SPELL_DISPEL" then		
			--SendChatMessage(GetSpellLink(spellID).. " -> " ..Target(destName).. "의 " ..GetSpellLink(xSpellID), "INSTANCE_CHAT")
			print(GetSpellLink(spellID).. " -> " ..Target(destName).. "의 " ..GetSpellLink(xSpellID))
		elseif (combatEvent == "SPELL_RESURRECT" and UnitAffectingCombat("Player")) or (combatEvent == "SPELL_CAST_SUCCESS" and ListSpells[spellName]) then
			--SendChatMessage(GetSpellLink(spellID).. " -> " ..Target(destName), "INSTANCE_CHAT")
			print(GetSpellLink(spellID).. " -> " ..Target(destName))
		end
	end
end

cast:SetScript("OnEvent", Cast_event)
