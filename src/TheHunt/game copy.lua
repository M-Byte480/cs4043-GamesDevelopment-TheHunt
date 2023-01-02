-- The structure of the game was taken from the tutorial
-- https://docs.coronalabs.com/guide/programming/01/index.html
-- https://docs.coronalabs.com/guide/programming/02/index.html
-- Minecraft Font: https://www.cufonfonts.com/font/minecraft-3 
composer = require( "composer" )
 
local scene = composer.newScene()

function scene:create( event )
 
local sceneGroup = self.view
-- =========== Initalizing Section =========== --
-- We will only need physics for the collision detection
local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 ) -- We wont need gravity since its top down

display.setStatusBar( display.HiddenStatusBar )


-- Collision filter Documentation:
-- https://docs.coronalabs.com/plugin/collisionFilters/index.html
-- =============== Collision filters =============== --
local playerCollisionFilter = { categoryBits=1, maskBits=6 }  
local zombieCollisionFilter = { categoryBits=2, maskBits=3 }    
local borderCollisionFilter = { categoryBits=4, maskBits=1 } 



-- =========== Global/local Variables =========== --
-- We will initliaze the variables to be used in the game -- Milan
local dead = false
local kills = 0
local health = 1
local zombieHealth = 100
local bulletDamage = 100

-- IMPORTANT VARIABLES:
zombieSpeed = 100
local zombiesArray = {}
globalBulletSpeed = 2500
TimeDuration = 1000
fireRate = 1200
spawnRate = 1000
zombieDamage = 3

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
backgroundLayer = display.newGroup()
mainLayer = display.newGroup()
treesLayer = display.newGroup()
darknessLayer = display.newGroup()
userInterface = display.newGroup()
deathScreenInterface = display.newGroup()
-- =================== Background and player Spawning =================== --
-- We will create image objects and insert them into their corresponding groups -- Milan

-- The HUD was made by Stephen:
player = display.newImageRect( mainLayer, "/resources/images/character.png", 100, 100 )

inventoryBox1 = display.newImageRect( userInterface, "/resources/images/InventoryIcon.png" , 75, 75)
inventoryBox1.x = display.contentCenterX - 600
inventoryBox1.y = display.contentCenterY + 300

inventoryBox2 = display.newImageRect( userInterface, "/resources/images/InventoryIcon.png", 75, 75)
inventoryBox2.x = display.contentCenterX - 700
inventoryBox2.y = display.contentCenterY + 300

crossbowImg = display.newImageRect( userInterface, "/resources/images/crossbow.png", 40, 40)
crossbowImg.x = display.contentCenterX - 700
crossbowImg.y = display.contentCenterY +300

torchImg = display.newImageRect( userInterface, "/resources/images/torch.png", 50, 50)
torchImg.x = display.contentCenterX - 600
torchImg.y = display.contentCenterY + 300

basicClock = display.newImageRect( userInterface, "/resources/images/clock.png", 150, 150)
basicClock.x = display.contentCenterX 
basicClock.y = display.contentCenterY -270

clockhand = display.newImageRect(userInterface, "/resources/images/clockhand.png" , 80,60)
clockhand.x = display.contentCenterX
clockhand.y = display.contentCenterY -295


-- NEW BACKGROUND GENERATION 
-- Background generation was created by Marty:
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

-- Snowy background -- Marty
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






-- night effect -- Marty

local darkLayer = display.newImageRect(darknessLayer, "/resources/images/nightOverlay.png", 1536, 864)
darkLayer.x = display.contentCenterX
darkLayer.y = display.contentCenterY
darkLayer.alpha = 0


-- SPRITE FOR BUSH SPAWNING -- Marty
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


-- ===== Bush Spawner ===== -- Marty
local bush = display.newSprite(backgroundLayer ,sheet_bush, sequencesBush, bushSizeH, bushSizeW)
    local num = math.random(2,10)
    for i = 1, num, 1 do
    
        bush.x = math.random(50, display.contentWidth-50)
        bush.y = math.random(50, display.contentHeight-50)
        bush.myName = "bush"
        bush.alpha = 1
    end
bush:play()

-- === Player === -- Milan
player.x = display.contentCenterX
player.y = display.contentCenterY
player.alpha = 0.96     -- Slight transparency gives a nice effect 
physics.addBody( player, { radius = 50, filter= playerCollisionFilter } )
player.myName = "character"   

-- =================== WORLD BORDER =================== -- Milan + Marty
local border = display.newLine(mainLayer, -5, 75, width+10, 75, width+10, height - 75,   -5, height - 75, -5, 75)
border:setStrokeColor(1, 0, 0, 1)
border.strokeWidth = 8
border.myName = "border"
physics.addBody( border, "static", { filter = borderCollisionFilter } )

local function worldBorder() -- Art done by Marty

    local borderTree = display.newImageRect(mainLayer, "/resources/images/TREEBORDER.PNG", 134, 864)

    borderTree.x = display.contentCenterX - 750
    borderTree.y = display.contentCenterY

    local borderTreeLEFT = display.newImageRect(mainLayer, "/resources/images/TREEBORDER.PNG", 134, 864)
    borderTreeLEFT.x = display.contentCenterX + 750
    borderTreeLEFT.y = display.contentCenterY
    borderTreeLEFT:scale(-1, 1)
    
end

local function worldBorderSnow() -- Art done by Marty

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

-- This section was done by Stephen:
killCount = display.newText( userInterface , "Total kills: " .. kills, display.contentCenterX + horizontalText, verticalText + 10 , native.systemFont, 35 )
r, g, b, o =  0.8, 0.45, 0, 0.9
killCount:setFillColor( r, g, b, o )

healthText = display.newText( userInterface, "Health: " .. health .. "hp", display.contentCenterX - horizontalText, verticalText + 10, native.systemFont, 35)
healthText:setFillColor( r, g, b, o )

local function updateText()
    healthText.text = "Health: " .. health .. "hp"
    killCount.text = "Total kills: " .. kills
end

-- ================== Functions =================== --
-- We will start creating our mathematical Methods / Functions -- Milan
--[[
    This snippet of code was taken from: 
    https://docs.coronalabs.com/guide/programming/02/index.html
]]--

-- ===== Tree Spawner ===== -- Marty
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


-- ========== Zombie Spawner ========== -- By Milan

local function createZombie()
    -- Similar setup as player
    local newZombie = display.newImageRect( mainLayer, "/resources/images/zombie.png", 100, 100 )
    newZombie.alpha = 0.96
    newZombie.myName = "zombie"
    newZombie.health = zombieHealth
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

    -- === Helper function called === -- Probably my best creation -- Milan :D
    zombieAI(newZombie)

end

-- ====== Zombie AI to track the player ====== --
function zombieAI(object)
    -- Uses Unit circle to calculate the angle between the player and the zombie
    -- And then adjust the velocity (Speed and direction) of the zombie
    local characterX, characterY = getPlayerPosition()
    local angleRadians = getAngle(object.x, object.y, characterX, characterY)
    object:setLinearVelocity( math.cos(angleRadians) * zombieSpeed, math.sin(angleRadians) * zombieSpeed )
end

-- ============ Helper Functions ============ -- By Milan

-- Returns player's x and y position
function getPlayerPosition()
    if ( dead == false ) then
        return player.x, player.y
    end
end

-- THE FOLLOWING WAS TAKEN FROM: https://fr.solar2d.net/api/event/mouse/x.html
mouseX = 0
mouseY = 0

-- Returns mouse's x and y position
local function onMouseEvent( event )
    mouseX = event.x
    mouseY = event.y
end

-- ===== Returns angle between 2 points, towards the positive/negative side of the x-axis in radians ===== --
function getAngle(x1, y1, x2, y2)
    local angle = math.atan2(y2 - y1, x2 - x1)
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

-- ================ Player Control =================== -- By Italo

local xAxis = 0
local yAxis = 0

playerSpeed = 500
-- Player Movement and Controls -- 
local function onKeyEvent( event )
    local speed = playerSpeed -- Speed of the player

    if(event.keyName == "a" and event.phase == "down" ) then
        xAxis = xAxis + speed * -1
    end
    
    if(event.keyName == "a" and event.phase == "up") then
        xAxis = xAxis + speed 
    end
    
    if(event.keyName == "s" and event.phase == "down"  ) then
        yAxis = yAxis + speed
    end
    if(event.keyName == "s" and event.phase == "up"  ) then
        yAxis = yAxis + speed * -1
    end    
    if(event.keyName == "w" and event.phase == "down"  ) then
        yAxis = yAxis + speed * -1
    end

    if(event.keyName == "w" and event.phase == "up"  ) then
        yAxis = yAxis + speed
    end

    if(event.keyName == "d" and event.phase == "down" ) then
        xAxis = xAxis + speed 
    end

    if(event.keyName == "d" and event.phase == "up" ) then
        xAxis = xAxis + speed * -1
    end

    player:setLinearVelocity( xAxis, yAxis )


    return true
