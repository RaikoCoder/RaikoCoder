print("Run Lua script ABFastFletching.")

local API = require("api")
local player = API.GetLocalPlayerName()
local startTime = os.time()
local UTILS = require("utils")
MAX_IDLE_TIME_MINUTES = 8
afk = os.time()
local startXp = API.GetSkillXP("FLETCHING")
--ge Fletching
local ID = {
    SUPER_RANGING = 169,
    GRENWALL_SPIKES = 12539,

    UNCUT_DRAGONSTONE = 1631,

    ASCENSION_SHARD = 28436,

    PROTEAN_PLANK = 30037,
}

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
local function idleCheck()
    local timeDiff = os.difftime(os.time(), afk)
    local randomTime = math.random((MAX_IDLE_TIME_MINUTES * 60) * 0.6, (MAX_IDLE_TIME_MINUTES * 60) * 0.9)

    if timeDiff > randomTime then
        API.PIdle2()
        afk = os.time()
    end
end

local function Fletch2()
    if not API.IsPlayerAnimating_(player, 40) and API.isProcessing() == false then

        API.DoAction_Object1(0x29,0,{ 106599 },50)
    ---API.DoAction_Interface(0x2e,0x651,1,1430,142,-1,API.OFF_ACT_GeneralInterface_route) -- change name for uncuts
    UTILS.randomSleep(1800)
    API.DoAction_Interface(0xffffffff,0xffffffff,0,1370,30,-1,API.OFF_ACT_GeneralInterface_Choose_option) -- craft
    end
end


--Exported function list is in API
--main loop
API.SetDrawTrackedSkills(true)
API.Write_LoopyLoop(true)
while(API.Read_LoopyLoop())
do-----------------------------------------------------------------------------------
idleCheck()
Fletch2()
if API.InvStackSize(ID.ASCENSION_SHARD) <= 10 then
    API.Write_LoopyLoop(false)
        
end
   -- if getChat("You don't have any left!") then --stops when no more 
   --     API.Write_LoopyLoop(false)
        
   -- end

API.RandomSleep2(500, 3050, 12000)
end----------------------------------------------------------------------------------
