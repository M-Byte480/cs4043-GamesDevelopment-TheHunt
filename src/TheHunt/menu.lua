-- Scene Documentation: 
-- https://docs.coronalabs.com/guide/system/composer/index.html
-- Sound done by Stephen Fitzpatrick
-- Minecraft Font: https://www.cufonfonts.com/font/minecraft-3 
-- Menu influenced by Minecraft 
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

local function gotoIntro()
	composer.removeScene( "menu" )
	composer.gotoScene("intro")
end

local function gotoHighScores()
	composer.removeScene( "menu" )
	composer.gotoScene( "highscore", { time=800, effect="crossFade" } )
end

local function gotoInstructions()
	composer.removeScene( "menu" )
	composer.gotoScene("instructions", { time=800, effect="crossFade" })
end
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	

	
	-- Code here runs when the scene is first created but has not yet appeared on screen

	local background = display.newImageRect( sceneGroup, "/resources/images/TheHuntMenu-1.png", 1500, 800 )
	background.x = display.contentCenterX 
	background.y = display.contentCenterY 
	-- background:rotate(90)

	

	playButton = display.newText( sceneGroup, "Play", display.contentCenterX, 700, "/resources/font/1_MinecraftRegular1.otf", 50 )
	playButton:setFillColor( 0.82, 0.86, 1 )
	playButton.x = display.contentCenterX 
	playButton.y = display.contentCenterY - 70
	-- playButton:rotate(90)

	controlsButton = display.newText( sceneGroup, "Controls", display.contentCenterX, 545, "/resources/font/1_MinecraftRegular1.otf", 50 )
	controlsButton.x = display.contentCenterX 
	controlsButton.y = display.contentCenterY + 60
	controlsButton:setFillColor( 0.82, 0.86, 1 )
	-- multiplayerButton:rotate(90)


	highScoresButton = display.newText( sceneGroup, "High Scores", display.contentCenterX, 810, "/resources/font/1_MinecraftRegular1.otf", 50 )
	highScoresButton:setFillColor( 0.75, 0.78, 1 )
	highScoresButton.x = display.contentCenterX
	highScoresButton.y = display.contentCenterY + 185
	-- highScoresButton:rotate(90)

	playButton:addEventListener( "tap", gotoIntro )
	highScoresButton:addEventListener( "tap", gotoHighScores )
	controlsButton:addEventListener( "tap", gotoInstructions )

	mainMenuMusic = audio.loadSound("/resources/audio/MenuMusic.wav")
	-- local playMenuMusic = audio.play( mainMenuMusic )
	
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
		playButton:selfRemove()
		highScoresButton:selfRemove()
		controlsButton:selfRemove()
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