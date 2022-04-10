-- This section is done by Milan
local physics = require("physics") -- Import the physics engine
physics.start() -- Start the physics engine

-- Import images:

-- Initializing the Variables
-- local lives = 1
local health = 100
local score = 0
local died = false

local boulder = {}
local trees = {}
local objects = {trees, boulder}

local player
local gameLoopTimer
local livesText
local timer
local killCount
local minutes, seconds = getTime()


-- Set up display groups
local backGroup
local mainGroup
local uiGroup

local function updateText()
    health.text = health .. " Hp"
    killCount.text = killCount .. " Kills"
    min, sec = updateTime()
    if (sec == 60) then
        sec = 0
    end
    timer.text = min .. ":" .. sec
end
local function getTime()
    -- local currentTimeInMillis = os.clock()
    -- local timeInHours =  60 * 60 * 1000
    -- local day = timeInHours * 24
    -- local timeOfToday = currentTimeInMillis % timeInHours
    -- local currentSeconds = currentTimeInMillis % (60 * 1000) / 60
    -- local currentMinutes = currentTimeInMillis % (60 * 60 * 1000) / 60
    -- return currentMinutes, currentSeconds
    local t = os.time("*t")
    return t.min, t.sec
end

local function updateTime()
    local now = os.time("*t")
    return minutes - now.min, seconds - now.sec
end

local function avoidObject() 
    
end
local function createTree()
    
end
local function createBoulder()

end
local function createPlayer()
    
end
local function upgradeCreatures()
    if (sec == 0) then
        -- print("New Minute")
    end
end
local function onCollision()

    if (event.phase == "began") then

        local obj1 = event.object1
        local obj2 = event.object2

        if ( ( obj1.myName == "laser" and obj2.myName == "asteroid" ) or
             ( obj1.myName == "asteroid" and obj2.myName == "laser" ) ) then
                 -- We will remove the asteroid upon collision
                 display.remove(obj1)
                 display.remove(obj2)
                
                 for i = #asteroidsTable, 1, -1 do
                     if (asteroidsTable[i] == obj1 or asteroidsTable[i] == obj2) then
                         table.remove(asteroidsTable, i)
                         break
                     end
                 end
                 
                 -- Increase their score Boi
                 score = score + 100
                 scoreText.text = "Score: " .. score
         end
        elseif ( (obj1.myName == "ship" and obj2.myName == "asteroid" ) or
                 (obj1.myName == "asteroid" and obj2.myName == "ship" )) then
                     if (died == false) then
                         died = true
                        -- Update lives 
                        lives = lives - 1
                        livesText.text = "Lives: " .. lives
                        if (lives == 0) then
                            display.remove(ship)
                        else
                            ship.alpha = 0
                            timer.performWithDelay(1000, restoreShip)
                        end

                     end
                     
        end
    end

-- print(updateText()) end

-- Copied this from the documentation::::
-- Called when a key event has been received
local function onKeyEvent( event )
 
    -- Print which key was pressed down/up
    local message = "Key '" .. event.keyName .. "' was pressed " .. event.phase
    print( message )
 
    -- If the "back" key was pressed on Android, prevent it from backing out of the app
    if ( event.keyName == "back" ) then
        if ( system.getInfo("platform") == "android" ) then
            return true
        end
    end
 
    -- IMPORTANT! Return false to indicate that this app is NOT overriding the received key
    -- This lets the operating system execute its default handling of the key
    return false
end
 
-- Add the key event listener
Runtime:addEventListener( "key", onKeyEvent )