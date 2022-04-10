-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- https://docs.coronalabs.com/guide/programming/01/index.html
-- Modified contents: Milan


-- We will only need physics for the collision detection
local physics = require( "physics" )
physics.start()

display.setStatusBar( display.HiddenStatusBar )

math.randomseed( os.time() ) -- Random seed from the number generator



--[[

    The following code format was taken from: 
    https://docs.coronalabs.com/guide/programming/02/index.html

]]

-- We will initliaze the variables to be used in the game -- Milan
local dead = false
local score = 0
local kills = 0
local seconds = 0
local minutes = 0
local zombiesArray = {}

local character
local gameLoopTimer
local scoreText
local timeDisplay

-- We will create 4 layers for display -- Milan
local backgroundLayer = display.newGroup()
local mainLayer = display.newGroup()
local treesLayer = display.newGroup()
local userInterface = display.newGroup()

-- We will create image objects and insert them into their corresponding groups ~ Milan
local background = display.newImageRect( backgroundLayer, "/resources/images/background.png", display.contentWidth, display.contentHeight )
-- local boulder = display.newImage( mainLayer, "/resources/images/boulder.jpg", 100, 100 )
-- local tree = display.newImage( treesLayer, "/resources/images/trees.jpg", 100, 100 )
local player = display.newImageRect( mainLayer, "/resources/images/character.png", 100, 100 )

-- We will display them in the correct position -- Milan
background.x = display.contentCenterX
background.y = display.contentCenterY

player.x = display.contentCenterX
player.y = display.contentCenterY
player.alpha = 0.96 -- Slight transparency gives a nice effect and the player will intake more detail -- Milan
physics.addBody( player, "dynamic", { radius = 50, isSensor = true } )
player.gravityScale = 0 -- We want to interact with objects, but not be affacted by gravity since its topdown -- Milan
player.myName = "character"   


-- If we want to move the text as a group, just alternate these values -- Milan
local horizontalText = 600
local verticalText = 120

scoreText = display.newText( userInterface , "Points: " .. score, display.contentCenterX + horizontalText + 20, verticalText , native.systemFont, 40 )
scoreText:setFillColor( 255 , 0 , 0 , 0.9 ) -- Note to self, Syntax is the following: R,G,B,Alpha -- Milan

killCount = display.newText( userInterface , "Kills: " .. kills, display.contentCenterX + horizontalText, verticalText + 40 , native.systemFont, 40 )
killCount:setFillColor( 255 , 0 , 0 , 0.9 )

-- We will start creating our Methods / Functions -- Milan
--[[
    This snippet of code was taken from: 
    https://docs.coronalabs.com/guide/programming/02/index.html
]]

local function updateText()
    killCount.text = "Kills: " .. kills
    scoreText.text = "Score: " .. score
end

local function createZombie()
    local newZombie = display.newImageRect( mainLayer, "/resources/images/zombie.png", 120, 120 )
    newZombie.alpha = 0.96
    newZombie.myName = "zombie"
    physics.addBody( newZombie, "dynamic", { radius = 50, isSensor = true } )
    newZombie.gravityScale = 0
    zombiesArray.insert( zombiesArray, newZombie )
    local whereFrom = math.random( 12 )
    local centerX = display.contentCenterX
    local centerY = display.contentCenterY
    if (whereFrom >= 1) and (whereFrom <= 3) then
        -- newZombie.x = centerX
        -- newZombie.y = centerY + math.random( display.contentHeight )
    elseif (whereFrom >= 4) and (whereFrom <= 6) then
        -- newZombie.x = centerX + math.random( display.contentWidth )
        -- newZombie.y = centerY
    elseif (whereFrom >= 7) and (whereFrom <= 9) then
        -- newZombie.x = centerX
        -- newZombie.y = centerY - math.random( display.contentHeight )
    elseif (whereFrom >= 10) and (whereFrom <= 12) then
        -- newZombie.x = centerX - math.random( display.contentWidth )
        -- newZombie.y = centerY
    end
    
    
end