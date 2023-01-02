------------------------ROGERS CODE---------------------------------------------

--Material sourced from...
--https://docs.coronalabs.com/guide/programming/04/index.html
-- Minecraft Font: https://www.cufonfonts.com/font/minecraft-3 
--Add this to game.lua to allow for a recorded highscore(dont have to include go to highscore scene)

--local function endGame()
	--composer.setVariable( "finalScore", score )
	--composer.gotoScene( "highscores", { time=800, effect="crossFade" } )
--end



local composer = require( "composer" )

local scene = composer.newScene()
local json = require( "json" )

local scoresTable = {}

local width = display.contentWidth
local height = display.contentHeight

local filePath = system.pathForFile( "scores.json", system.DocumentsDirectory )

local function loadScores()

  local file = io.open( filePath, "r" )

  if file then
    local contents = file:read( "*a" )
    io.close( file )
    scoresTable = json.decode( contents )
  end

  if ( scoresTable == nil or #scoresTable == 0 ) then
    scoresTable = {0, 0, 0, 0, 0, 0}
  end
end

local function saveScores()

  for i = #scoresTable, 7, -1 do
    table.remove( scoresTable, i )
  end

  local file = io.open( filePath, "w" )

  if file then
    file:write( json.encode( scoresTable ) )
    io.close( file )
  end
end

local function gotoMenu()
  composer.removeScene( "highscore" )
  composer.gotoScene( "menu", { time=800, effect="crossFade" } )
end
----------------------------------------------------------------------------------------


-- create()
function scene:create( event )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

-- Load previous scores
    loadScores()

-- Insert the last games score
    table.insert( scoresTable, composer.getVariable( "killCount" ) )
    composer.setVariable( "killCount", 0 )


-- Sort the scores in the table from highest to lowest
    local function compare( a, b )
      return a > b
    end
    table.sort( scoresTable, compare )

      -- Saves scores
      saveScores()

      local background = display.newImageRect( sceneGroup, "/resources/images/plainBackground.png", width, height )
      background.x = display.contentCenterX
      background.y = display.contentCenterY
-- highscoreBackground taken from https://wallpapersmug.com/w/download/1920x1080/dark-night-river-forest-minimal-art-95afc818055

      local  highScoresHeader = display.newText(sceneGroup, "---High Scores---",display.contentCenterX, 700,"resources/font/1_MinecraftRegular1.otf",70)
      highScoresHeader.x = display.contentCenterX
      highScoresHeader.y = display.contentCenterY - 300



      for i = 1, 6 do
        if ( scoresTable[i] ) then
            local yPos = display.contentCenterY - 200 + ( i * 56 )

            local rankNum = display.newText(sceneGroup, i .. ")", display.contentCenterX, yPos, "resources/font/1_MinecraftRegular1.otf", 46 )
            rankNum:setFillColor( 0.8 )
            rankNum.anchorX = 1

            local thisScore = display.newText( sceneGroup, scoresTable[i], display.contentCenterX, yPos, "resources/font/1_MinecraftRegular1.otf", 46 )
            thisScore.anchorX = 0
        end
      end

    local menuButton = display.newText( sceneGroup, "Back To Menu", display.contentCenterX + 475, display.contentCenterY + 290, "resources/font/1_MinecraftRegular1.otf", 42)
    menuButton:setFillColor( 0.75, 0.78, 1 )
    menuButton:addEventListener( "tap", gotoMenu )
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
        composer.removeScene( "highscores" )
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
