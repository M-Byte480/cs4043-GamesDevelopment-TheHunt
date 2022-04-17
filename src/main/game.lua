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
local health = 100

-- IMPORTANT VARIABLES:
zombieSpeed = 100
local zombiesArray = {}
globalBulletSpeed = 2500
TimeDuration = 1000

local character
local gameLoopTimer
local hourHandTimer
local scoreText
local timeDisplay
local inventoryBox1
local inventoryBox2
local crossbowImg
local torchImg
local basicClock



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
local darknessLayer = display.newGroup()
local userInterface = display.newGroup()

-- =================== Background and player Spawning =================== --
-- We will create image objects and insert them into their corresponding groups ~ Milan
-- local background = display.newImageRect( backgroundLayer, "/resources/images/background.png", display.contentWidth, display.contentHeight )
local player = display.newImageRect( mainLayer, "/resources/images/character.png", 100, 100 )

local inventoryBox1 = display.newImageRect( userInterface, "/resources/images/InventoryIcon.png" , 75, 75)
inventoryBox1.x = display.contentCenterX - 600
inventoryBox1.y = display.contentCenterY + 300

local inventoryBox2 = display.newImageRect( userInterface, "/resources/images/InventoryIcon.png", 75, 75)
inventoryBox2.x = display.contentCenterX - 700
inventoryBox2.y = display.contentCenterY + 300

local crossbowImg = display.newImageRect( userInterface, "/resources/images/crossbow.png", 40, 40)
crossbowImg.x = display.contentCenterX - 700
crossbowImg.y = display.contentCenterY +300

local torchImg = display.newImageRect( userInterface, "/resources/images/torch.png", 50, 50)
torchImg.x = display.contentCenterX - 600
torchImg.y = display.contentCenterY + 300

local basicClock = display.newImageRect( userInterface, "/resources/images/clock.png", 150, 150)
basicClock.x = display.contentCenterX 
basicClock.y = display.contentCenterY -270

local clockhand = display.newImageRect(userInterface, "/resources/images/clockhand.png" , 80,60)
clockhand.x = display.contentCenterX
clockhand.y = display.contentCenterY -295
-- NEW BACKGROUND GENERATION 