end

-- =========== Clock movement =========== --
local clockhand = display.newImageRect(userInterface,"/resources/images/clockhand2.png", 80 , 60)
local angle = 30
local centerOfClockX = basicClock.x
local centerOfClockY = basicClock.y

local function moveHourHand()

    clockhand:rotate(angle)
    clockhand.x = centerOfClockX
    clockhand.y = centerOfClockY
    
end

-- =========== Shoot Function =========== -- By Milan
local function shoot()
    transitionTime = globalBulletSpeed
    
	local newBullet = display.newImageRect( mainLayer, "resources/images/bullet.png", 25, 65 )
    local x1, y1 = getPlayerPosition()
    local angle = getAngle(x1, y1, mouseX, mouseY)
    newBullet:rotate(angle*180/math.pi + 90)
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
    
    --[[ 
    Extend the bullet
    We will need to translate the player's and the mouses's coordinates to origin
    ]]
    
    local playerx, playery = getPlayerPosition()
    local onCircle = getAngle(playerx, playery, X, Y)

    X, Y = translateOrigin(playerx, playery, onCircle, width)
    
	transition.to( newBullet, { y = Y, x = X, time=transitionTime, onComplete = function() display.remove( newBullet ) end	} )
end

-- Pause the game upon death -- By Milan
function pauseOnDeath()
    for i = 1, #listOfTimers, 1 do
        timer.pause(listOfTimers[i]) -- Pause all timers
    end
    for i = 1, #zombiesArray, 1 do
        zombiesArray[i]:setLinearVelocity( 0,0) -- Pause all zombies
    end

    playerSpeed = 0
end

-- ============== MAIN FUNCTIONS ============== --
-- https://docs.coronalabs.com/guide/programming/03/index.html
local function onCollision( event )
	if ( event.phase == "began" ) then
        
		local obj1 = event.object1
		local obj2 = event.object2
        
            
        -- ======== Character Vs Zombie ======== --
		if ( ( obj1.myName == "character" and obj2.myName == "zombie" ) or
        ( obj1.myName == "zombie" and obj2.myName == "character" ) )
		then
            health = health - zombieDamage
            if ( health <= 0 ) then
                pauseOnDeath()
                
                composer.gotoScene("retry", { time=800, effect="crossFade" })
            end
            print("Player Hurt")

        -- ======== Zombie Vs Bullet ======== --
        elseif  ( obj1.myName == "bullet" and obj2.myName == "zombie" ) then
            display.remove(obj1)
            obj2.health = obj2.health - bulletDamage
            if obj2.health <= 0 then
                display.remove( obj2 )
                for i = #zombiesArray, 1, -1 do
                    if ( zombiesArray[i] == obj2 ) then
                        table.remove( zombiesArray, i )
                        break
                    end
                end
                kills = kills + 1
            end
        
        elseif ( obj1.myName == "zombie" and obj2.myName == "bullet" )  then
            display.remove( obj2 )
            obj1.health = obj1.health - bulletDamage
            if obj1.health <= 0 then
                display.remove( obj1 )
                for i = #zombiesArray, 1, -1 do
                    if ( zombiesArray[i] == obj1 ) then
                        table.remove( zombiesArray, i )
                        break
                    end
                end
                kills = kills + 1
            end
        end 
        updateText()
    end
end




-- ==== Main Loop ===== --
-- Darkness by Marty
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

end

while darkLayer.alpha < 0.2 and darkLayer.alpha > 0.10 do
    clockH:rotate(15)
    
end

