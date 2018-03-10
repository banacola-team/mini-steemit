local composer = require( "composer" )
local widget = require( "widget" )
local globalData = require ( "globalData" )
local json = require("json")

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

-- 图层
local mainGroup
local endGroup

-- UI
local uiTitle = nil
local uiContent = nil
local uiTags = nil
local uiPostButton = nil
local uiUsername = nil
local uiCoins = nil
local uiStatistic = nil

local coins = 0
local followers = 0
local posts = 0
local following = 0
local gameTimer
local gameLeftTime = 3 * 60 * 1000

local buttonStatus = {Type=1, Post=2}

-- 函数声明
local function gameUpdate()
  gameLeftTime = gameLeftTime - 500
  print(":: " .. gameLeftTime)
  
  if (gameLeftTime <= 0) then
    timer.cancel(gameTimer)
    composer.gotoScene("scenes.end-scene")
  end
end

-- json init
local postsJsonInfo = 
json.decodeFile( system.pathForFile( "json-content/posts.json", system.ResourceDirectory ) )
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

  local sceneGroup = self.view
  -- Code here runs when the scene is first created but has not yet appeared on screen

  local top_base = display.contentCenterY * 0.2

  -- title
  uiTitle = widget.newButton({
      left = display.contentCenterX * 0.2,
      top = top_base + 80,
      id = "uiTitle",
      label = "title ",
      labelAlign  = "left",
      shape = "rect",
      width = display.contentWidth * 0.8,
      height = 40,
    })
  uiTitle:setEnabled(false)

  -- content
  uiContent = widget.newButton({
      left = display.contentCenterX * 0.2,
      top = top_base + 125,
      id = "uiContent",
      label = "content",
      labelAlign  = "left",
      labelYOffset = -40,
      shape = "rect",
      width = display.contentWidth * 0.8,
      height = 100,
    })
  uiTitle:setEnabled(false)

  -- tags
  uiTags = widget.newButton({
      left = display.contentCenterX * 0.2,
      top = top_base + 230,
      id = "uiTags",
      label = "content",
      labelAlign  = "left",
      shape = "rect",
      width = display.contentWidth * 0.8,
      height = 40,
    })
  uiTags:setEnabled(false)

  -- post button
  uiPostButton = widget.newButton(
    {
      left = display.contentCenterX * 0.2,
      top = 320,
      id = "uiPostButton",
      label = "Type",
      shape = "roundedRect",
      width = 100,
      height = 40,
      onRelease = 
      function(event) 
        if (uiPostButton.buttonStatus == buttonStatus["Post"]) then
          local randomIndex = math.random(1, #postsJsonInfo)
          uiTitle:setLabel(postsJsonInfo[randomIndex]["title"])
          uiContent:setLabel(postsJsonInfo[randomIndex]["content"])
          uiTags:setLabel(
            postsJsonInfo[randomIndex]["tags"][1] .. " " .. 
            postsJsonInfo[randomIndex]["tags"][2]
          )
        else
          
        end
      end
    }
  )
  
  uiPostButton.buttonStatus = buttonStatus["Type"]
  
  uiUsername = display.newText("@" .. globalData.username, globalData.GUI_position.uiUsername.x, globalData.GUI_position.uiUsername.y, globalData.GUI_position.uiUsername.width, globalData.GUI_position.uiUsername.height, native.systemFont, globalData.GUI_position.uiUsername.font);
  
  uiCoins = display.newText("$" .. coins .. " STEEM", globalData.GUI_position.uiCoins.x, globalData.GUI_position.uiCoins.y, globalData.GUI_position.uiCoins.width, globalData.GUI_position.uiCoins.height, native.systemFont, globalData.GUI_position.uiCoins.font)
  
  uiStatistic = display.newText(followers .. " followers | " .. posts .. " posts | " .. following .. " followings", globalData.GUI_position.uiStatistic.x, globalData.GUI_position.uiStatistic.y, native.systemFont, globalData.GUI_position.uiStatistic.font)

  sceneGroup:insert(uiTitle)
  sceneGroup:insert(uiContent)
  sceneGroup:insert(uiTags)
  sceneGroup:insert(uiPostButton)
  sceneGroup:insert(uiUsername)
  sceneGroup:insert(uiCoins)
  sceneGroup:insert(uiStatistic)
  
end


-- show()
function scene:show( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
    -- Code here runs when the scene is still off screen (but is about to come on screen)

  elseif ( phase == "did" ) then
    -- Code here runs when the scene is entirely on screen
    gameTimer = timer.performWithDelay(500, gameUpdate, -1)
    
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

  sceneGroup:removeSelf()
  sceneGroup = nil

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