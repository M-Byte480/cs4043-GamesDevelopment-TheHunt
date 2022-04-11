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
local collisionFilters = require( "plugin.collisionFilters" ) -- Frpm Corona Labs https://docs.coronalabs.com/plugin/collisionFilters/index.html

math.randomseed( os.time() ) -- Random seed from the number generator

-- simpleAI by: https://github.com/NickEnbachtov/plugins-template-library-docs/releases/tag/v1.8
-- local simpleAI = require 'plugin.simpleAI.plugin.SimpleAI'

--[[

    The following code format was taken from: 
    https://docs.coronalabs.com/guide/programming/02/index.html

]]
-- Set up filters
collisionFilters.setupFilters(
{
    player = { "zombies", "border" },
    border = "player",
})
  
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

local width = display.contentWidth
local height = display.contentHeight
-- Global variable for the center of the screen -- Milan
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

local border = display.newLine(mainLayer, 15, 15, 15, display.contentHeight - 15, display.contentWidth - 15, display.contentHeight - 15, display.contentWidth + 15, 0, 0, 0)
border:setStrokeColor(1, 0, 0, 1)
border.strokeWidth = 8
local borderFilter = collisionFilters.getFilter( "border" )
physics.addBody( border, "static" , { isSensor = true, filter = borderFilter } )
border.myName = "border"
local worldCollisionFilter = { categoryBits=1, maskBits=6 }  -- Floor collides only with 2 and 4
-- We will start creating our Methods / Functions -- Milan
--[[
    This snippet of code was taken from: 
    https://docs.coronalabs.com/guide/programming/02/index.html
]]
local function createTrees()
    local num = math.random(2,5)
    for i = 1, num, 1 do
        local treeSizeW = math.random(100,250)
        local treeSizeH = math.random(80,120)
        local tree = display.newImageRect( treesLayer, "/resources/images/trees.jpg", treeSizeH, treeSizeW )
        tree.x = math.random(50, display.contentWidth-50)
        tree.y = math.random(50, display.contentHeight-50)
        tree.myName = "tree"
        tree.alpha = 0.8
    
    end
end
-- I want the stones to spawn in the corners, so we will use an array and correlate the values with the corners -- Milan
local function createStones()
    local num = math.random(0, 2)
    local corners = {1,2,3,4}
    corners = shuffle(corners)
    print(corners)
    for i = 1, num, 1 do
        local boulder = display.newImageRect( mainLayer, "/resources/images/boulder.jpg", 100, 100 )
        local slightAlternation = math.random(0,25)
        local offset = 120 + slightAlternation
        if corners[i] == 1 then
            boulder.x = offset
            boulder.y = offset
        elseif corners[i] == 2 then
            boulder.x = display.contentWidth - offset 
            boulder.y = offset
        elseif corners[i] == 3 then
            boulder.x = offset 
            boulder.y = display.contentHeight - offset
        elseif corners[i] == 4 then
            boulder.x = display.contentWidth - offset
            boulder.y = display.contentHeight - offset
        end
    end
end
-- Fisher-Yates Shuffle: https://programming-idioms.org/idiom/10/shuffle-a-list/1313/lua
function shuffle(tbl)
    for i = #tbl, 2, -1 do
		local j = math.random(i)
		tbl[i], tbl[j] = tbl[j], tbl[i]
	end
    return tbl
end
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
    -- zombiesArray.insert( zombiesArray, newZombie )
    local whereFrom = math.random( 12 )
 
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
    Milan: Had to change this up a bit
    ]]
    
    
    if (whereFrom >= 1) and (whereFrom <= 3) then
        newZombie.x = -80
        newZombie.y = centerY + math.random( display.contentHeight )
    elseif (whereFrom >= 4) and (whereFrom <= 6) then
        newZombie.x = centerX + math.random( display.contentWidth )
        newZombie.y = height + 80
    elseif (whereFrom >= 7) and (whereFrom <= 9) then
        newZombie.x =  width + 80
        newZombie.y = centerY - math.random( display.contentHeight )
    elseif (whereFrom >= 10) and (whereFrom <= 12) then
        newZombie.x = centerX - math.random( display.contentWidth )
        newZombie.y = -80
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

