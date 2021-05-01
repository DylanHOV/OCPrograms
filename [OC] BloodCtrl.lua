--[[
BloodCtrl
Automated Blood Magic Slate Creation
Version: 0.1.1
Author: Haybale100
License: CC BY 4.0 
How to use: https://oc.cil.li/index.php?/topic/1736-bloodctrl-v01-automated-blood-magic-slate-creation/
]]
 
-- Variables --
-- You can change these as needed
component = require("component")
transpose = component.transposer
term = require("term")
rs = component.redstone
gpu = component.gpu
sides = require("sides")
colors = require("colors")

BloodAltarTier = 4  -- Change manually depending on your Altar level, Default: 5 (Tier: V)
 
slateBCount = 8 -- Blank Slates, Default: 8
slateRCount = 8 -- Reinforced Slates, Default: 8
slateICount = 8 -- Imbued Slates, Default: 4
slateDCount = 8 -- Demonic Slates, Default: 4
slateECount = 2 -- Etherial Slates, Default: 1

chestSide = sides.north   -- Default: sides.top (1)
stoneSide = sides.south   -- Default: 2 (Back)
altarSide = sides.left   --Default: 4 (Right)
reserveTankSide = sides.left    --Default: 5 (Left), this is only used if a tank is detected
 
rsInputSide = sides.right --Default: 4 (Right), This is right of a computer with a Redstone card or right of a Redstone I/O block
 
stoneSlot = 1  --Default: 10 (Slot 10 is the first export slot for a Refined Storage Interface, Change this as needed)
 
-- Altar slots do not need to be changed, unless WayOfTime add additional inventory slots or tanks to the Blood Altar
altarSlot = 1  
altarTank = 1
 
-- Slate Slots below are the first 5 slots of a chest, change these if you are not using any type of regular chest (NOT tested with other mods like Iron Chests)
slateBSlot = 1
slateRSlot = 2
slateISlot = 3
slateDSlot = 4
slateESlot = 5
 
 
 
 
--||    DON'T CHANGE ANYTHING BELOW UNLESS YOU KNOW WHAT YOUR DOING!    ||
 
-- Global Declares --

 
stackInfo = {}
 
itemInfo = {
    {
        name = "Blank Slate",
        blood = 1000,
        tier = 1
    },
    {
        name = "Reinforced Slate",
        blood = 2000,
        tier = 2
    },
    {
        name = "Imbued Slate",
        blood = 5000,
        tier = 3
    },
    {
        name = "Demonic Slate",
        blood = 15000,
        tier = 4
    },
    {
        name = "Ethereal Slate",
        blood = 30000,
        tier = 5
    }   
}
 
function SetStackInfoBasic()
    stackInfo[1] = transpose.getStackInSlot(chestSide, slateBSlot)
end
 
function SetStackInfoReinforced()
    stackInfo[2] = transpose.getStackInSlot(chestSide, slateRSlot)
end
 
function SetStackInfoImbued()
    stackInfo[3] = transpose.getStackInSlot(chestSide, slateISlot)
end
 
function SetStackInfoDemonic()
    stackInfo[4] = transpose.getStackInSlot(chestSide, slateDSlot)
end
 
function SetStackInfoEthereal()
    stackInfo[5] = transpose.getStackInSlot(chestSide, slateESlot)
end
 
function SetDefaultStackInfo()
    if pcall(SetStackInfoBasic) then ;
    else
        stackInfo[1].label = itemInfo[1].name
        stackInfo[1].size = 0
    end
    if pcall(SetStackInfoReinforced) then ;
    else
        stackInfo[2].label = itemInfo[2].name
        stackInfo[2].size = 0
    end
    if pcall(SetStackInfoImbued) then ;
    else
        stackInfo[3].label = itemInfo[3].name
        stackInfo[3].size = 0
    end
    if pcall(SetStackInfoDemonic) then ;
    else
        stackInfo[4].label = itemInfo[4].name
        stackInfo[4].size = 0
    end
    if pcall(SetStackInfoEthereal) then ;
    else
        stackInfo[5].label = itemInfo[5].name
        stackInfo[5].size = 0
    end
end
 
function getTankInfo()
    tInfo = transpose.getFluidInTank(altarSide)
    tankAmount = tInfo[1].amount
    tankCapacity = tInfo[1].capacity
    tankPercent = (tankAmount / tankCapacity) * 100
 
    if term.isAvailable() then
      term.clearLine()
      term.write(string.format("Current Blood Level: %.2f %%, %.0d mb / %.0d mb\n", tankPercent, tankAmount, tankCapacity))
    end
end
 
function getReserveTankInfo()
    rTInfo = transpose.getFluidInTank(reserveTankSide)
    if rTInfo.n > 0 then
        rTankAmount = rTInfo[1].amount
        rTankCapacity = rTInfo[1].capacity
        rTPercent = (rTankAmount / rTankCapacity) * 100
        
        if term.isAvailable() then
            term.clearLine()
            term.write(string.format("Reserve Blood Level: %.2f %%, %.0d mb / %.0d mb\n", rTPercent, rTankAmount, rTankCapacity))
        end
    else
        if term.isAvailable() then
            term.write("No Reserve Tank Detected\n")
        end 
    end
end
 
function WriteRSBlood()
    if term.isAvailable() then
        term.clearLine()
        term.write("Blood Creation: ")
        if rs.getInput(rsInputSide) == 0 then
            term.write("True \n")
        else
            term.write("False\n")
        end
    end
end
 
function BlankSlate(Fix)
    local crafting = true
    --Move 1 stone from Interface to Blood Altar
    transpose.transferItem(stoneSide, altarSide, 1, stoneSlot, altarSlot)
    while crafting do
        writeToTerm()
        term.write(itemInfo[1].name.."\n")
        if transpose.getStackInSlot(altarSide, altarSlot).label == itemInfo[1].name then
            crafting = false
            --Move 1 Blank Slate from Blood Altar to Chest
            transpose.transferItem(altarSide, chestSide, 1, altarSlot, slateBSlot)
        end
    end
    Fix = "Ignore patch"
    return Fix
end
   
function ReinforcedSlate(Fix)
    local crafting = true
    --Move 1 Blank Slate from Chest to Blood Altar
    transpose.transferItem(chestSide, altarSide, 1, slateBSlot, altarSlot)
    while crafting do
        writeToTerm()
        term.write(itemInfo[2].name.."\n")
        if transpose.getStackInSlot(altarSide, altarSlot).label == itemInfo[2].name then
            crafting = false
            --Move 1 Reinforced Slate from Blood Altar to Chest
            transpose.transferItem(altarSide, chestSide, 1, altarSlot, slateRSlot)
        end
    end
    Fix = "Ignore patch"
    return Fix
end
   
function ImbuedSlate(Fix)
    local crafting = true
    --Move 1 Reinforced Slate from Chest to Blood Altar
    transpose.transferItem(chestSide, altarSide, 1, slateRSlot, altarSlot)
    while crafting do
        writeToTerm()
        term.write(itemInfo[3].name.."\n")
        if transpose.getStackInSlot(altarSide, altarSlot).label == itemInfo[3].name then
            crafting = false
            --Move 1 Imbued Slate from Blood Altar to Chest
            transpose.transferItem(altarSide, chestSide, 1, altarSlot, slateISlot)
        end
    end
    Fix = "Ignore patch"
    return Fix
end
   
function DemonicSlate(Fix)
    local crafting = true
    --Move 1 Imbued Slate from Chest to Blood Altar
    transpose.transferItem(chestSide, altarSide, 1, slateISlot, altarSlot)
    while crafting do
        writeToTerm()
        term.write(itemInfo[4].name.."\n")
        if transpose.getStackInSlot(altarSide, altarSlot).label == itemInfo[4].name then
            crafting = false
            --Move 1 Demonic Slate from Blood Altar to Chest
            transpose.transferItem(altarSide, chestSide, 1, altarSlot, slateDSlot)
        end
    end
    Fix = "Ignore patch"
    return Fix
end
 
function EtherealSlate(Fix)
    local crafting = true
    --move 1 Demonic Slate from chest to Blood Altar
    transpose.transferItem(chestSide, altarSide, 1, slateDSlot, altarSlot)
    while crafting do
        
        if transpose.getStackInSlot(altarSide, altarSlot).label == itemInfo[5].name then
            crafting = false
            --Move 1 Ethereal Slate from Blood Altar to Chest
            transpose.transferItem(altarSide, chestSide, 1, altarSlot, slateESlot)
        end
    end
    Fix = "Ignore patch"
    return Fix
end
 
function writeToTerm()
    term.setCursor(1,1)
    getTankInfo()
    getReserveTankInfo()
    WriteRSBlood()
    term.clearLine()
    term.write("Making: ")
end