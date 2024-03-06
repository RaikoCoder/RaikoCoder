print("Modified Runecrafting with Titan")
local API = require("api")
local skill = "RUNECRAFTING"
local UTILS = require("utils")
local MAX_IDLE_TIME_MINUTES = 10 -- CHANGE TO (5) IF NOT ON JAGEX ACC
local interval = 40 * 60 -- 40 minutes in seconds
local lastActionTime = os.time()

local player = API.GetLocalPlayerName()
local startTime = os.time()

MAX_IDLE_TIME_MINUTES = 8
afk = os.time()
ID = {
     IMPURE_ESSENCE = 55667, --main ingredient
     SMALL_POUCH = 5509,MEDIUM_POUCH = 5510,LARGE_POUCH = 5512,GIANT_POUCH = 5514, --pouches
     BANK_CHEST = 127271,DARK_PORTAL = 127376, --objects
     MIASMA_ALTAR = 127383,SPIRIT_ALTAR = 127380,Bone_ALTAR =127381,Flesh_ALTAR =127382, --altars
     MIASMA_rune = 55340,Spirit_rune = 55337,Bone_rune = 55338,Flesh_rune = 55339, -- runes
     TITAN_POUCH = 12796,key = 24154, waraltar = 114748,
}
 
    
    local function insidewar()
        return API.PInArea21(3265,3375,10110,10150)
   end
    local function nearportal()
        return API.PInArea21(1163,1165,1822,1838)
   end
   local function closerportal()
    return API.PInArea21(1163,1165,1830,1837)
end
   local function insideportal()
    return API.PInArea21(1296,1324,1934,1966)
end
local function innerportal()
    return API.PInArea21(1305,1320,1950,1954)
end
local function closemiasma()
    return API.PInArea21(1317,1319,1952,1952)
end
local function closeflesh()
    return API.PInArea21(1314,1316,1947,1949)
end
local function closebone()
    return API.PInArea21(1307,1309,1954,1957)
end
local function closespirit()
    return API.PInArea21(1312,1314,1955,1957)
end
--added things

local function ClaimKey()
    if API.InvItemcount_1(ID.Key) == true then
        API.DoAction_Object1()

    end
end


--familiars
local function hasfamiliar()
    return API.Buffbar_GetIDstatus(26095).id > 0
end
local function newsum()
    if API.GetSummoningPoints_() <= 200 and not hasfamiliar() then
        print("Renewing at War Altar")
        API.DoAction_Object1(0x3d,API.OFF_ACT_GeneralObject_route0,{ 114748 },50) --change to warportals
        API.RandomSleep2(1000,1000,1000) 
    end
end

local function summonFam()
    if API.InvItemFound1(ID.TITAN_POUCH) and hasfamiliar() == false and API.GetSummoningPoints_() >= 200 then
        print("summonfam: Pouch found Clicking on Pouch")
        API.DoAction_Ability("Abyssal titan pouch", 1, API.OFF_ACT_GeneralInterface_route)
        API.RandomSleep2(600, 50, 50)
end
    return true
end

--end of familiar

local function portWar()
    if API.InvItemFound1(ID.MIASMA_rune) and insidewar() == false then
        API.DoAction_Ability("War's Retreat Teleport", 1, API.OFF_ACT_GeneralInterface_route)
        API.WaitUntilMovingandAnimEnds()
        UTILS.randomSleep(1200)
    end
end
local function Banking()
    if API.InvItemFound1(ID.MIASMA_rune) and insidewar() == true and hasfamiliar() then
        if API.BankOpen2() then
            API.DoAction_Interface(0x24,0xffffffff,1,517,119,1,API.OFF_ACT_GeneralInterface_route)
        else
            API.DoAction_Object1(0x2e,API.OFF_ACT_GeneralObject_route1,{ 114750 },50)
            API.RandomSleep2(1800,200,200)
        end
    end
   
    newsum()
    summonFam()
end

 
local function TeletoPortal()
    if API.InvItemFound1(ID.IMPURE_ESSENCE) and insidewar() and  nearportal() ==false then
    API.DoAction_Interface(0x2e,0xdc60,7,1473,5,4,API.OFF_ACT_GeneralInterface_route2)
    API.RandomSleep2(1200,200,100)
    API.DoAction_Interface(0xffffffff,0xffffffff,0,720,20,-1,API.OFF_ACT_GeneralInterface_Choose_option)
    API.WaitUntilMovingandAnimEnds()
    API.RandomSleep2(1200,200,100)
    else 
        return
    end
    if API.InvItemcount_1(ID.IMPURE_ESSENCE) <= 6 then
        API.Write_LoopyLoop(false)
    end