local function backgroundGrass()

    local topOne = math.random(6)
    local topTwo = math.random(6)
    local topThree = math.random(6)
    local botOne = math.random(6)
    local botTwo = math.random(6)
    local botThree = math.random(6)

    -- tile 1 

    if topOne == 1 then
      local a = display.newImageRect(backgroundLayer, "/resources/images/tileOne.png", 516, 432 )
      a.x = display.contentCenterX - 500
      a.y = display.contentCenterY - 175
    elseif topOne == 2 then
        local b = display.newImageRect(backgroundLayer, "/resources/images/tileTwo.png", 516, 432 )
        b.x = display.contentCenterX - 500
        b.y = display.contentCenterY - 175
      
    elseif topOne == 3 then
        local c = display.newImageRect(backgroundLayer, "/resources/images/tileThree.png", 516, 432 )
        c.x = display.contentCenterX - 500
        c.y = display.contentCenterY - 175

    elseif topOne == 4 then
        local d = display.newImageRect(backgroundLayer, "/resources/images/tileFour.png", 516, 432 )
        d.x = display.contentCenterX - 500
        d.y = display.contentCenterY - 175

    elseif topOne == 5 then
        local e = display.newImageRect(backgroundLayer, "/resources/images/tileFive.png", 516, 432 )
        e.x = display.contentCenterX - 500
        e.y = display.contentCenterY - 175

    elseif topOne == 6 then
        local f = display.newImageRect(backgroundLayer, "/resources/images/tileSix.png", 516, 432 )
        f.x = display.contentCenterX - 500
        f.y = display.contentCenterY - 175

    end

    -- tile 2 ( ITS CENTERED )
    if topTwo == 1 then
        local a = display.newImageRect(backgroundLayer, "/resources/images/tileOne.png", 516, 432 )
        a.x = display.contentCenterX 
        a.y = display.contentCenterY - 175
      elseif topTwo == 2 then
          local b = display.newImageRect(backgroundLayer, "/resources/images/tileTwo.png", 516, 432 )
          b.x = display.contentCenterX 
          b.y = display.contentCenterY - 175
        
      elseif topTwo == 3 then
          local c = display.newImageRect(backgroundLayer, "/resources/images/tileThree.png", 516, 432 )
          c.x = display.contentCenterX
          c.y = display.contentCenterY - 175
  
      elseif topTwo == 4 then
          local d = display.newImageRect(backgroundLayer, "/resources/images/tileFour.png", 516, 432 )
          d.x = display.contentCenterX 
          d.y = display.contentCenterY - 175
  
      elseif topTwo == 5 then
          local e = display.newImageRect(backgroundLayer, "/resources/images/tileFive.png", 516, 432 )
          e.x = display.contentCenterX 
          e.y = display.contentCenterY - 175
  
      elseif topTwo == 6 then
          local f = display.newImageRect(backgroundLayer, "/resources/images/tileSix.png", 516, 432 )
          f.x = display.contentCenterX 
          f.y = display.contentCenterY - 175
  
      end


      -- tile 3 (INVERSE OF TILE 1)
      if topThree == 1 then
        local a = display.newImageRect(backgroundLayer, "/resources/images/tileOne.png", 516, 432 )
        a.x = display.contentCenterX + 500
        a.y = display.contentCenterY - 175
      elseif topThree == 2 then
          local b = display.newImageRect(backgroundLayer, "/resources/images/tileTwo.png", 516, 432 )
          b.x = display.contentCenterX + 500
          b.y = display.contentCenterY - 175
        
      elseif topThree == 3 then
          local c = display.newImageRect(backgroundLayer, "/resources/images/tileThree.png", 516, 432 )
          c.x = display.contentCenterX + 500
          c.y = display.contentCenterY - 175
  
      elseif topThree == 4 then
          local d = display.newImageRect(backgroundLayer, "/resources/images/tileFour.png", 516, 432 )
          d.x = display.contentCenterX + 500
          d.y = display.contentCenterY - 175
  
      elseif topThree == 5 then
          local e = display.newImageRect(backgroundLayer, "/resources/images/tileFive.png", 516, 432 )
          e.x = display.contentCenterX + 500
          e.y = display.contentCenterY - 175
  
      elseif topThree == 6 then
          local f = display.newImageRect(backgroundLayer, "/resources/images/tileSix.png", 516, 432 )
          f.x = display.contentCenterX + 500
          f.y = display.contentCenterY - 175
  
      end

      -- TILE 4 (INVERSE Y OF 1)
      if botOne == 1 then
        local a = display.newImageRect(backgroundLayer, "/resources/images/tileOne.png", 516, 432 )
        a.x = display.contentCenterX - 500
        a.y = display.contentCenterY + 175
      elseif botOne == 2 then
          local b = display.newImageRect(backgroundLayer, "/resources/images/tileTwo.png", 516, 432 )
          b.x = display.contentCenterX - 500
          b.y = display.contentCenterY + 175
        
      elseif botOne == 3 then
          local c = display.newImageRect(backgroundLayer, "/resources/images/tileThree.png", 516, 432 )
          c.x = display.contentCenterX - 500
          c.y = display.contentCenterY + 175
  
      elseif botOne == 4 then
          local d = display.newImageRect(backgroundLayer, "/resources/images/tileFour.png", 516, 432 )
          d.x = display.contentCenterX - 500
          d.y = display.contentCenterY + 175
  
      elseif botOne == 5 then
          local e = display.newImageRect(backgroundLayer, "/resources/images/tileFive.png", 516, 432 )
          e.x = display.contentCenterX - 500
          e.y = display.contentCenterY + 175
  
      elseif botOne == 6 then
          local f = display.newImageRect(backgroundLayer, "/resources/images/tileSix.png", 516, 432 )
          f.x = display.contentCenterX - 500
          f.y = display.contentCenterY + 175
  
      end

      -- tile 5 ( ITS CENTERED )
    if botTwo == 1 then
        local a = display.newImageRect(backgroundLayer, "/resources/images/tileOne.png", 516, 432 )
        a.x = display.contentCenterX 
        a.y = display.contentCenterY + 175
      elseif botTwo == 2 then
          local b = display.newImageRect(backgroundLayer, "/resources/images/tileTwo.png", 516, 432 )
          b.x = display.contentCenterX 
          b.y = display.contentCenterY + 175
        
      elseif botTwo == 3 then
          local c = display.newImageRect(backgroundLayer, "/resources/images/tileThree.png", 516, 432 )
          c.x = display.contentCenterX
          c.y = display.contentCenterY + 175
  
      elseif botTwo == 4 then
          local d = display.newImageRect(backgroundLayer, "/resources/images/tileFour.png", 516, 432 )
          d.x = display.contentCenterX 
          d.y = display.contentCenterY + 175
  
      elseif botTwo == 5 then
          local e = display.newImageRect(backgroundLayer, "/resources/images/tileFive.png", 516, 432 )
          e.x = display.contentCenterX 
          e.y = display.contentCenterY + 175
  
      elseif botTwo == 6 then
          local f = display.newImageRect(backgroundLayer, "/resources/images/tileSix.png", 516, 432 )
          f.x = display.contentCenterX 
          f.y = display.contentCenterY + 175
  
      end

      -- tile 6 (INVERSE OF TILE 3)
      if topThree == 1 then
        local a = display.newImageRect(backgroundLayer, "/resources/images/tileOne.png", 516, 432 )
        a.x = display.contentCenterX + 500
        a.y = display.contentCenterY + 175
      elseif topThree == 2 then
          local b = display.newImageRect(backgroundLayer, "/resources/images/tileTwo.png", 516, 432 )
          b.x = display.contentCenterX + 500
          b.y = display.contentCenterY + 175
        
      elseif topThree == 3 then
          local c = display.newImageRect(backgroundLayer, "/resources/images/tileThree.png", 516, 432 )
          c.x = display.contentCenterX + 500
          c.y = display.contentCenterY + 175
  
      elseif topThree == 4 then
          local d = display.newImageRect(backgroundLayer, "/resources/images/tileFour.png", 516, 432 )
          d.x = display.contentCenterX + 500
          d.y = display.contentCenterY + 175
  
      elseif topThree == 5 then
          local e = display.newImageRect(backgroundLayer, "/resources/images/tileFive.png", 516, 432 )
          e.x = display.contentCenterX + 500
          e.y = display.contentCenterY + 175
  
      elseif topThree == 6 then
          local f = display.newImageRect(backgroundLayer, "/resources/images/tileSix.png", 516, 432 )
          f.x = display.contentCenterX + 500
          f.y = display.contentCenterY + 175
  
      end

 

end


local function backgroundSnow()

    local topOne = math.random(6)
    local topTwo = math.random(6)
    local topThree = math.random(6)
    local botOne = math.random(6)
    local botTwo = math.random(6)
    local botThree = math.random(6)

    -- tile 1 

    if topOne == 1 then
      local a = display.newImageRect(backgroundLayer, "/resources/images/snowOne.png", 516, 432 )
      a.x = display.contentCenterX - 500
      a.y = display.contentCenterY - 175
    elseif topOne == 2 then
        local b = display.newImageRect(backgroundLayer, "/resources/images/snowTwo.png", 516, 432 )
        b.x = display.contentCenterX - 500
        b.y = display.contentCenterY - 175
      
    elseif topOne == 3 then
        local c = display.newImageRect(backgroundLayer, "/resources/images/snowThree.png", 516, 432 )
        c.x = display.contentCenterX - 500
        c.y = display.contentCenterY - 175

    elseif topOne == 4 then
        local d = display.newImageRect(backgroundLayer, "/resources/images/snowFour.png", 516, 432 )
        d.x = display.contentCenterX - 500
        d.y = display.contentCenterY - 175

    elseif topOne == 5 then
        local e = display.newImageRect(backgroundLayer, "/resources/images/snowFive.png", 516, 432 )
        e.x = display.contentCenterX - 500
        e.y = display.contentCenterY - 175

    elseif topOne == 6 then
        local f = display.newImageRect(backgroundLayer, "/resources/images/snowSix.png", 516, 432 )
        f.x = display.contentCenterX - 500
        f.y = display.contentCenterY - 175

    end

    -- tile 2 ( ITS CENTERED )
    if topTwo == 1 then
        local a = display.newImageRect(backgroundLayer, "/resources/images/snowOne.png", 516, 432 )
        a.x = display.contentCenterX 
        a.y = display.contentCenterY - 175
      elseif topTwo == 2 then
          local b = display.newImageRect(backgroundLayer, "/resources/images/snowTwo.png", 516, 432 )
          b.x = display.contentCenterX 
          b.y = display.contentCenterY - 175
        
      elseif topTwo == 3 then
          local c = display.newImageRect(backgroundLayer, "/resources/images/snowThree.png", 516, 432 )
          c.x = display.contentCenterX
          c.y = display.contentCenterY - 175
  
      elseif topTwo == 4 then
          local d = display.newImageRect(backgroundLayer, "/resources/images/snowFour.png", 516, 432 )
          d.x = display.contentCenterX 
          d.y = display.contentCenterY - 175
  
      elseif topTwo == 5 then
          local e = display.newImageRect(backgroundLayer, "/resources/images/snowFive.png", 516, 432 )
          e.x = display.contentCenterX 
          e.y = display.contentCenterY - 175
  
      elseif topTwo == 6 then
          local f = display.newImageRect(backgroundLayer, "/resources/images/snowSix.png", 516, 432 )
          f.x = display.contentCenterX 
          f.y = display.contentCenterY - 175
  
      end


      -- tile 3 (INVERSE OF TILE 1)
      if topThree == 1 then
        local a = display.newImageRect(backgroundLayer, "/resources/images/snowOne.png", 516, 432 )
        a.x = display.contentCenterX + 500
        a.y = display.contentCenterY - 175
      elseif topThree == 2 then
          local b = display.newImageRect(backgroundLayer, "/resources/images/snowTwo.png", 516, 432 )
          b.x = display.contentCenterX + 500
          b.y = display.contentCenterY - 175
        
      elseif topThree == 3 then
          local c = display.newImageRect(backgroundLayer, "/resources/images/snowThree.png", 516, 432 )
          c.x = display.contentCenterX + 500
          c.y = display.contentCenterY - 175
  
      elseif topThree == 4 then
          local d = display.newImageRect(backgroundLayer, "/resources/images/snowFour.png", 516, 432 )
          d.x = display.contentCenterX + 500
          d.y = display.contentCenterY - 175
  
      elseif topThree == 5 then
          local e = display.newImageRect(backgroundLayer, "/resources/images/snowFive.png", 516, 432 )
          e.x = display.contentCenterX + 500
          e.y = display.contentCenterY - 175
  
      elseif topThree == 6 then
          local f = display.newImageRect(backgroundLayer, "/resources/images/snowSix.png", 516, 432 )
          f.x = display.contentCenterX + 500
          f.y = display.contentCenterY - 175
  
      end

      -- TILE 4 (INVERSE Y OF 1)
      if botOne == 1 then
        local a = display.newImageRect(backgroundLayer, "/resources/images/snowOne.png", 516, 432 )
        a.x = display.contentCenterX - 500
        a.y = display.contentCenterY + 175
      elseif botOne == 2 then
          local b = display.newImageRect(backgroundLayer, "/resources/images/snowTwo.png", 516, 432 )
          b.x = display.contentCenterX - 500
          b.y = display.contentCenterY + 175
        
      elseif botOne == 3 then
          local c = display.newImageRect(backgroundLayer, "/resources/images/snowThree.png", 516, 432 )
          c.x = display.contentCenterX - 500
          c.y = display.contentCenterY + 175
  
      elseif botOne == 4 then
          local d = display.newImageRect(backgroundLayer, "/resources/images/snowFour.png", 516, 432 )
          d.x = display.contentCenterX - 500
          d.y = display.contentCenterY + 175
  
      elseif botOne == 5 then
          local e = display.newImageRect(backgroundLayer, "/resources/images/snowFive.png", 516, 432 )
          e.x = display.contentCenterX - 500
          e.y = display.contentCenterY + 175
  
      elseif botOne == 6 then
          local f = display.newImageRect(backgroundLayer, "/resources/images/snowSix.png", 516, 432 )
          f.x = display.contentCenterX - 500
          f.y = display.contentCenterY + 175
  
      end

      -- tile 5 ( ITS CENTERED )
    if botTwo == 1 then
        local a = display.newImageRect(backgroundLayer, "/resources/images/snowOne.png", 516, 432 )
        a.x = display.contentCenterX 
        a.y = display.contentCenterY + 175
      elseif botTwo == 2 then
          local b = display.newImageRect(backgroundLayer, "/resources/images/snowTwo.png", 516, 432 )
          b.x = display.contentCenterX 
          b.y = display.contentCenterY + 175
        
      elseif botTwo == 3 then
          local c = display.newImageRect(backgroundLayer, "/resources/images/snowThree.png", 516, 432 )
          c.x = display.contentCenterX
          c.y = display.contentCenterY + 175
  
      elseif botTwo == 4 then
          local d = display.newImageRect(backgroundLayer, "/resources/images/snowFour.png", 516, 432 )
          d.x = display.contentCenterX 
          d.y = display.contentCenterY + 175
  
      elseif botTwo == 5 then
          local e = display.newImageRect(backgroundLayer, "/resources/images/snowFive.png", 516, 432 )
          e.x = display.contentCenterX 
          e.y = display.contentCenterY + 175
  
      elseif botTwo == 6 then
          local f = display.newImageRect(backgroundLayer, "/resources/images/snowSix.png", 516, 432 )
          f.x = display.contentCenterX 
          f.y = display.contentCenterY + 175
  
      end

      -- tile 6 (INVERSE OF TILE 3)
      if topThree == 1 then
        local a = display.newImageRect(backgroundLayer, "/resources/images/snowOne.png", 516, 432 )
        a.x = display.contentCenterX + 500
        a.y = display.contentCenterY + 175
      elseif topThree == 2 then
          local b = display.newImageRect(backgroundLayer, "/resources/images/snowTwo.png", 516, 432 )
          b.x = display.contentCenterX + 500
          b.y = display.contentCenterY + 175
        
      elseif topThree == 3 then
          local c = display.newImageRect(backgroundLayer, "/resources/images/snowThree.png", 516, 432 )
          c.x = display.contentCenterX + 500
          c.y = display.contentCenterY + 175
  
      elseif topThree == 4 then
          local d = display.newImageRect(backgroundLayer, "/resources/images/snowFour.png", 516, 432 )
          d.x = display.contentCenterX + 500
          d.y = display.contentCenterY + 175
  
      elseif topThree == 5 then
          local e = display.newImageRect(backgroundLayer, "/resources/images/snowFive.png", 516, 432 )
          e.x = display.contentCenterX + 500
          e.y = display.contentCenterY + 175
  
      elseif topThree == 6 then
          local f = display.newImageRect(backgroundLayer, "/resources/images/snowSix.png", 516, 432 )
          f.x = display.contentCenterX + 500
          f.y = display.contentCenterY + 175
  
      end

 

end





-- We will display them in the correct position -- Milan
-- background.x = display.contentCenterX
-- background.y = display.contentCenterY
-- background.x = display.contentCenterX
-- background.y = display.contentCenterY


-- night

local darkLayer = display.newImageRect(darknessLayer, "/resources/images/nightOverlay.png", 1536, 864)
darkLayer.x = display.contentCenterX
darkLayer.y = display.contentCenterY
darkLayer.alpha = 0

--timer.performWithDelay(3000, nightCycle)





-- SPRITE FOR BUSH SPAWNING
local sheetOptions =
{
    width = 88,
    height = 85,
    numFrames = 5
}

local sheet_bush = graphics.newImageSheet("/resources/images/bushSprite.png", sheetOptions )

-- sequence table 
local sequencesBush = {
    -- consecutive frames sequence
    {
        name = "normalRun",
        start = 3,
        count = 4,
        time = 2000,
        loopCount = 0,
        loopDirection = "forward"
    }
}


-- ===== Bush Spawner ===== --
local bush = display.newSprite(backgroundLayer ,sheet_bush, sequencesBush, bushSizeH, bushSizeW)
    local num = math.random(2,10)
    for i = 1, num, 1 do
    
        bush.x = math.random(50, display.contentWidth-50)
        bush.y = math.random(50, display.contentHeight-50)
        bush.myName = "bush"
        bush.alpha = 1
    end
