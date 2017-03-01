local ver = "0.01"


if FileExist(COMMON_PATH.."MixLib.lua") then
 require('MixLib')
else
 PrintChat("MixLib not found. Please wait for download.")
 DownloadFileAsync("https://raw.githubusercontent.com/VTNEETS/NEET-Scripts/master/MixLib.lua", COMMON_PATH.."MixLib.lua", function() PrintChat("Downloaded MixLib. Please 2x F6!") return end)
end


if GetObjectName(GetMyHero()) ~= "Fiora" then return end


require("DamageLib")

function AutoUpdate(data)
    if tonumber(data) > tonumber(ver) then
        PrintChat('<font color = "#00FFFF">New version found! ' .. data)
        PrintChat('<font color = "#00FFFF">Downloading update, please wait...')
        DownloadFileAsync('https://raw.githubusercontent.com/allwillburn/Fiora/master/Fiora.lua', SCRIPT_PATH .. 'Fiora.lua', function() PrintChat('<font color = "#00FFFF">Update Complete, please 2x F6!') return end)
    else
        PrintChat('<font color = "#00FFFF">No updates found!')
    end
end

GetWebResultAsync("https://raw.githubusercontent.com/allwillburn/Fiora/master/Fiora.version", AutoUpdate)


GetLevelPoints = function(unit) return GetLevel(unit) - (GetCastLevel(unit,0)+GetCastLevel(unit,1)+GetCastLevel(unit,2)+GetCastLevel(unit,3)) end
local SetDCP, SkinChanger = 0

local FioraMenu = Menu("Fiora", "Fiora")

FioraMenu:SubMenu("Combo", "Combo")

FioraMenu.Combo:Boolean("Q", "Use Q in combo", true)
FioraMenu.Combo:Boolean("W", "Use W in combo", true)
FioraMenu.Combo:Boolean("E", "Use E in combo", true)
FioraMenu.Combo:Boolean("R", "Use R in combo", true)
FioraMenu.Combo:Slider("RX", "X Enemies to Cast R",3,1,5,1)
FioraMenu.Combo:Boolean("Cutlass", "Use Cutlass", true)
FioraMenu.Combo:Boolean("Tiamat", "Use Tiamat", true)
FioraMenu.Combo:Boolean("BOTRK", "Use BOTRK", true)
FioraMenu.Combo:Boolean("RHydra", "Use RHydra", true)
FioraMenu.Combo:Boolean("YGB", "Use GhostBlade", true)
FioraMenu.Combo:Boolean("Gunblade", "Use Gunblade", true)
FioraMenu.Combo:Boolean("Randuins", "Use Randuins", true)


FioraMenu:SubMenu("AutoMode", "AutoMode")
FioraMenu.AutoMode:Boolean("Level", "Auto level spells", false)
FioraMenu.AutoMode:Boolean("Ghost", "Auto Ghost", false)
FioraMenu.AutoMode:Boolean("Q", "Auto Q", false)
FioraMenu.AutoMode:Boolean("W", "Auto W", false)
FioraMenu.AutoMode:Boolean("E", "Auto E", false)
FioraMenu.AutoMode:Boolean("R", "Auto R", false)

FioraMenu:SubMenu("LaneClear", "LaneClear")
FioraMenu.LaneClear:Boolean("Q", "Use Q", true)
FioraMenu.LaneClear:Boolean("W", "Use W", true)
FioraMenu.LaneClear:Boolean("E", "Use E", true)
FioraMenu.LaneClear:Boolean("RHydra", "Use RHydra", true)
FioraMenu.LaneClear:Boolean("Tiamat", "Use Tiamat", true)

FioraMenu:SubMenu("Harass", "Harass")
FioraMenu.Harass:Boolean("Q", "Use Q", true)
FioraMenu.Harass:Boolean("W", "Use W", true)

FioraMenu:SubMenu("KillSteal", "KillSteal")
FioraMenu.KillSteal:Boolean("Q", "KS w Q", true)
FioraMenu.KillSteal:Boolean("E", "KS w E", true)

FioraMenu:SubMenu("AutoIgnite", "AutoIgnite")
FioraMenu.AutoIgnite:Boolean("Ignite", "Ignite if killable", true)

FioraMenu:SubMenu("Drawings", "Drawings")
FioraMenu.Drawings:Boolean("DQ", "Draw Q Range", true)

FioraMenu:SubMenu("SkinChanger", "SkinChanger")
FioraMenu.SkinChanger:Boolean("Skin", "UseSkinChanger", true)
FioraMenu.SkinChanger:Slider("SelectedSkin", "Select A Skin:", 1, 0, 4, 1, function(SetDCP) HeroSkinChanger(myHero, SetDCP)  end, true)

OnTick(function (myHero)
	local target = GetCurrentTarget()
        local YGB = GetItemSlot(myHero, 3142)
	local RHydra = GetItemSlot(myHero, 3074)
	local Tiamat = GetItemSlot(myHero, 3077)
        local Gunblade = GetItemSlot(myHero, 3146)
        local BOTRK = GetItemSlot(myHero, 3153)
        local Cutlass = GetItemSlot(myHero, 3144)
        local Randuins = GetItemSlot(myHero, 3143)

	--AUTO LEVEL UP
	if FioraMenu.AutoMode.Level:Value() then

			spellorder = {_E, _W, _Q, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E}
			if GetLevelPoints(myHero) > 0 then
				LevelSpell(spellorder[GetLevel(myHero) + 1 - GetLevelPoints(myHero)])
			end
	end
        
        --Harass
          if Mix:Mode() == "Harass" then
            if FioraMenu.Harass.Q:Value() and Ready(_Q) and ValidTarget(target, 400) then
				if target ~= nil then 
                                       CastSkillShot(_Q, target)
                                end
            end

            if FioraMenu.Harass.W:Value() and Ready(_W) and ValidTarget(target, 750) then
				CastSkillShot(_W, target)
            end     
          end

	--COMBO
	  if Mix:Mode() == "Combo" then
            if FioraMenu.Combo.YGB:Value() and YGB > 0 and Ready(YGB) and ValidTarget(target, 700) then
			CastSpell(YGB)
            end

            if FioraMenu.Combo.Randuins:Value() and Randuins > 0 and Ready(Randuins) and ValidTarget(target, 500) then
			CastSpell(Randuins)
            end

            if FioraMenu.Combo.BOTRK:Value() and BOTRK > 0 and Ready(BOTRK) and ValidTarget(target, 550) then
			 CastTargetSpell(target, BOTRK)
            end

            if FioraMenu.Combo.Cutlass:Value() and Cutlass > 0 and Ready(Cutlass) and ValidTarget(target, 700) then
			 CastTargetSpell(target, Cutlass)
            end

            if FioraMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 400) then
			 CastSpell(_E)
	    end

            if FioraMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 400) then
		     if target ~= nil then 
                         CastSkillShot(_Q, target)
                     end
            end

            if FioraMenu.Combo.Tiamat:Value() and Tiamat > 0 and Ready(Tiamat) and ValidTarget(target, 350) then
			CastSpell(Tiamat)
            end

            if FioraMenu.Combo.Gunblade:Value() and Gunblade > 0 and Ready(Gunblade) and ValidTarget(target, 700) then
			CastTargetSpell(target, Gunblade)
            end

            if FioraMenu.Combo.RHydra:Value() and RHydra > 0 and Ready(RHydra) and ValidTarget(target, 400) then
			CastSpell(RHydra)
            end

	    if FioraMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 700) then
			CastSkillShot(_W, target)
	    end
	    
	    
            if FioraMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target, 500) and (EnemiesAround(myHeroPos(), 700) >= FioraMenu.Combo.RX:Value()) then
			CastSpell(_R)
            end

          end

         --AUTO IGNITE
	for _, enemy in pairs(GetEnemyHeroes()) do
		
		if GetCastName(myHero, SUMMONER_1) == 'SummonerDot' then
			 Ignite = SUMMONER_1
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end

		elseif GetCastName(myHero, SUMMONER_2) == 'SummonerDot' then
			 Ignite = SUMMONER_2
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end
		end

	end

        for _, enemy in pairs(GetEnemyHeroes()) do
                
                if IsReady(_Q) and ValidTarget(enemy, 700) and FioraMenu.KillSteal.Q:Value() and GetHP(enemy) < getdmg("Q",enemy) then
		         if target ~= nil then 
                                       CastSkillShot(_Q, target)
		         end
                end 

                if IsReady(_E) and ValidTarget(enemy, 187) and FioraMenu.KillSteal.E:Value() and GetHP(enemy) < getdmg("E",enemy) then
		                      CastSpell(_E)
  
                end
      end

      if Mix:Mode() == "LaneClear" then
      	  for _,closeminion in pairs(minionManager.objects) do
	        if FioraMenu.LaneClear.Q:Value() and Ready(_Q) and ValidTarget(closeminion, 700) then
	        	CastSkillShot(closeminion, _Q)
                end

                if FioraMenu.LaneClear.W:Value() and Ready(_W) and ValidTarget(closeminion, 700) then
	        	CastSkillShot(_W, target)
	        end

                if FioraMenu.LaneClear.E:Value() and Ready(_E) and ValidTarget(closeminion, 187) then
	        	CastSpell(_E)
	        end

                if FioraMenu.LaneClear.Tiamat:Value() and ValidTarget(closeminion, 350) then
			CastSpell(Tiamat)
		end
	
		if FioraMenu.LaneClear.RHydra:Value() and ValidTarget(closeminion, 400) then
                        CastTargetSpell(closeminion, RHydra)
      	        end
          end
      end
        --AutoMode
        if FioraMenu.AutoMode.Q:Value() then        
          if Ready(_Q) and ValidTarget(target, 400) then
		       CastSkillShot(_Q, target)
          end
        end 
        if FioraMenu.AutoMode.W:Value() then        
          if Ready(_W) and ValidTarget(target, 700) then
	  	      CastSpell(_W)
          end
        end
        if FioraMenu.AutoMode.E:Value() then        
	  if Ready(_E) and ValidTarget(target, 400) then
		      CastSpell(_E)
	  end
        end
        if FioraMenu.AutoMode.R:Value() then        
	  if Ready(_R) and ValidTarget(target, 500) then
		     CastSpell(_R)
	  end
        end
                
	--AUTO GHOST
	if FioraMenu.AutoMode.Ghost:Value() then
		if GetCastName(myHero, SUMMONER_1) == "SummonerHaste" and Ready(SUMMONER_1) then
			CastSpell(SUMMONER_1)
		elseif GetCastName(myHero, SUMMONER_2) == "SummonerHaste" and Ready(SUMMONER_2) then
			CastSpell(Summoner_2)
		end
	end
end)

OnDraw(function (myHero)
        
         if FioraMenu.Drawings.DQ:Value() then
		DrawCircle(GetOrigin(myHero), 400, 0, 200, GoS.Red)
	end

end)


OnProcessSpell(function(unit, spell)
	local target = GetCurrentTarget()        
       
        if unit.isMe and spell.name:lower():find("Fioraempowertwo") then 
		Mix:ResetAA()	
	end        

        if unit.isMe and spell.name:lower():find("itemtiamatcleave") then
		Mix:ResetAA()
	end	
               
        if unit.isMe and spell.name:lower():find("itemravenoushydracrescent") then
		Mix:ResetAA()
	end

end) 


local function SkinChanger()
	if FioraMenu.SkinChanger.UseSkinChanger:Value() then
		if SetDCP >= 0  and SetDCP ~= GlobalSkin then
			HeroSkinChanger(myHero, SetDCP)
			GlobalSkin = SetDCP
		end
        end
end


print('<font color = "#01DF01"><b>Fiora</b> <font color = "#01DF01">by <font color = "#01DF01"><b>Allwillburn</b> <font color = "#01DF01">Loaded!')





