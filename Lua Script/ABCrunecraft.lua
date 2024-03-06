print("Runecrafting With other summon")

local API = require("api")
local UTILS = require("utils")
local DISCORD = require("discord")
local MAX_IDLE_TIME_MINUTES = 10 -- CHANGE TO (5) IF NOT ON JAGEX ACC
local interval = 40 * 60 -- 40 minutes in seconds
local lastActionTime = os.time()

local player = API.GetLocalPlayerName()
local startTime = os.time()

BTIME=os.time()
BREAK_TIME=270
WORLD_SWITCH_TIME=110
world=os.time()
runsDone=0
STARTTIME=os.time()
MAX_IDLE_TIME_MINUTES = 8
afk = os.time()
ID = {
     IMPURE_ESSENCE = 55667, --main ingredient
     SMALL_POUCH = 5509,MEDIUM_POUCH = 5510,LARGE_POUCH = 5512,GIANT_POUCH = 5514, --pouches
     BANK_CHEST = 127271,DARK_PORTAL = 127376, --objects
     MIASMA_ALTAR = 127383,SPIRIT_ALTAR = 127380,Bone_ALTAR =127381,Flesh_ALTAR =127382, --altars
     MIASMA_rune = 55340,Spirit_rune = 55337,Bone_rune = 55338,Flesh_rune = 55339, -- runes
     TITAN_POUCH = 12796,key = 24154, waraltar = 114748,ABYSSAL_LURKER = 12037,
     
}
IDburst = { 49069, 49067, 49065, 49063}
 
    
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



local function founditems()
    
end

--familiars
local function checkfamiliar()
    return API.Buffbar_GetIDstatus(26095).id > 0
end
local function RenewSummPoints()
    if not checkfamiliar() and API.GetSummoningPoints_() <= 250 then
        print("Renewing at War Altar")
        DISCORD.sendDiscordMessage(API.ScriptRuntimeString().."Renewing Summoning points")
        API.DoAction_Object1(0x3d,API.OFF_ACT_GeneralObject_route0,{ 114748 },50) --change to warportals
        API.RandomSleep2(1000,1000,1000) 
    end
      
end
local function FamSummon()
    if API.InvItemFound1(ID.ABYSSAL_LURKER) and API.GetSummoningPoints_() >= 300 and checkfamiliar() == false then
        print("summonfam: Pouch found Clicking on Pouch")
        API.DoAction_Ability("Abyssal lurker pouch", 1, API.OFF_ACT_GeneralInterface_route)
        DISCORD.sendDiscordMessage(API.ScriptRuntimeString().."Summing Familiars")
        API.RandomSleep2(600, 50, 50)
    end
end

--end of familiar

local function portWar()
    if API.InvItemFound1(ID.MIASMA_rune) and insidewar() == false then
        API.CheckAnim(2)
        API.DoAction_Ability("War's Retreat Teleport", 1, API.OFF_ACT_GeneralInterface_route)
        DISCORD.sendDiscordMessage(API.ScriptRuntimeString().."No more Runes getting some more")
        API.WaitUntilMovingandAnimEnds()
        UTILS.randomSleep(600)
    end
end
local function Banking()
    if API.InvItemFound1(ID.MIASMA_rune) and insidewar() == true and checkfamiliar() then
        if API.BankOpen2() then
            API.DoAction_Interface(0x24,0xffffffff,1,517,119,1,API.OFF_ACT_GeneralInterface_route)
            DISCORD.sendDiscordMessage(API.ScriptRuntimeString().."Banking for essence")
        else
            API.DoAction_Object1(0x2e,API.OFF_ACT_GeneralObject_route1,{ 114750 },50)
            API.RandomSleep2(600,200,200)
           
        end
    end
   
    FamSummon()
    RenewSummPoints()
end 
local function TeletoPortal()
    if API.InvItemFound1(ID.IMPURE_ESSENCE) and insidewar() and  nearportal() ==false and API.ReadPlayerAnim() == 0 then
        DISCORD.sendDiscordMessage(API.ScriptRuntimeString().."Using passing Teleport")
        API.DoAction_Interface(0xffffffff,0xdc60,7,1670,58,-1,API.OFF_ACT_GeneralInterface_route2)
    API.RandomSleep2(800,200,100)
    API.DoAction_Interface(0xffffffff,0xffffffff,0,720,20,-1,API.OFF_ACT_GeneralInterface_Choose_option)
    API.RandomSleep2(800,200,100)
        else 
            return
    end
    if API.InvItemcount_1(ID.IMPURE_ESSENCE) <= 6 then
        API.DoAction_Ability("War's Retreat Teleport", 1, API.OFF_ACT_GeneralInterface_route)
        API.Write_LoopyLoop(false)
    end
end
local function Errors()
    if API.GetGameState2() == 1 or API.GetGameState2() == 2 then
        if API.GetGameState2() == 1 then
            print("LOGGED out")
            DISCORD.sendDiscordMessage(API.ScriptRuntimeString().."Logged out or disconnected")
        end
        if API.GetGameState2() == 2 then
            print("Lobbied")
            DISCORD.sendDiscordMessage(API.ScriptRuntimeString().."Lobbied!")
        end
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
    if not API.ReadPlayerMovin() and API.InvItemFound1(ID.IMPURE_ESSENCE)then
    API.DoAction_Object1(0x29, API.OFF_ACT_GeneralObject_route0, {ID.MIASMA_ALTAR}, 50) -- makes runes
    API.WaitUntilMovingEnds()
    UTILS.randomSleep(800)
    print("Making Runes")
    runsDone=runsDone+1
    local scriptTime = os.time()
    local elapsedTimeSeconds = scriptTime - STARTTIME
    local elapsedTimeMinutes = elapsedTimeSeconds / 60
    local runsPerHour = math.floor((runsDone/elapsedTimeMinutes)*60)
    print("Runs per Hour: "..runsPerHour)
    DISCORD.sendDiscordMessage("Runs per Hour: "..runsPerHour.. API.ScriptRuntimeString())
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

--copied from someones powerburst
local function Magic()
    local isPowerburstReady = canUsePowerburst()

    if isPowerburstReady and insideportal() ==true  then
        print("MAGIC: Powerbursting Boost is Now active")
        API.DoAction_Ability("Powerburst of sorcery", 1, API.OFF_ACT_GeneralInterface_route)
        DISCORD.sendDiscordMessage(API.ScriptRuntimeString().."Using Powerburst")
        API.CheckAnim(2)
        print("MAGIC: Powerbursting Boost Active Clicking Altar")
    else
        print("MAGIC: Powerbursting Boost In-Active Clicking Altar")
        AltarClick()
        API.RandomSleep2(600, 850, 80)
        API.CheckAnim(2)
        DISCORD.sendDiscordMessage(API.ScriptRuntimeString().."Making Runes")
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
    DISCORD.sendDiscordMessage(API.ScriptRuntimeString().."Being Idle doing something else")
    end
end

local IMPURE = 0 -- Initialize the count of gems banked
local function checkbank()
    local items = API.FetchBankArray()

    for k, v in pairs(items) do
        if v.itemid1 == ID.IMPURE_ESSENCE then
            --print("Found: " .. v.itemid1_size .. " Impure essence.")
            IMPURE = v.itemid1_size -- Update Impure essence count
        end
    end
    return IMPURE > 0
end


API.SetDrawTrackedSkills(true)
API.Write_LoopyLoop(true)
DISCORD.setPlayerName(API.GetLocalPlayerName())

while(API.Read_LoopyLoop())
do-----------------------------------------------------------------------------------
    
  if closerportal()==true or innerportal() ==true or closebone ==true or closeflesh() ==true  or closemiasma() ==true
    or closespirit() ==true  then
        SurgeON()
    end
    
portWar() --teleport to war
API.RandomSleep2(600,200,100)


if not checkfamiliar() and insidewar() and API.GetSummoningPoints_() >= 300 then

    print("Can Summon, Summoning")
    FamSummon()
    API.RandomSleep(1200,200,100) 
else 

    RenewSummPoints()
    API.WaitUntilMovingEnds()
    API.RandomSleep(1200,200,100) 
end
Banking() --banks


TeletoPortal() --passing

DarkPortal() -- click dark

    
if insideportal() and API.InvItemcount_String("Powerburst of sorcery") <= 1  then
    Magic() --powerburst then click altar / just click altar 
    
end
Errors()
idleCheck()
API.RandomSleep2(1200,800,600)
end----------------------------------------------------------------------------------