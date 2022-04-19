local composer = require( "composer" )
 

composer:gotoScene( "menu" )
 --Menu: 
--  local composer = require( "composer" )

--  composer.gotoScene( "intro" )
 
 
 -- , { time=800, effect="crossFade" } )
 -- local composer = require( "composer" )
 --[==[
 local onComplete = function( event )
    composer:gotoScene( "game", { effect = "fade", time = 500 } )
 end
 
 media.playVideo( "/resources/videos/The Hunt Intro.mp4", media.LocalSource, onComplete )
 ]==]
 -- return scene

--  local composer = require( "composer" )
-- local function videoListener( event )
--    print( "Event phase: " .. event.phase )
 
--    if event.errorCode then
--        native.showAlert( "Error!", event.errorMessage, { "OK" } )
--    end
-- end
--  local onComplete = function( event )
--     composer:gotoScene( "game", { effect = "fade", time = 500 } )
--  end
--  local video = native.newVideo( display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
-- video:load( "TheHunt.mp4" )
-- video:seek( 30 )
-- video:play()

-- video:addEventListener( "video", videoListener )


-- video:pause()
-- video:removeSelf()
-- video = nil
--  media.playVideo( "The Hunt Intro 2.0.mp4", media.LocalSource, onComplete )
--  media.playVideo( "The Hunt Intro.mp4", media.RemoteSource, onComplete )
