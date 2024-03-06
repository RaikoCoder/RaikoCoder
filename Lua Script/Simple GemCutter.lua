print("Script started, Crafting uncut gems")
local API = require("api")
local UTILS = require("utils")
local player = API.GetLocalPlayerName()

--[[
SETTING

USE AT Grand Exchange (change Preset and KeyboardPress2 to whatever your using)
put Uncut into your Ability bar
Start Full inventory / None

]]
------GUI------
local startTime = os.time()
MAX_IDLE_TIME_MINUTES = 8
afk = os.time()
local cra =  { --LEVELS
    opal =1625, --1
    jade = 1627, -- 13
    topaz =1629,--16
    sapphire = 1623, --20
    emerald = 1621, --27
    ruby = 1619, --34
    diamond = 1617, -- 43
    dragonstone = 1631, --55 
    onyx = 6571, --72
    hydrix = 31853 --79
}
   local IDcraft = cra.dragonstone
   local preset = 5

local startXp = API.GetSkillXP("CRAFTING")
local totalCutGems = 0 -- Variable to store the total number of Gems


local function round(val, decimal)
    if decimal then
        return math.floor((val * 10 ^ decimal) + 0.5) / (10 ^ decimal)
    else
        return math.floor(val + 0.5)
    end
end

function formatNumber(num)
    if num >= 1e6 then
        return string.format("%.1fM", num / 1e6)
    elseif num >= 1e3 then
        return string.format("%.1fK", num / 1e3)
    else
        return tostring(num)
    end
end

-- Format script elapsed time to [hh:mm:ss]
local function formatElapsedTime(startTime)
    local currentTime = os.time()
    local elapsedTime = currentTime - startTime
    local hours = math.floor(elapsedTime / 3600)
    local minutes = math.floor((elapsedTime % 3600) / 60)
    local seconds = elapsedTime % 60
    return string.format("[%02d:%02d:%02d]", hours, minutes, seconds)
end

local function calcProgressPercentage(skill, currentExp)
    local currentLevel = API.XPLevelTable(API.GetSkillXP(skill))
    if currentLevel == 120 then
        return 100
    end
    local nextLevelExp = XPForLevel(currentLevel + 1)
    local currentLevelExp = XPForLevel(currentLevel)
    local progressPercentage = (currentExp - currentLevelExp) / (nextLevelExp - currentLevelExp) * 100
    return math.floor(progressPercentage)
end

local UncutGemsBanked = 0 -- Initialize the count of gems banked

local function checkbank()
    local items = API.FetchBankArray()

    for k, v in pairs(items) do
        if v.itemid1 == IDcraft then
            --print("Found: " .. v.itemid1_size .. " Raw gem.")
            UncutGemsBanked = v.itemid1_size -- Update the count of gems banked
        end
    end
    -- If cut gems is found, return true
    return UncutGemsBanked > 0
end


totalCutGems = 0
local lastXP = API.GetSkillXP("CRAFTING") -- Initialize lastXP to the current XP

local function checkForXPDrop()
    local currentXP = API.GetSkillXP("CRAFTING")
    if currentXP > lastXP then
        lastXP = currentXP
        totalCutGems = totalCutGems + 1 -- Increment totalCutGems when XP increases
        return true
    else
        return false
    end
end
local function printProgressReport(final)
    local skill = "CRAFTING"
    local currentXp = API.GetSkillXP(skill)
    local elapsedMinutes = (os.time() - startTime) / 60
    local diffXp = math.abs(currentXp - startXp)
    local xpPH = round((diffXp * 60) / elapsedMinutes, 1)
    local time = formatElapsedTime(startTime)
    local currentLevel = API.XPLevelTable(API.GetSkillXP(skill))
    local bankedMsg = ""

    if UncutGemsBanked > 0 then
        bankedMsg = " | Uncut Gems Stock: " .. UncutGemsBanked
    else
        bankedMsg = " | Out of Uncuts"
    end

    IGP.radius = calcProgressPercentage(skill, API.GetSkillXP(skill)) / 100
    IGP.string_value = time .. " | " .. string.lower(skill):gsub("^%l", string.upper) .. ": " .. currentLevel ..
        " | XP/H: " ..
        formatNumber(xpPH) .. " | XP: " .. formatNumber(diffXp) .. " "..bankedMsg -- cut gems banked information
end

local function setupGUI()
    IGP = API.CreateIG_answer()
    IGP.box_start = FFPOINT.new(5, 5, 0)
    IGP.box_name = "PROGRESSBAR"
    IGP.colour = ImColor.new(128, 0, 128);
    IGP.string_value = "Simple Gems Cutter"
end

local function drawGUI()
    DrawProgressBar(IGP)
end

setupGUI()
------End of GUI------

local function idleCheck()
    local timeDiff = os.difftime(os.time(), afk)
    local randomTime = math.random((MAX_IDLE_TIME_MINUTES * 60) * 0.6, (MAX_IDLE_TIME_MINUTES * 60) * 0.9)

    if timeDiff > randomTime then
        API.PIdle2()
        afk = os.time()
    end
end




local function craft()
        if not API.IsPlayerAnimating_(player, 40) and API.isProcessing() ==false then

            API.DoAction_Ability("Uncut dragonstone", 1, API.OFF_ACT_GeneralInterface_route)
        ---API.DoAction_Interface(0x2e,0x651,1,1430,142,-1,API.OFF_ACT_GeneralInterface_route) -- change name for uncuts
        UTILS.randomSleep(1800)
        API.DoAction_Interface(0xffffffff,0xffffffff,0,1370,30,-1,API.OFF_ACT_GeneralInterface_Choose_option) -- craft
        end
end



local function BankDia()
    API.DoAction_NPC(0x5,API.OFF_ACT_InteractNPC_route,{ 3418 },50) -- open bank GE
        UTILS.randomSleep(1800)
        checkbank()
        UTILS.randomSleep(1800)
        API.DoAction_Interface(0x24,0xffffffff,1,517,119,5,API.OFF_ACT_GeneralInterface_route) -- click f5
        UTILS.randomSleep(1800)
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


--Exported function list is in API
--main loop
API.Write_LoopyLoop(true)
while(API.Read_LoopyLoop())
do-----------------------------------------------------------------------------------
    drawGUI()
    idleCheck()
    checkForXPDrop()
    if API.InvItemFound1(IDcraft) == false then 
        BankDia()
        
    end
    craft()
    printProgressReport()
    UTILS.randomSleep(1800)
    if getChat("Item could not be found:") then --stops when no more uncut gems
        API.Write_LoopyLoop(false)
        
    end
    
end----------------------------------------------------------------------------------
