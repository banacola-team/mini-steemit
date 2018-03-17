local composer = require( "composer" )
local widget = require( "widget" )
local globalData = require ( "globalData" )
local json = require("json")
local fx = require( "com.ponywolf.ponyfx" )

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
local uiMail = nil

local coins = 0
local followers = 0
local posts = 0
local following = 0
local gameTimer
local gameLeftTime = 3 * 60 * 1000

local buttonStatus = {Type=1, Post=2}
local titleArray = nil
local contentArray = nil
local tagsArray = nil
local wordsIndex = 1
local titleFinished = false
local contentFinished = false
local tagsFinished = false

-- json init
local postsJsonInfo = 
json.decodeFile( system.pathForFile( "json-content/posts.json", system.ResourceDirectory ) )

-- 函数声明
local function gameUpdate()
  gameLeftTime = gameLeftTime - 500
  -- print(":: " .. gameLeftTime)
  
  if (gameLeftTime <= 0) then
    timer.cancel(gameTimer)
    composer.gotoScene("scenes.end-scene")
  end
end

local function typeTitle()
  if (wordsIndex <= #titleArray) then
    local oldTxt = uiTitle:getLabel()
      if (#oldTxt == 0) then
        uiTitle:setLabel(titleArray[wordsIndex])
      else
        uiTitle:setLabel(oldTxt .. " " .. titleArray[wordsIndex])
      end
      wordsIndex = wordsIndex + 1
  else
      titleFinished = true
      wordsIndex = 1
  end 
end

local function splitString(input, delimiter)
    input = tostring(input)
    delimiter = tostring(delimiter)
    if (delimiter=='') then return false end
    local pos,arr = 0, {}
    for st,sp in function() return string.find(input, delimiter, pos, true) end do
        local tmp = string.sub(input, pos, st - 1)
        if (#tmp > 0) then
          table.insert(arr, tmp)
        end
        pos = sp + 1
    end
    table.insert(arr, string.sub(input, pos))
    return arr
end

local function pickupJson()
  local randomIndex = 8--math.random(1, #postsJsonInfo)
  local title = postsJsonInfo[randomIndex]["title"]
  local content = postsJsonInfo[randomIndex]["content"]
  local tags = 
    postsJsonInfo[randomIndex]["tags"][1] .. " " .. 
    postsJsonInfo[randomIndex]["tags"][2]
  
  titleArray = splitString(title, " ")
  contentArray = splitString(content, " ")
  tagsArray = splitString(tags, " ")
end

local function typeContent()
  if (wordsIndex <= #contentArray) then
      local oldTxt = uiContent:getLabel()
      if (#oldTxt == 0) then
        uiContent:setLabel(contentArray[wordsIndex])
      else
        uiContent:setLabel(oldTxt .. " " .. contentArray[wordsIndex])
      end
      wordsIndex = wordsIndex + 1
    else
      contentFinished = true
      wordsIndex = 1
    end
end

local function typeTag()
  if (wordsIndex <= #tagsArray) then
      local oldTxt = uiTags:getLabel()
      if (#oldTxt == 0) then
        uiTags:setLabel(tagsArray[wordsIndex])
      else
        uiTags:setLabel(oldTxt .. " " .. tagsArray[wordsIndex])
      end
      wordsIndex = wordsIndex + 1
    else
      tagsFinished = true
      wordsIndex = 1
    end
end

local function typeText()
  if (titleFinished == false) then
    typeTitle()
  end
  if (titleFinished and contentFinished == false) then
    typeContent()
  end  
  if (titleFinished and contentFinished and tagsFinished == false) then
    typeTag()
  end  
  if (titleFinished and contentFinished and tagsFinished) then
    uiPostButton.buttonStatus = buttonStatus["Post"]
    uiPostButton:setLabel("Post");
  end
end

local function playMailAnim()
  uiMail.alpha = 1
  fx.bounce(uiMail)
end

local function postText()
  print("post")
  -- 屏蔽输入
  uiPostButton:setEnabled(false)
  -- 准备下一个json
  pickupJson()
  -- 播放动画 1. 飞出 2. 增加1
  playMailAnim()
  
  print("here")
  -- 启动输入，状态变为type
  -- uiPostButton.buttonStatus = buttonStatus["Type"]
  -- uiPostButton:setEnabled(true)
end

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
      label = "",
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
      label = "",
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
      label = "",
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
          postText()
        else
          typeText()
        end
      end
    }
  )
  
  uiPostButton.buttonStatus = buttonStatus["Type"]
  
  uiUsername = display.newText("@" .. globalData.username, globalData.GUI_position.uiUsername.x, globalData.GUI_position.uiUsername.y, globalData.GUI_position.uiUsername.width, globalData.GUI_position.uiUsername.height, native.systemFont, globalData.GUI_position.uiUsername.font);
  
  uiCoins = display.newText("$" .. coins .. " STEEM", globalData.GUI_position.uiCoins.x, globalData.GUI_position.uiCoins.y, globalData.GUI_position.uiCoins.width, globalData.GUI_position.uiCoins.height, native.systemFont, globalData.GUI_position.uiCoins.font)
  
  uiStatistic = display.newText(followers .. " followers | " .. posts .. " posts | " .. following .. " followings", globalData.GUI_position.uiStatistic.x, globalData.GUI_position.uiStatistic.y, native.systemFont, globalData.GUI_position.uiStatistic.font)

  uiMail = display.newImageRect("../design/logo/mini-steemit-game-logo.png", 128, 128);
  uiMail.x = display.contentCenterX
  uiMail.y = display.contentCenterY
  uiMail.alpha = 0
  
  pickupJson()
  
  sceneGroup:insert(uiTitle)
  sceneGroup:insert(uiContent)
  sceneGroup:insert(uiTags)
  sceneGroup:insert(uiPostButton)
  sceneGroup:insert(uiUsername)
  sceneGroup:insert(uiCoins)
  sceneGroup:insert(uiStatistic)
  sceneGroup:insert(uiMail)
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