-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local composer = require("composer")
display.setStatusBar( display.HiddenStatusBar ) 
math.randomseed( os.time() )
composer.gotoScene("scenes.logo-scene")