--[[
-- Player Movement and Controls -- Italo
local function onKeyEvent( event )
    local pSpeed = 10 -- Speed of the player

    -- If the "a" key was pressed, move the player left
    if(event.keyName == "a") then
        player.x = player.x - pSpeed
    end

    -- If the "d" key was pressed, move the player right
    if(event.keyName == "d") then
        player.x = player.x + pSpeed
    end

    -- If the "w" key was pressed, move the player up
    if(event.keyName == "w") then
        player.y = player.y - pSpeed
    end

    -- If the "s" key was pressed, move the player down
    if(event.keyName == "s") then
        player.y = player.y + pSpeed
    end

    if(event.keyName == "escape") then
        -- If the "escape" key was pressed, go back to the main menu
        composer.gotoScene( "main_menu" )
    end
end]]
-- physics.addBody( newLaser, "dynamic", { isSensor=true } )
---[[
local xAxis = 0
local yAxis = 0
local A = false
local D = false
local W = false
local S = false 
-- Player Movement and Controls -- Italo
local function onKeyEvent( event )
    -- local pSpeed = 10 -- Speed of the player
    local speed = 150 -- Speed of the player

    
    -- If the "a" key was pressed, move the player left
    if(event.keyName == "a" and event.phase == "down" ) then
        -- player.x = player.x - pSpeed
        -- player:setLinearVelocity( -50, 0 )
        xAxis = xAxis + speed * -1
        A = true
    end
    
    if(event.keyName == "a" and event.phase == "up") then
        -- player.x = player.x - pSpeed
        xAxis = xAxis + speed 
        A = false
    end
    
    if(event.keyName == "s" and event.phase == "down"  ) then
        -- player.x = player.x - pSpeed
        yAxis = yAxis + speed
        S = true
    end
    if(event.keyName == "s" and event.phase == "up"  ) then
        -- player.x = player.x - pSpeed
        yAxis = yAxis + speed * -1
        S = false
    end    
    

    if(event.keyName == "w" and event.phase == "down"  ) then
        -- player.x = player.x - pSpeed
        -- player:setLinearVelocity( 0, -50 )
        yAxis = yAxis + speed * -1
        W = true
    end

    if(event.keyName == "w" and event.phase == "up"  ) then
        -- player.x = player.x - pSpeed
        yAxis = yAxis + speed
        W = false
    end



    
    
    if(event.keyName == "d" and event.phase == "down" ) then
        -- player.x = player.x - pSpeed
        xAxis = xAxis + speed 
        D = true
    end

    if(event.keyName == "d" and event.phase == "up" ) then
        -- player.x = player.x - pSpeed
        xAxis = xAxis + speed * -1
        D = false
    end


    player:setLinearVelocity( xAxis, yAxis )


    if(event.keyName == "escape") then
        -- If the "escape" key was pressed, go back to the main menu
        composer.gotoScene( "main_menu" )
    end
    return true
end
--]]

-- Add the key event listener
Runtime:addEventListener( "key", onKeyEvent )

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
    -- distance = 800
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
    -- local message = "Mouse Position = (" .. tostring(event.x) .. "," .. tostring(event.y) .. ")"
    -- print( message )
    -- Update the mouseX and mouseY variables.
    mouseX = event.x
    mouseY = event.y
    -- shoot()

end
           

local function gameLoop()
    print("PRINT")
    -- createZombie()
    shoot()

end

local function onCollision( event )

	if ( event.phase == "began" ) then

		local obj1 = event.object1
		local obj2 = event.object2

		if ( ( obj1.myName == "border" and obj2.myName == "character" ) or
			 ( obj1.myName == "character" and obj2.myName == "border" ) )
		then
			-- Remove both the laser and asteroid
			-- display.remove( obj1 )
			-- display.remove( obj2 )
            print("World Border")
            --[[
			for i = #asteroidsTable, 1, -1 do
				if ( asteroidsTable[i] == obj1 or asteroidsTable[i] == obj2 ) then
					table.remove( asteroidsTable, i )
					break
				end
			end

			-- Increase score
			score = score + 100
			scoreText.text = "Score: " .. score
]]
		elseif ( ( obj1.myName == "ship" and obj2.myName == "asteroid" ) or
				 ( obj1.myName == "asteroid" and obj2.myName == "ship" ) )
		then
			if ( died == false ) then
				died = true

				-- Update lives
				lives = lives - 1
				livesText.text = "Lives: " .. lives

				if ( lives == 0 ) then
					display.remove( ship )
					timer.performWithDelay( 2000, endGame )
				else
					ship.alpha = 0
					timer.performWithDelay( 1000, restoreShip )
				end
			end
		end
	end
end

createTrees()
createStones()
gameLoopTimer = timer.performWithDelay( 500, gameLoop, 0 )

-- Add the mouse event listener.
Runtime:addEventListener( "mouse", onMouseEvent )

-- player:addEventListener( "touch", dragPlayer )
background:addEventListener("tap", shoot)
Runtime:addEventListener( "collision", onCollision )