bush:play()

-- === Player === --
player.x = display.contentCenterX
player.y = display.contentCenterY
player.alpha = 0.96         -- Slight transparency gives a nice effect and the player will intake more detail -- Milan
physics.addBody( player, { radius = 50, filter= playerCollisionFilter } )
player.myName = "character"   

-- =================== WORLD BORDER =================== --
-- local border = display.newLine(mainLayer, 15, 15, 15, display.contentHeight - 15, display.contentWidth - 15, display.contentHeight - 15, display.contentWidth + 15, 0, 0, 0)
local border = display.newLine(mainLayer, -5, 75, width+10, 75, width+10, height - 75,   -5, height - 75, -5, 75)
border:setStrokeColor(1, 0, 0, 1)
border.strokeWidth = 8
border.myName = "border"
physics.addBody( border, "static", { filter = borderCollisionFilter } )

local function worldBorder()

    local borderTree = display.newImageRect(mainLayer, "/resources/images/TREEBORDER.PNG", 134, 864)

    borderTree.x = display.contentCenterX - 750
    borderTree.y = display.contentCenterY

    local borderTreeLEFT = display.newImageRect(mainLayer, "/resources/images/TREEBORDER.PNG", 134, 864)
    borderTreeLEFT.x = display.contentCenterX + 750
    borderTreeLEFT.y = display.contentCenterY
    borderTreeLEFT:scale(-1, 1)
    


end

local function worldBorderSnow()

    local borderTree = display.newImageRect(mainLayer, "/resources/images/snowyBorder.png", 134, 864)

    borderTree.x = display.contentCenterX - 750
    borderTree.y = display.contentCenterY

    local borderTreeLEFT = display.newImageRect(mainLayer, "/resources/images/snowyBorder.png", 134, 864)
    borderTreeLEFT.x = display.contentCenterX + 750
    borderTreeLEFT.y = display.contentCenterY
    borderTreeLEFT:scale(-1, 1)


end

-- =================== User Interface =================== --
-- If we want to move the text as a group, just alternate these values -- Milan
local horizontalText = 600
local verticalText = 120

killCount = display.newText( userInterface , "Total kills: " .. kills, display.contentCenterX + horizontalText, verticalText + 10 , native.systemFont, 35 )
killCount:setFillColor( 0 , 0, 0 , 0.9 )

-- scoreText = display.newText( userInterface , "Points: " .. score, display.contentCenterX + horizontalText + 20, verticalText , native.systemFont, 40 )
-- scoreText:setFillColor( 255 , 0 , 0 , 0.9 ) -- Note to self, Syntax is the following: R,G,B,Alpha -- Milan

healthText = display.newText( userInterface, "Health: " .. health .. "hp", display.contentCenterX - horizontalText, verticalText + 10, native.systemFont, 35)
healthText:setFillColor( 0 , 0, 0 , 0.9 )