end

local function DarkPortal()
    if API.ReadPlayerMovin() == false and nearportal() ==true then
         API.DoAction_Object1(0x39,API.OFF_ACT_GeneralObject_route0,{ ID.DARK_PORTAL },50) --then click the dark portal
              print("Entering Dark Portal")
              API.WaitUntilMovingEnds() --sleep for a tick + more
      else 
         return
      end
end

local function AltarClick()
    if not API.ReadPlayerMovin() and API.InvItemFound1(ID.IMPURE_ESSENCE) then
    API.DoAction_Object1(0x29, API.OFF_ACT_GeneralObject_route0, {ID.MIASMA_ALTAR}, 50) -- makes runes
    API.WaitUntilMovingEnds()
    UTILS.randomSleep(800)
    print("Making Runes")
    end
end
--powerburst
local function findPowerburst()
    local powerburstIds = { 49069, 49067, 49065, 49063 }
    local powerbursts = API.CheckInvStuff3(powerburstIds)
    local foundIdx = 0
    for i, value in ipairs(powerbursts) do
        if tostring(value) == '1' then
            foundIdx = i
        end
    end
    return powerburstIds[foundIdx]
end
local function canUsePowerburst()
    local debuffs = API.DeBuffbar_GetAllIDs()
    local powerburstCoolldown = false
    for _, a in ipairs(debuffs) do
        if a.id == 48960 then
            powerburstCoolldown = true
        end
    end
    return not powerburstCoolldown
end


local function Magic()
    local isPowerburstReady = canUsePowerburst()

    if isPowerburstReady and insideportal() ==true  then
        print("MAGIC: Powerbursting Boost is Now active")
        API.DoAction_Ability("Powerburst of sorcery", 1, API.OFF_ACT_GeneralInterface_route)
        API.CheckAnim(2)
        print("MAGIC: Powerbursting Boost Active Clicking Altar")
    else
        print("MAGIC: Powerbursting Boost In-Active Clicking Altar")
        AltarClick()
        API.RandomSleep2(600, 850, 80)
        API.CheckAnim(2)
end
end

local function SurgeON()
    API.DoAction_Ability("Surge", 1, API.OFF_ACT_GeneralInterface_route)
    print("Surging!")
end
--Exported function list is in API
--main loop

local function idleCheck() --IDLE check changed camera from time to time
    local timeDiff = os.difftime(os.time(), afk)
    local randomTime = math.random((MAX_IDLE_TIME_MINUTES * 60) * 0.6, (MAX_IDLE_TIME_MINUTES * 60) * 0.9)
    if timeDiff > randomTime then
    API.PIdle2()
    afk = os.time()
    end
end
local function getChat(message) --check Message to see if no more uncuts
    local chatMsg = API.ChatGetMessages()
    if chatMsg then 
        for k,v in ipairs(chatMsg) do
            if string.find(tostring(v.text), message) then 
                local hour, min, sec = string.match(v.text, "(%d+):(%d+):(%d+)")
                local currentDate = os.date("*t")
                currentDate.hour, currentDate.min, currentDate.sec = tonumber(hour), tonumber(min), tonumber(sec)
                local timestamp = os.time(currentDate)

                if timestamp > startTime then 
                    startTime = timestamp
                    return true
                end 
            end 
        end
    end
    return false
end 

API.SetDrawTrackedSkills(true)
API.Write_LoopyLoop(true)
API.Write_fake_mouse_do(true)
while(API.Read_LoopyLoop())
do-----------------------------------------------------------------------------------
  if closerportal()==true or innerportal() ==true or closebone ==true or closeflesh() ==true  or closemiasma() ==true
    or closespirit() ==true  then
        SurgeON()
    end
    
portWar() --teleport to war
API.RandomSleep2(600,200,100)


if not hasfamiliar() and insidewar() and API.GetSummoningPoints_() >= 300 
    and API.InvItemFound1(ID.TITAN_POUCH) then
    print("Can Summon, Summoning")
    summonFam()
    API.RandomSleep(1600,200,100) 
else 
    newsum()
    API.WaitUntilMovingEnds()
    API.RandomSleep(1600,200,100) 
end
Banking() --banks and renew
if insidewar() and  nearportal() ==false then
    TeletoPortal() --passing
    API.RandomSleep2(1200,400,800)
end


DarkPortal() -- click dark
    
if insideportal() and API.InvItemcount_String("Powerburst of sorcery") <= 1  then
    Magic() --powerburst then click altar / just click altar 
end

idleCheck()
API.RandomSleep2(500, 3050, 12000)
end----------------------------------------------------------------------------------
