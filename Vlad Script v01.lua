if myHero.charName ~= "Vladimir" then return end
require 'VPrediction'
local ts
myHero = GetMyHero()
AARange = 510
QRange = 600
ERange = 610
RRange = 700
local OldHP = {0,0,0,0,0,0,0,0,0,0}
local ChampDMG = {0,0,0,0,0,0,0,0,0,0}
local lastDMGtick = {0,0,0,0,0,0,0,0,0,0}
local nextTick=0
local VP = nil
function OnLoad()
VP = VPrediction() --Inserisce il VPrediction
-- aggiustare il range
ts = TargetSelector(TARGET_LOW_HP_PRIORITY,700)
--Config:addParam(parameter_name, description, parameter_type, initial_state,key_code_if_needed)
Config = scriptConfig("The Vladimir Beta 0.01", "Vladbeta")
Config:addSubMenu("Drawing Settings", "drawset")
Config.drawset:addParam("drawCircleAA", "AA Range", SCRIPT_PARAM_ONOFF, true)
Config.drawset:addParam("drawCircleQ", "Q Range", SCRIPT_PARAM_ONOFF, true)
Config.drawset:addParam("drawCircleE", "E Range", SCRIPT_PARAM_ONOFF, true)
Config.drawset:addParam("drawCircleR", "R Range", SCRIPT_PARAM_ONOFF, true)
	Config:addSubMenu("Combo Settings", "comboset")
	Config.comboset:addParam("combo", "Combo madafakka", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		Config:addTS(ts)

-- Stringa iniziale da updatare
PrintChat ("Vladimir 0.01 Loaded!")
end
function OnTick()
-- ts update
ts:update()
--Verifica se  stata premuta la spacebar
if (Config.comboset.combo) then
--Verifica se ci sono nemici intorno
if(ts.target ~= nil) then
if (myHero:CanUseSpell(_Q) == READY) then
CastSpell(_Q, ts.target) --casta la Q
end
if (myHero:CanUseSpell(_E) == READY) then
CastSpell(_E) -- casta la E
end
if (myHero:CanUseSpell(_R) == READY) then
CastSpell(_R, ts.target.x,ts.target.z) -- casta la R
end
end
end
    local tick=GetTickCount()
    if (tick-nextTick >0) then
        nextTick = tick+200
        for i = 1, heroManager.iCount, 1 do
            local champ = heroManager:getHero(i)
            if (champ.health > OldHP[i]) then
                if (tick-lastDMGtick[i] > 3000) then
                    ChampDMG[i] = 0
                end
            else
                lastDMGtick[i]=tick
                ChampDMG[i] = ChampDMG[i] + (OldHP[i] - champ.health)
            end
            OldHP[i] = champ.health
        end
    end
end
function OnDraw() --Drawing range del TS
if(Config.drawset.drawCircleQ) then --Controlla se nel menù  attiva
DrawCircle(myHero.x, myHero.y, myHero.z, QRange, 0x111111)
end
if(Config.drawset.drawCircleE) then --Controlla se nel menù attiva
DrawCircle(myHero.x, myHero.y, myHero.z, ERange, 0x111111)
end
if(Config.drawset.drawCircleR) then --Controlla se nel menù  attiva
DrawCircle(myHero.x, myHero.y, myHero.z, RRange, 0x111111)
end
if(Config.drawset.drawCircleAA) then --Controlla se nel menù  attiva
DrawCircle(myHero.x, myHero.y, myHero.z, AARange, 0x111111)
end
end