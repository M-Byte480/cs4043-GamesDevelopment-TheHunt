-- local composer = require( "composer" )

local onComplete = function( event )
    composer:gotoScene( "game", { effect = "fade", time = 500 } )
 end
 
 
  
 media.playVideo( "The Hunt Intro.mp4", media.LocalSource, onComplete )
 