-- killCount = display.newText( userInterface , "Kills: " .. kills, display.contentCenterX + horizontalText, verticalText + 40 , native.systemFont, 40 )
-- killCount:setFillColor( 255 , 0 , 0 , 0.9 )

local function updateText()
    -- killCount.text = "Total kills: " .. kills
    healthText.text = "Health: " .. health .. "hp"

    killCount.text = "Kills: " .. kills
    -- scoreText.text = "Score: " .. score
end

-- ================== Functions =================== --
-- We will start creating our Methods / Functions -- Milan
--[[
    This snippet of code was taken from: 
    https://docs.coronalabs.com/guide/programming/02/index.html
]]--

-- ===== Tree Spawner ===== --
local function createNormalTrees()
    local num = math.random(2,5)
    for i = 1, num, 1 do
        local treeSizeW = math.random(175,250)
        local treeSizeH = math.random(80,100)
        local tree = display.newImageRect( treesLayer, "/resources/images/normalTree.png", treeSizeH, treeSizeW )
        tree.x = math.random(50, display.contentWidth-50)
        tree.y = math.random(50, display.contentHeight-50)
        tree.myName = "tree"
        tree.alpha = 0.8
        
    end
end

local function createSnowyTrees()
    local num = math.random(2,5)
    for i = 1, num, 1 do
        local treeSizeW = math.random(175,250)
        local treeSizeH = math.random(80,100)
        local tree = display.newImageRect( treesLayer, "/resources/images/snowyTree1.png", treeSizeH, treeSizeW)
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
        local boulder = display.newImageRect( backgroundLayer, "/resources/images/stone.png", 100, 100)
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
end
 
-- Add the key event listener
Runtime:addEventListener( "key", onKeyEvent )

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

-- ====== Returns coordinate of the point that is meant to be circle of given the radius, center and angle ====== --
function translateOrigin(x1, y1, angle, radius)
    
    local x2 = radius * math.cos(angle)
    x2 = x2 + x1
    
    local y2 = radius * math.sin(angle)
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

-- =========== Clock movement =========== --
local clockhand = display.newImageRect(userInterface,"/resources/images/clockhand.png", 80 , 60)
local n = 0
local angle = 30
local centerOfClockX = basicClock.x
local centerOfClockY = basicClock.y

local function moveHourHand()

    -- local X1, Y1 = moveHandle()
    clockhand:rotate(angle)
    -- clockhand.x = X1
    -- clockhand.y = Y1
    clockhand.x = centerOfClockX
    clockhand.y = centerOfClockY
    -- return moveHourHand
    
end
--[[
function moveHandle()
    local clockhandHalf = clockhand.height / 2
    local x1, y1 = translateOrigin(centerOfClockX, centerOfClockY, clockhand.x, clockhand.y, 30, clockhandHalf)
    
end]]
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

    X, Y = translateOrigin(playerx, playery, onCircle, width)
    
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
				health = health - 1
				healthText.text = "Health: " .. health
                
				if ( health == 0 ) then
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
            -- score = score + 100
            -- scoreText.text = "Score: " .. score
        end 
    end
end

-- ========== Loops ========== --
-- ==== Main Loop ===== --
darknessTracker = 0
local function poggers()

    darknessTracker = darknessTracker + 1
    if(darknessTracker >= 0) then
        darkLayer.alpha = darkLayer.alpha + 0.1
    else
        darkLayer.alpha = darkLayer.alpha - 0.1
    end

    if (darknessTracker == 12) then
        darknessTracker = -12
    end
    -- darkLayer.alpha = darkLayer.alpha + 0.1

    print(darkLayer.alpha)


