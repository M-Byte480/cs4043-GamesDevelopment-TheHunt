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
physics.setGravity( 0, 0 ) -- We wont need gravity

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
    ThePlayer = { "enemies", "powerUps", "border" },
    enemies = "playerBullets",
})
  

 



-- We will initliaze the variables to be used in the game -- Milan
local dead = false
local score = 0
local kills = 0
local seconds = 0
local minutes = 0

local zombiesArray = {}
globalBulletSpeed = 2500
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
local player = display.newImageRect( mainLayer, "/resources/images/character.png", 100, 100 )



-- We will display them in the correct position -- Milan
background.x = display.contentCenterX
background.y = display.contentCenterY

player.x = display.contentCenterX
player.y = display.contentCenterY
player.alpha = 0.96 -- Slight transparency gives a nice effect and the player will intake more detail -- Milan
--physics.addBody( player, "dynamic", { radius = 50, isSensor = true } )
local playerFilter = collisionFilters.getFilter( "ThePlayer" )
physics.addBody( player, { radius = 50, filter=playerFilter } )
player.myName = "character"   


-- If we want to move the text as a group, just alternate these values -- Milan
local horizontalText = 600
local verticalText = 120

scoreText = display.newText( userInterface , "Points: " .. score, display.contentCenterX + horizontalText + 20, verticalText , native.systemFont, 40 )
scoreText:setFillColor( 255 , 0 , 0 , 0.9 ) -- Note to self, Syntax is the following: R,G,B,Alpha -- Milan

killCount = display.newText( userInterface , "Kills: " .. kills, display.contentCenterX + horizontalText, verticalText + 40 , native.systemFont, 40 )
killCount:setFillColor( 255 , 0 , 0 , 0.9 )

local function updateText()
    killCount.text = "Kills: " .. kills
    scoreText.text = "Score: " .. score
end

local border = display.newLine(mainLayer, 15, 15, 15, display.contentHeight - 15, display.contentWidth - 15, display.contentHeight - 15, display.contentWidth + 15, 0, 0, 0)
border:setStrokeColor(1, 0, 0, 1)
border.strokeWidth = 8
border.myName = "border"
local borderFilter = collisionFilters.getFilter( "Border" )
physics.addBody( border, "static", { filter = borderFilter } )
-- physics.addBody( border, "dynamic" , { isSensor = true, filter = borderFilter } )

local worldCollisionFilter = { categoryBits=1, maskBits=6 }  -- Floor collides only with 2 and 4
local circle = display.newCircle( backgroundLayer, display.contentCenterX, display.contentCenterY, 55 )
circle:setFillColor(8,0,0)
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
    -- print(corners)
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

local function createZombie()
    local newZombie = display.newImageRect( mainLayer, "/resources/images/zombie.png", 120, 120 )
    newZombie.alpha = 0.96
    newZombie.myName = "zombie"
    table.insert( zombiesArray, newZombie )
    physics.addBody( newZombie, "dynamic", { radius = 50, friction = 10 } )
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


local xAxis = 0
local yAxis = 0
local A = false
local D = false
local W = false
local S = false 

-- Player Movement and Controls -- Italo & Milan
local function onKeyEvent( event )
    local speed = 500 -- Speed of the player

    -- If the "a" key was pressed, move the player left
    if(event.keyName == "a" and event.phase == "down" ) then
        xAxis = xAxis + speed * -1
        A = true
    end
    
    if(event.keyName == "a" and event.phase == "up") then
        xAxis = xAxis + speed 
        A = false
    end
    
    if(event.keyName == "s" and event.phase == "down"  ) then
        yAxis = yAxis + speed
        S = true
    end
    if(event.keyName == "s" and event.phase == "up"  ) then
        yAxis = yAxis + speed * -1
        S = false
    end    
    if(event.keyName == "w" and event.phase == "down"  ) then
        yAxis = yAxis + speed * -1
        W = true
    end

    if(event.keyName == "w" and event.phase == "up"  ) then
        yAxis = yAxis + speed
        W = false
    end

    if(event.keyName == "d" and event.phase == "down" ) then
        xAxis = xAxis + speed 
        D = true
    end

    if(event.keyName == "d" and event.phase == "up" ) then
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
    transitionTime = globalBulletSpeed

	local newBullet = display.newImageRect( mainLayer, "resources/images/bullet.png", 50, 50 )
    local x1, y1 = getPlayerPosition()
    local angle = getAngle(x1, y1, mouseX, mouseY)
    newBullet:rotate(angle*180/math.pi)
	physics.addBody( newBullet, "dynamic", { isSensor=true } )
	newBullet.isBullet = true
	newBullet.myName = "bullet"

	newBullet.x = player.x
	newBullet.y = player.y
    
	newBullet:toBack()
    -- We do some calculations
    -- We will translate 0,0 to the center

    local playerx, playery = getPlayerPosition()
    --local Y = mouseY - (playery - mouseY) + (playery - mouseY) * 5
    --local X = mouseX - (playerx - mouseX) + (playerx - mouseX) * 5
    local Y = mouseY
    local X = mouseX
    -- distance = 800
    local distance = math.sqrt( (X - playerx)^2 + (Y - playery)^2 )
    ---[[

    --]]
    -- print(distance)
