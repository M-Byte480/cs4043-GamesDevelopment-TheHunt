-- Code Source:
-- https://docs.coronalabs.com/guide/system/composer/index.html
-- Minecraft Font: https://www.cufonfonts.com/font/minecraft-3 
-- Load Main Menu 
local composer = require( "composer" )
local scene = composer.newScene()

-- create()
function scene:create( event )
 
    local sceneGroup = self.view
centerX = display.contentCenterX
centerY = display.contentCenterY



function deathScreen() -- https://docs.coronalabs.com/api/library/display/newRect.html

    deathBlock = display.newRect( centerX, centerY, 800, 480 )
    deathBlock.strokeWidth = 3
    deathBlock:setFillColor( 0.5, 0.5, 0.5, 0.8 )
    deathBlock:setStrokeColor( 0, 0, 0 )

    deathText = display.newText( "You died!\n\n" .. "\n", centerX, centerY - 100, "resources/font/1_MinecraftRegular1.otf", 55 )
    retry = display.newText("Quit", centerX, centerY + 80, "resources/font/1_MinecraftRegular1.otf", 200 )
    -- highscore = display.newText("Highscore", centerX + 200, centerY + 80, "resources/font/1_MinecraftRegular1.otf", 55 )

    retry:setFillColor( 0, 0, 0 )
    -- highscore:setFillColor( 0, 0, 0 )



end

deathScreen()

function gotoGame()
    os.exit() -- Player must quit as punishment for dying
end

retry:addEventListener( "tap", gotoGame )

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
        deathBlock:removeSelf()
        retry:removeSelf()
        deathText:removeSelf()
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