end

while darkLayer.alpha < 0.2 and darkLayer.alpha > 0.10 do
    clockH:rotate(15)
    
end


local function maskLoop()                                                   -- ## THIS IS THE ONE YOU'RE LOOKING FOR

local mask = graphics.newMask("maskLayer.png")
darkLayer:setMask(mask)
darkLayer.maskX , darkLayer.maskY = player.x - 750, player.y - 400
end

local function maskLoopArc()                                                   -- ## THIS IS THE ONE YOU'RE LOOKING FOR

    local mask = graphics.newMask("maskLayerARC.png", 500, 500)
    darkLayer:setMask(mask)
    darkLayer.maskX , darkLayer.maskY = player.x - 775, player.y - 425
    local x1, y1 = getPlayerPosition()
    local angle = getAngle(x1, y1, mouseX, mouseY)

    darkLayer.maskRotation = (angle*180/math.pi)
    end

local function gameLoop()

       --function playerLight(getPlayerPosition)

    --local mask = graphics.newMask("maskLayer.png")
    --darkLayer:setMask(mask)
    --darkLayer.maskX , darkLayer.maskY = player.x - 750, player.y - 400
    --end
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
    for i = #zombiesArray, 1 , -1 do
        -- Zombie AI
        local thisZombie = zombiesArray[i]
        zombieAI(thisZombie)

    end
end
-- =================== Main Methods Execution =================== --
-- == Create a set of trees and stones == --



-- createTrees()
createStones()
-- clock()
--createBush()
--playerLight()
worldBorder()


local BackgroundSelect = math.random(11)



-- Allocated appropriate trees for map selected above
if BackgroundSelect <  6 then
    createNormalTrees()
else
    createSnowyTrees()
end
-- Allocated appropriate Grass for map selected above
if BackgroundSelect <  6 then
    backgroundGrass()
else
    backgroundSnow()
end

if BackgroundSelect <  6 then
    worldBorder()
else
    worldBorderSnow()
end




-- CLOCK TEST
local function clock()

    local clockF = display.newImageRect(mainLayer, "clockFace.png", 200, 200 )
    clockF.x = display.contentCenterX
    clockF.y = display.contentCenterY - 250
    clockF.alpha = 1
    
    local clockH = display.newImageRect(userInterface, "clockHand2.png", 200, 200 )
    clockH.x = display.contentCenterX 
    clockH.y = display.contentCenterY - 250
    
end

-- clock()

-- == Loops such as spawning and shooting == --
gameLoopTimer = timer.performWithDelay( 250, gameLoop, 0 )
summoning = timer.performWithDelay(1000, createZombie, 0)
hourHandTimer = timer.performWithDelay(1000, moveHourHand , -1 )
fireRate = timer.performWithDelay(750, shoot, 0) -- Auto shoot
-- maskLoopTimer = timer.performWithDelay(1, maskLoop, 0)     
maskLoopTimer = timer.performWithDelay(1, maskLoopArc, 0)                                          


-- timer.performWithDelay(1, clockRotation, 0 )

poggersLoop = timer.performWithDelay(2000, poggers, 0) -- Calling the night cycle function 


-- fireRate = timer.performWithDelay(750, shoot, 0) -- Auto shoot
-- AUTO SHOOT WILL BE BETTER THAN TAP AS TAP DOESNT ALWAYS REGISTER 

-- == Listeners == --
Runtime:addEventListener( "key", onKeyEvent ) -- Add the key event listener
Runtime:addEventListener( "mouse", onMouseEvent ) -- Add the mouse event listener.
-- background:addEventListener("tap", shoot)
darkLayer:addEventListener("tap", shoot)
Runtime:addEventListener( "collision", onCollision )
-- Runtime:addEventListener("hour-change", hourHandTimer)

-- Copy and pasted the whole thing from documentation
local composer = require( "composer" )
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
 
 
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
 
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
 
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
end
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene