--Material sourced from...
--https://docs.coronalabs.com/guide/programming/04/index.html
-- Minecraft Font: https://www.cufonfonts.com/font/minecraft-3 

local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------


local width = display.contentWidth
local height = display.contentHeight

local function gotoMenu()
  composer.removeScene( "intstructions" )
  composer.gotoScene("menu", { time=800, effect="crossFade"})
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

  local background = display.newImageRect(sceneGroup,"/resources/images/plainBackground.png",width,height)
  background.x = display.contentCenterX
  background.y = display.contentCenterY
--instructionsBackground2 taken from https://thegameassetsmine.com/product/pixel-art-backgrounds/


  local instructionsTitle = display.newText(sceneGroup, "---Instructions---",display.contentCenterX, 700,"resources/font/1_MinecraftRegular1.otf",70)
  instructionsTitle.x = display.contentCenterX
  instructionsTitle.y = display.contentCenterY - 285
end



-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

    local menuButton = display.newText( sceneGroup, "Back To Menu", display.contentCenterX + 475, display.contentCenterY + 290, "resources/font/1_MinecraftRegular1.otf", 42)
      menuButton:setFillColor( 0.75, 0.78, 1 )
      menuButton:addEventListener( "tap", gotoMenu )

    local ins1 = display.newText(sceneGroup, "[W] : Move Up", display.contentCenterX , display.contentCenterY - 200,"resources/font/1_MinecraftRegular1.otf", 44 )
    ins1:setFillColor(1,1,1)
    local ins2 = display.newText(sceneGroup, "[S] : Move Down", display.contentCenterX , display.contentCenterY - 120,"resources/font/1_MinecraftRegular1.otf", 44 )
    ins1:setFillColor(1,1,1)
    local ins3 = display.newText(sceneGroup, "[A] : Move Left", display.contentCenterX , display.contentCenterY - 40,"resources/font/1_MinecraftRegular1.otf", 44 )
    ins1:setFillColor(1,1,1)
    local ins4 = display.newText(sceneGroup, "[D] : Move Right", display.contentCenterX , display.contentCenterY + 40,"resources/font/1_MinecraftRegular1.otf", 44 )
    ins1:setFillColor(1,1,1)
    local ins5 = display.newText(sceneGroup, "[Space] : Skip Cutscenes", display.contentCenterX , display.contentCenterY + 120,"resources/font/1_MinecraftRegular1.otf", 44 )
    ins1:setFillColor(1,1,1)
    -- local ins6 = display.newText(sceneGroup, "[Esc] : Return to Menu", display.contentCenterX , display.contentCenterY + 200,"resources/font/1_MinecraftRegular1.otf", 44 )
    -- ins1:setFillColor(1,1,1)

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
