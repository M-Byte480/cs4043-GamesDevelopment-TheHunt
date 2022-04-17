-- Menu: 
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

-- Initialize variables
local mainMenuMusic

local function gotoGame()
	composer.gotoScene( "game", { time=800, effect="crossFade" } )
end

local function gotoHighScores()
	composer.gotoScene( "highscores", { time=800, effect="crossFade" } )
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	local background = display.newImageRect( sceneGroup, "resources/images/TheHuntMenu-1.png", 950, 450 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	background:rotate(90)

	

	local playButton = display.newText( sceneGroup, "Play", display.contentCenterX, 700, "1_MinecraftRegular1.otf", 35 )
	playButton:setFillColor( 0.82, 0.86, 1 )
	playButton.x = display.contentCenterX +38
	playButton.y = display.contentCenterY
	playButton:rotate(90)

	local multiplayerButton = display.newText( sceneGroup, "Multiplayer", display.contentCenterX, 545, "1_MinecraftRegular1.otf", 35 )
	multiplayerButton.x = display.contentCenterX -35
	multiplayerButton.y = display.contentCenterY
	multiplayerButton:setFillColor( 0.82, 0.86, 1 )
	multiplayerButton:rotate(90)


	local highScoresButton = display.newText( sceneGroup, "High Scores", display.contentCenterX, 810, "1_MinecraftRegular1.otf", 35 )
	highScoresButton:setFillColor( 0.75, 0.78, 1 )
	highScoresButton.x = display.contentCenterX - 105
	highScoresButton.y = display.contentCenterY
	highScoresButton:rotate(90)

	playButton:addEventListener( "tap", gotoGame )
	highScoresButton:addEventListener( "tap", gotoHighScores )

	--mainMenuMusic = audio.loadSound("audio/MinecraftDrill - Copy.wav")
	local playMenuMusic = audio.play( mainMenuMusic )
	
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		-- Start the music!
		audio.play( mainMenuMusic, { channel=1, loops=-1 } )
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
		-- Stop the music!
		audio.stop( 1 )
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
	-- Dispose audio!
	audio.dispose( musicTrack )
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