--[[ Extend the bullet
    We will need to translate the player's and the mouses's coordinates to origin
    ]]
    local playerx, playery = getPlayerPosition()
    local onCircle = getAngle(playerx, playery, X, Y)

    X, Y = translateOrigin(playerx, playery, X, Y, onCircle)

	transition.to( newBullet, { y = Y, x = X, time=transitionTime, onComplete = function() display.remove( newBullet ) end	} )
end

function translateOrigin(x1, y1, x2, y2, angle)
    -- We will check which quadrant it falls onto
    local radius = width
    x2 = x2 - x1
    y2 = y2 - y1
    -- Translated the points to origin
    -- if angle < 0 then
    --     angle = angle * -1 + math.pi
    -- end
    
    -- x2 = x2 + extendx
    -- x2 = x2 + 150
    -- x2 = x2 * 2
    -- x2 = x2 + difference
    x2 = radius * math.cos(angle)
    x2 = x2 + x1

    -- y2 = y2 + extendy
    -- y2 = y2 + 150
    -- y2 = y2 * 2
    y2 = radius * math.sin(angle)
    y2 = y2 + y1

    return x2, y2
end


-- THE FOLLOWING WAS TAKEN FROM: https://fr.solar2d.net/api/event/mouse/x.html
mouseX = 0
mouseY = 0
-- Called when a mouse event has been received.

local function onMouseEvent( event )
    mouseX = event.x
    mouseY = event.y
end
           


local function onCollision( event )
    
	if ( event.phase == "began" ) then
        
		local obj1 = event.object1
		local obj2 = event.object2

		if ( ( obj1.myName == "border" and obj2.myName == "character" ) or
        ( obj1.myName == "character" and obj2.myName == "border" ) )
		then
			-- Remove both the laser and asteroid
            print("BORDER")
            
		elseif ( ( obj1.myName == "character" and obj2.myName == "zombie" ) or
        ( obj1.myName == "zombie" and obj2.myName == "character" ) )
		then
			if ( died == false ) then
				died = true
                
				-- Update lives
				lives = lives - 1
				livesText.text = "Lives: " .. lives
                
				if ( lives == 0 ) then
					display.remove( player )
					timer.performWithDelay( 2000, endGame )
				else
					player.alpha = 0
					timer.performWithDelay( 1000, restoreShip )
				end
			end
            
        elseif ( ( obj1.myName == "bullet" and obj2.myName == "zombie" ) or
        ( obj1.myName == "zombie" and obj2.myName == "bullet" ) ) then
            display.remove( obj1 )
            display.remove( obj2 )
            print("CRASHED")
 
            for i = #zombiesArray, 1, -1 do
                if ( zombiesArray[i] == obj1 or zombiesArray[i] == obj2 ) then
                    table.remove( zombiesArray, i )
                    break
                end
            end
            
            -- Increase score
            score = score + 100
            scoreText.text = "Score: " .. score
            
	    end
    end
end


local function gameLoop()
    -- print("PRINT")

    
    -- Remove asteroids which have drifted off screen
    for i = #zombiesArray, 1, -1 do
        local thisZombie = zombiesArray[i]

        if ( thisZombie.x < -100 or
            thisZombie.x > display.contentWidth + 100 or
            thisZombie.y < -100 or
            thisZombie.y > display.contentHeight + 100 )
        then
            display.remove( thisZombie )
            table.remove( zombiesArray, i )
        end
    end

end


createTrees()
createStones()
gameLoopTimer = timer.performWithDelay( 250, gameLoop, 0 )
-- summoning = timer.performWithDelay(1000, createZombie, 0)
fireRate = timer.performWithDelay(750, shoot, 0)
-- Add the mouse event listener.
Runtime:addEventListener( "mouse", onMouseEvent )

-- player:addEventListener( "touch", dragPlayer )
background:addEventListener("tap", shoot)
Runtime:addEventListener( "collision", onCollision )

function getAngle(x1, y1, x2, y2)
    local angle = math.atan2(y2 - y1, x2 - x1)
    -- print("The angle is; " .. angle*180/math.pi)
    return angle
end