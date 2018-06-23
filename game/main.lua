-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local composer = require("composer")
local globalData = require( "globalData" )

local bgm = audio.loadSound("audio/bgm.mp3")
globalData.BGM = bgm
display.setStatusBar( display.HiddenStatusBar ) 
math.randomseed( os.time() )
composer.gotoScene("scenes.logo-scene")