local function maskLoopArc()                                                   -- ## THIS IS THE ONE YOU'RE LOOKING FOR

    local mask = graphics.newMask("/resources/images/maskLayerARC.png", 500, 500)
    darkLayer:setMask(mask)
    darkLayer.maskX , darkLayer.maskY = player.x - 775, player.y - 425
    local x1, y1 = getPlayerPosition()
    local angle = getAngle(x1, y1, mouseX, mouseY)

    darkLayer.maskRotation = (angle*180/math.pi)
end

local function gameLoop() -- Milan
    -- Update zombies tracking the player
    for i = #zombiesArray, 1 , -1 do
        -- Zombie AI
        local thisZombie = zombiesArray[i]
        zombieAI(thisZombie)
    end
end
    

-- =================== Main Methods Execution =================== --
-- == Create a set of trees and stones == --
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

function progress()
    --[[
        Initial Values:
        player Health = 100  hp              -- The only value you are not allowed to touch
        player speed = 500 pixels per second -- The only value you are not allowed to touch
        
        spawnRate = 1000  milliseconds
        zombieHealth = 100   hp
        zombieDamage = 3     dmg
        bulletDamage = 100   dmg
        zombieSpeed = 100    pixels per second
        globalBulletSpeed = 2500 ms
        fireRate = 1200         ms
    ]]


    if(kills <= 10) then
        zombieDamage = 1  
        -- Just the default
    elseif(kills <= 20) then -- After twenty kills:
        zombieHealth = 120
        bulletDamage = 120
        zombieSpeed = 100 
        globalBulletSpeed = 2500 
        fireRate = fireRate - 200 -- 1000 ms 
    elseif(kills <= 30) then -- After thirty kills:
        zombieHealth = 150
        zombieSpeed = 70
        zombieDamage = 4 -- damage increased by 2
    elseif(kills <= 40) then -- After forty kills:
        spawnRate = spawnRate + 300 -- 1300 ms
        bulletDamage = zombieHealth
        fireRate = fireRate - 250 -- 750 ms
    elseif(kills <= 50) then -- After fifty kills:
        zombieHealth = 250
    elseif(kills <= 60) then -- After sixty kills:
        bulletDamage = 150
    elseif(kills <= 70) then -- After seventy kills:
        zombieHealth = 300
    elseif(kills <= 80) then
        fireRate = fireRate - 100 -- 750 
        zombieSpeed = 110
    elseif(kills <= 90) then
    elseif(kills <= 100) then
    elseif(kills <= 150) then
    elseif(kills <= 170) then
    elseif(kills <= 210) then 
    elseif(kills <= 250) then 
    elseif(kills <= 300) then  
    elseif(kills <= 350) then   
    end

    print("Zombie: " .. zombieHealth .. "\nSpawn Rate: " .. spawnRate .. "\nFire Rate: " .. fireRate .. "\nBullet Damage: " .. bulletDamage .. "\nZombie Speed: " .. zombieSpeed)
end

-- == Loops such as spawning and shooting == --
gameLoopTimer = timer.performWithDelay( 250, gameLoop, 0 )
summoning = timer.performWithDelay(spawnRate, createZombie, 0)
hourHandTimer = timer.performWithDelay(1000, moveHourHand , -1 )
fireRateSpawner = timer.performWithDelay(fireRate, shoot, 0) -- Auto shoot
maskLoopTimer = timer.performWithDelay(1, maskLoopArc, 0)                                          
progressionMap = timer.performWithDelay(1000, progress, 0) -- Every second, we check what we need to update


poggersLoop = timer.performWithDelay(2000, poggers, 0) -- Calling the night cycle function 
listOfTimers = {gameLoopTimer, summoning, hourHandTimer, fireRateSpawner, maskLoopTimer, progressionMap, poggersLoop}

    

-- == Listeners == --
Runtime:addEventListener( "key", onKeyEvent ) -- Add the key event listener
Runtime:addEventListener( "mouse", onMouseEvent ) -- Add the mouse event listener.
Runtime:addEventListener( "collision", onCollision )




 
 
-- create()

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
        -- composer.removeScene( "game" )

    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
        composer.removeScene( "game" )

    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    print("Game gone")
    userInterface:removeSelf()
    backgroundLayer:removeSelf()
    mainLayer:removeSelf()
    player:removeSelf()
    treesLayer:removeSelf()
    -- composer.gotoScene("menu")
    -- Code here runs prior to the removal of scene's view
    -- composer.removeScene( "game" )
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