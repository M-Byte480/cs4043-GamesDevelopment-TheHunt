-- Intro:
-- (done by Italo)
local composer = require( "composer" )

local scene = composer.newScene()

-- create()
function scene:create( event )
 
   local sceneGroup = self.view
   -- Code here runs when the scene is first created but has not yet appeared on screen

end


function scene:show( event )
 
   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then

   snapshot = display.newSnapshot( 4000, 4000)
   halfH = display.contentHeight * 0.3

-- Pressing Space to skip the intro
local function onKeyEvent( event )
   if ( "space" == event.keyName and event.phase == "down" ) then
      composer.gotoScene( "game")
   end
 
   return true
end

local skip = "Press Space to skip"

local story =   [[
Your name is David Silver Kinsella,
a hacker that works for the 
well-known Anonymats,
a hacktivist group that aims to take 
down several corrupt governments.

You finally found sufficient evidence
to go against the government’s claims
and you try to reach out
to your comrades in Anonymats
but someone from inside leaked your IP address.

Someone has reached out to you.
You do not remember what happened.
You have woken up in a desolated forest
and you find besides your only friend;
good-old trusted crossbow.

As the sun settles, you see what it seems to be a human,
judging it by its silhouette approaching you.
Upon closer inspection
you notice its deformed features.

It runs towards you,
pointing its claws at you
and lunges in your direction.

You lift your crossbow and shoot.

The creature is now dead, but you notice…






You are not alone...
                ]]

-- -----------------------------------------------------------------------------------
-- Displaying Section
-- -----------------------------------------------------------------------------------
local options = -- Display settings for the text
{
   text = story,
   x = 150,
   y = halfH,
   font = native.systemFont,
   fontSize = 20,
   align = "center"
}

local function introVideo()
   -- Moves the text upwards
   transition.to( snapshot.path, { 
   time = 70000, 
   x1 = 0, y1 = -display.contentHeight, 
   x2 = 0, y2 = -display.contentHeight * 1.4,
   x3 = 0, y3 = -display.contentHeight * 1.4,
   x4 = -0, y4= -display.contentHeight } )
end

skipText = display.newText( skip, 1400, 125, native.systemFont, 25 ) -- Display the skip text
storyText = display.newText( options )                              -- Display the story text

storyText:setFillColor( 0.8, 0.6, 0.4 ) -- Colour of the text
storyText:translate( 250, 440)          -- Position of the text
snapshot.group:insert( storyText )      -- Insert storyText into snapshot
snapshot:translate( 0, halfH )          -- Center snapshot
snapshot:invalidate()                   -- Invalidate snapshot
snapshot:scale( 2, 2 )                  -- Scale snapshot


       -- Code here runs when the scene is still off screen (but is about to come on screen)
       introVideo()
       Runtime:addEventListener( "key", onKeyEvent )
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
       snapshot:removeSelf()
       storyText:removeSelf()
       skipText:removeSelf()
       Runtime:removeEventListener( "key", onKeyEvent )
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


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene