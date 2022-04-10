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

-- simpleAI by: https://github.com/NickEnbachtov/plugins-template-library-docs/releases/tag/v1.8
-- local simpleAI = require 'plugin.simpleAI.plugin.SimpleAI'

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

centerX = display.contentCenterX
centerY = display.contentCenterY

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
    --[[
                    Height; 1536
    -------------------------------------------------
            |   1   |   2  |    3   |      
    ------- 0,0                            -------
    | 4 |          (Screen)                | 10 |
    | 5 |          Spawning                | 11 |       Width: 864
    | 6 |         Explained                | 12 |
    ------                     1536, 864  ---------
            |   7   |   8   |   9   | 
    ------------------------------------------------

    ]]
    
    
    if (whereFrom >= 1) and (whereFrom <= 3) then
        newZombie.x = centerX - 80
        newZombie.y = centerY + math.random( display.contentHeight )
    elseif (whereFrom >= 4) and (whereFrom <= 6) then
        newZombie.x = centerX + math.random( display.contentWidth )
        newZombie.y = centerY - 80
    elseif (whereFrom >= 7) and (whereFrom <= 9) then
        newZombie.x = centerX + 80
        newZombie.y = centerY - math.random( display.contentHeight )
    elseif (whereFrom >= 10) and (whereFrom <= 12) then
        newZombie.x = centerX - math.random( display.contentWidth )
        newZombie.y = centerY + 80
    end 

    characterX, characterY = getPlayerPosition()
    newZombie:setLinearVelocity( (characterX - newZombie.x), (characterY - newZombie.y)  )


end

function getPlayerPosition()
    if ( dead == false ) then
        return player.x, player.y
    end
end

    


--[[
for i = 1, 10 do
    createZombie()
end
--]]

-- local enemy = simpleAI.newAI(mainLayer, "/resources/images/zombie.png", 100, 300)
-- enemy.gravityscale = 0

local function dragPlayer( event )

	local ship = event.target
	local phase = event.phase

	if ( "began" == phase ) then
		-- Set touch focus on the ship
		display.currentStage:setFocus( ship )
		-- Store initial offset position
		ship.touchOffsetX = event.x - ship.x
		ship.touchOffsetY = event.y - ship.y
	elseif ( "moved" == phase ) then
		-- Move the ship to the new touch position
		ship.x = event.x - ship.touchOffsetX
		ship.y = event.y - ship.touchOffsetY

	elseif ( "ended" == phase or "cancelled" == phase ) then
		-- Release touch focus on the ship
		display.currentStage:setFocus( nil )
	end

	return true  -- Prevents touch propagation to underlying objects
end

local function shoot()

	local newLaser = display.newImageRect( mainLayer, "resources/images/bullet.png", 50, 50 )
	physics.addBody( newLaser, "dynamic", { isSensor=true } )
	newLaser.isBullet = true
	newLaser.myName = "laser"

	newLaser.x = player.x
	newLaser.y = player.y
    
	newLaser:toBack()
    -- We do some calculations
    -- We will translate 0,0 to the center

    local playerx, playery = getPlayerPosition()
    --local Y = mouseY - (playery - mouseY) + (playery - mouseY) * 5
    --local X = mouseX - (playerx - mouseX) + (playerx - mouseX) * 5
    local Y = mouseY
    local X = mouseX
    local transitionTime = 1000
    local distance = math.sqrt( (X - playerx)^2 + (Y - playery)^2 )
    ---[[
    if (distance < 100) then
        transitionTime = 200
    elseif (distance < 275) then
        transitionTime = 350
    elseif (distance < 325) then
        transitionTime = 400
    elseif (distance < 375) then
        transitionTime = 450
    elseif (distance < 500) then
        transitionTime = 600
    elseif (distance > 1000) then
        transitionTime = 1200
    elseif (distance > 1200) then
        transitionTime = 1400
    else    
        transitionTime = 900
    end
    --]]
    print(distance)

	transition.to( newLaser, { y = Y , x = X, time=transitionTime, onComplete = function() display.remove( newLaser ) end
	} )
end

-- THE FOLLOWING WAS TAKEN FROM: https://fr.solar2d.net/api/event/mouse/x.html
mouseX = 0
mouseY = 0
-- Called when a mouse event has been received.

local function onMouseEvent( event )
    -- Print the mouse cursor's current position to the log.
    local message = "Mouse Position = (" .. tostring(event.x) .. "," .. tostring(event.y) .. ")"
    print( message )
    -- Update the mouseX and mouseY variables.
    mouseX = event.x
    mouseY = event.y
end
                             
-- Add the mouse event listener.
Runtime:addEventListener( "mouse", onMouseEvent )

player:addEventListener( "touch", dragPlayer )
background:addEventListener("tap", shoot)
