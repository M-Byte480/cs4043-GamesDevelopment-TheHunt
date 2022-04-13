-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- https://docs.coronalabs.com/guide/programming/01/index.html
-- Modified contents: Milan

-- =========== Initalizing Section =========== --
-- We will only need physics for the collision detection
local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 ) -- We wont need gravity

display.setStatusBar( display.HiddenStatusBar )

math.randomseed( os.time() ) -- Random seed from the number generator

--[[

    The following code format was taken from: 
    https://docs.coronalabs.com/guide/programming/02/index.html

]]
-- =============== Collision filters =============== --
local playerCollisionFilter = { categoryBits=1, maskBits=22 }  
local zombieCollisionFilter = { categoryBits=2, maskBits=11 }    
local borderCollisionFilter = { categoryBits=4, maskBits=1 } 
local bulletCollisionFilter = { categoryBits=8, maskBits=18 }
local boulderCollisionFilter = { categoryBits=16, maskBits=13 }


-- =========== Global/local Variables =========== --
-- We will initliaze the variables to be used in the game -- Milan
local dead = false
local score = 0
local kills = 0
local seconds = 0
local minutes = 0

-- IMPORTANT VARIABLES:
zombieSpeed = 100
local zombiesArray = {}
globalBulletSpeed = 2500

local character
local gameLoopTimer
local scoreText
local timeDisplay

--  =========== Global Screen Size for easy reference =========== --
local width = display.contentWidth
local height = display.contentHeight
centerX = display.contentCenterX
centerY = display.contentCenterY
-- Global variable for the center of the screen -- Milan

-- =================== Layers =================== --
-- We will create 4 layers for display -- Milan
local backgroundLayer = display.newGroup()
local mainLayer = display.newGroup()
local treesLayer = display.newGroup()
local userInterface = display.newGroup()

-- =================== Background and player Spawning =================== --
-- We will create image objects and insert them into their corresponding groups ~ Milan
local background = display.newImageRect( backgroundLayer, "/resources/images/background.png", display.contentWidth, display.contentHeight )
local player = display.newImageRect( mainLayer, "/resources/images/character.png", 100, 100 )

-- We will display them in the correct position -- Milan
background.x = display.contentCenterX
background.y = display.contentCenterY

-- === Player === --
player.x = display.contentCenterX
player.y = display.contentCenterY
player.alpha = 0.96         -- Slight transparency gives a nice effect and the player will intake more detail -- Milan
physics.addBody( player, { radius = 50, filter= playerCollisionFilter } )
player.myName = "character"   

-- =================== WORLD BORDER =================== --
local border = display.newLine(mainLayer, -5, 75, width+10, 75, width+10, height - 75,   -5, height - 75, -5, 75)
border:setStrokeColor(1, 0, 0, 1)
border.strokeWidth = 8
border.myName = "border"
physics.addBody( border, "static", { filter = borderCollisionFilter } )


-- =================== User Interface =================== --
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

-- ================== Functions =================== --
-- We will start creating our Methods / Functions -- Milan
--[[
    This snippet of code was taken from: 
    https://docs.coronalabs.com/guide/programming/02/index.html
]]--

-- ===== Tree Spawner ===== --
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
-- ==== Stop Spawner ==== --
local function createStones()
    -- I want the stones to spawn in the corners, so we will use an array and correlate the values with the corners -- Milan
    local num = math.random(0, 2)
    local corners = {1,2,3,4}
    corners = shuffle(corners)
    -- print(corners)
    for i = 1, num, 1 do
        local boulder = display.newImageRect( backgroundLayer, "/resources/images/boulder.jpg", 100, 100)
        -- physics.addBody(mainLayer, "static", boulder, { filter = boulderCollisionFilter , radius = 10} )
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

-- ========== Zombie Spawner ========== --
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
    ~~ Milan: the numbers no longer relate to sections of the screen as I am using the whole screen for random spawn area
    ]]--
    
    
    local function createZombie()
    local newZombie = display.newImageRect( mainLayer, "/resources/images/zombie.png", 120, 120 )
    newZombie.alpha = 0.96
    newZombie.myName = "zombie"
    table.insert( zombiesArray, newZombie )
    physics.addBody( newZombie, "dynamic", { radius = 50, friction = 10 , filter = zombieCollisionFilter} )
    local whereFrom = math.random( 12 )
    
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

    -- === Helper function called === -- Probably my best creation -- Milan :)
    zombieAI(newZombie)
    
end

-- ====== Zombie AI to track the player ====== --
function zombieAI(object)
    local characterX, characterY = getPlayerPosition()
    local angleRadians = getAngle(object.x, object.y, characterX, characterY)
    object:setLinearVelocity( math.cos(angleRadians) * zombieSpeed, math.sin(angleRadians) * zombieSpeed )
end

-- ============ Helper Functions ============ --
-- === Shuffle Array === --
function shuffle(tbl)
    -- Fisher-Yates Shuffle: https://programming-idioms.org/idiom/10/shuffle-a-list/1313/lua
    for i = #tbl, 2, -1 do
		local j = math.random(i)
		tbl[i], tbl[j] = tbl[j], tbl[i]
	end
    return tbl
end



function getPlayerPosition()
    if ( dead == false ) then
        return player.x, player.y
    end
end

-- THE FOLLOWING WAS TAKEN FROM: https://fr.solar2d.net/api/event/mouse/x.html
mouseX = 0
mouseY = 0
-- Called when a mouse event has been received.

local function onMouseEvent( event )
    mouseX = event.x
    mouseY = event.y
end

-- ===== Returns angle between 2 points, towards the positive/negative side of the x-axis in radians ===== --
function getAngle(x1, y1, x2, y2)
    local angle = math.atan2(y2 - y1, x2 - x1)
    -- print("The angle is; " .. angle*180/math.pi)
    return angle
end

-- ====== Returns coordinate of the point that is meant to be circle of given the radius and angle ====== --
function translateOrigin(x1, y1, x2, y2, angle, radius)
    x2 = x2 - x1
    y2 = y2 - y1
    
    x2 = radius * math.cos(angle)
    x2 = x2 + x1
    
    y2 = radius * math.sin(angle)
    y2 = y2 + y1
    
    return x2, y2
end

-- ================ Player Control =================== --

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



-- =========== Shoot Function =========== --
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
    local Y = mouseY
    local X = mouseX
    -- distance = 800
    local distance = math.sqrt( (X - playerx)^2 + (Y - playery)^2 )
    
    --[[ Extend the bullet
    We will need to translate the player's and the mouses's coordinates to origin
    ]]
    
    local playerx, playery = getPlayerPosition()
    local onCircle = getAngle(playerx, playery, X, Y)

    X, Y = translateOrigin(playerx, playery, X, Y, onCircle, width)
    
	transition.to( newBullet, { y = Y, x = X, time=transitionTime, onComplete = function() display.remove( newBullet ) end	} )
end


-- ============== MAIN FUNCTIONS ============== --

local function onCollision( event )
    
	if ( event.phase == "began" ) then
        
		local obj1 = event.object1
		local obj2 = event.object2
        
        -- ======== Border Vs Character ======== --
		if ( ( obj1.myName == "border" and obj2.myName == "character" ) or
        ( obj1.myName == "character" and obj2.myName == "border" ) )
		then
			-- Remove both the laser and asteroid
            print("BORDER")
            
        -- ======== Character Vs Zombie ======== --
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
            print("Player Hurt")
        -- ======== Zombie Vs Bullet ======== --
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

-- ========== Loops ========== --
-- ==== Main Loop ===== --
local function gameLoop()
    -- print("PRINT")

    
    -- Remove asteroids which have drifted off screen
    --[[for i = #zombiesArray, 1, -1 do
        local thisZombie = zombiesArray[i]

        if ( thisZombie.x < -100 or
            thisZombie.x > display.contentWidth + 100 or
            thisZombie.y < -100 or
            thisZombie.y > display.contentHeight + 100 )
        then
            display.remove( thisZombie )
            table.remove( zombiesArray, i )
        end
    end]]
    print(getPlayerPosition())
    for i = #zombiesArray, 1 , -1 do
        -- Zombie AI
        local thisZombie = zombiesArray[i]
        zombieAI(thisZombie)

    end
end
-- =================== Main Methods Execution =================== --
-- == Create a set of trees and stones == --
createTrees()
createStones()

-- == Loops such as spawning and shooting == --
gameLoopTimer = timer.performWithDelay( 250, gameLoop, 0 )
-- summoning = timer.performWithDelay(1/100, createZombie, 0)
-- fireRate = timer.performWithDelay(1, shoot, 0) -- Auto shoot
-- AUTO SHOOT WILL BE BETTER THAN TAP AS TAP DOESNT ALWAYS REGISTER 

-- == Listeners == --
Runtime:addEventListener( "key", onKeyEvent ) -- Add the key event listener
Runtime:addEventListener( "mouse", onMouseEvent ) -- Add the mouse event listener.
background:addEventListener("tap", shoot)
Runtime:addEventListener( "collision", onCollision )
