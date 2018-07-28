-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local composer = require("composer")
local globalData = require( "globalData" )
local json = require("json")
local CBE = require("CBE.CBE")

-- 语言处理
globalData.language = json.decodeFile( system.pathForFile( "json-content/ui_en-US.json", system.ResourceDirectory ) )

-- 背景音乐
local bgm = audio.loadSound("audio/bgm.mp3")
globalData.BGM = bgm

-- 进入主界面
display.setStatusBar( display.HiddenStatusBar ) 
math.randomseed( os.time() )
composer.recycleOnSceneChange = true
composer.gotoScene("scenes.logo-scene")