local composer = require( "composer" )

local scene = composer.newScene()


local snapshot = display.newSnapshot( 4000, 4000)
halfH = display.contentHeight * 0.5

local story =   [[
Your name is David Silver Kinsella,
a hacker that works for the well-known Anonymats,
a hacktivist group that aims to take down several
corrupted governments/institutions.

After spending months investigating a government
that was secretly making experiments on
bats to develop some sort of virus that would create
a huge and negative impact on society.

You finally found sufficient evidence
to go against the government’s claims
and you tried to reach out
to your comrades in Anonymats
but someone from inside
leaked your IP address and went after you.

Unfortunately, they have reached you
and knocked you out.
You do not remember what happened.
Your memory is vague, and you can only
remember the last few events,
such as being laid down into a bed
surrounded by people
that seems to be doctors
from the way they were dressed,
and they were injecting
some weird liquid into your arm.

You now have woken up in a desolated forest
and
you find besides you your only friend;
the good-old trusted crossbow.

As the sun settles,
you see what it seems to be a human,
judging it by its silhouette approaching you.
Upon closer inspection
you notice its deformed features.
It runs towards you,
pointing its claws at you
and lunges in your direction.
You lift your crossbow and shoot.

The creature is now dead, but you notice…






You are not alone...

Press Space to Continue
                ]]

local options = -- Display settings for the text
{
   text = story,
   x = 100,
   y = halfH,
   font = native.systemFont,
   fontSize = 20,
   align = "center"
}

local storyText = display.newText( options ) -- Display the story text

storyText:setFillColor( 0.8, 0.6, 0.4 ) -- Colour of the text
storyText:translate( 250, 440) -- Position of the text

snapshot.group:insert( storyText ) -- Insert storyText into snapshot
snapshot:translate( 0, halfH )  -- Center snapshot
snapshot:invalidate()           -- Invalidate snapshot
snapshot:scale( 2, 2 )

local function introVideo()
    

-- Moves the text upwards
transition.to( snapshot.path, { 
time = 80000, 
x1 = 0, y1 = -display.contentHeight * 1.7, 
x2 = 0, y2 = -display.contentHeight * 2, 
x3 = 0, y3 = -display.contentHeight * 2,  
x4 = -0, y4= -display.contentHeight * 1.7 } )

end
-- -- Initialize variables
local function gotoGame()
    composer.gotoScene( "game", { time=800, effect="crossFade" } )
end

local onComplete = function( event )
   composer.gotoScene( "game", { time=800, effect="crossFade" } )
end

function scene:show( event )
    introVideo()
end

-- -- Pressing Space to skip the intro
local function onKeyEvent( event )
   if ( "space" == event.keyName and event.phase == "down" ) then
      gotoGame()
   end

   return true
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
Runtime:addEventListener( "key", onKeyEvent )
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene