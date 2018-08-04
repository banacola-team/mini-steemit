local composer = require( "composer" )
local widget = require( "widget" )
local globalData = require ( "globalData" )
local json = require("json")
local fx = require( "com.ponywolf.ponyfx" )
local label = require( "Label" )
local CBE = require("CBE.CBE")

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
local uiTypeButton = nil
local uiUsername = nil
local uiCoins = nil
local uiStatistic = nil
local uiMail = nil
local uiTimer = nil

-- local variables
local coins = 0
local followers = 0
local posts = 0
local following = 0
local gameTimer
local gameLeftTime = 60 * 1000 * globalData.GameTime

local buttonStatus = {Type=1, Post=2}
local titleArray = nil
local contentArray = nil
local tagsArray = nil
local wordsIndex = 1
local titleFinished = false
local contentFinished = false
local tagsFinished = false
local prevTxt = ""
local currentStatus = buttonStatus["Type"]
local second = 1000
local tenSecond = 10 * 1000
local minute = 60
local click = 0
local particleLevel = 1
local particleNum = 2
-- json init
local postsJsonInfo = nil


-- 函数声明
local function generateParticles()
	
	if particleNum > 15 then
		particleNum = 15
	end	
 	
	local vent = CBE.newVent({

	positionType = "inRadius",
	color = {math.random(0,1), math.random(0,1), math.random(0,1)},
	particleProperties = {blendMode = "add"},
	emitX = math.random(1, display.contentWidth),
	emitY = math.random(1, display.contentHeight),

	emissionNum = 1,
	emitDelay = 5,
	perEmit = particleNum,

	inTime = 100,
	lifeTime = 0,
	outTime = 600,

	onCreation = function(particle)
		particle:changeColor({
			color = {0.1, 0.1, 0.1},
			time = 600
		})
	end,

})
	vent.start()
end

local function wlen( s )
    local len,k=0,1
    while k<=#s do
      len=len+1
      if string.byte(s,k)<=190 then k=k+1 else k=k+2 end
      end
    return len
end

local function updateUI() 
  uiStatistic.text = followers .. " followers | " .. posts .. " posts | " .. following .. " followings"
  uiCoins.text = "$" .. coins .. " STEEM"
end

local function gameUpdate()  
  gameLeftTime = gameLeftTime - 500
  -- print(":: " .. gameLeftTime)
  tenSecond = tenSecond - 500
  second = second - 500
  local fire = false
  
  if (gameLeftTime <= 0) then
    timer.cancel(gameTimer)
    gameTimer = nil
    globalData.posts = posts
    globalData.coins = coins
    composer.gotoScene("scenes.end-scene")
  end
  
  if (tenSecond <= 0) then
    fire = true
    tenSecond = 10 * 1000
  end  
  
  if (second <= 0) then
    second = 1000
    minute = minute - 1
    
    if (minute <= 15) then
      uiTimer:setFillColor(1, 0, 0, 1);
    end
    uiTimer.text = minute .. " seconds"
  end
  
  if (posts > 0 and fire) then
    following = following + math.random(1, 50)
    followers = followers + click/10 * 100
    click = 0
  end  
  
  updateUI()
end

local function typeTitle()
  if (wordsIndex <= #titleArray) then
    local oldTxt = uiTitle:getLabel()
      if (#oldTxt == 0) then
        uiTitle:setLabel(titleArray[wordsIndex])
      else
		if globalData.GameLanguage == "en"  then
			uiTitle:setLabel(oldTxt .. " " .. titleArray[wordsIndex])
		else
			local a = titleArray[wordsIndex]
			local b = nil
			
			if (wordsIndex + 1) <= #titleArray then
				wordsIndex = wordsIndex + 1
				b = titleArray[wordsIndex]
				uiTitle:setLabel(oldTxt .. a .. b)
			else
				uiTitle:setLabel(oldTxt .. a)
			end				
		end
      end
      wordsIndex = wordsIndex + 1
  else
      titleFinished = true
      wordsIndex = 1
  end 
end

local function splitChineseString(input)
   input = tostring(input)
   local arr = {}
   local length = #input
   local i = 1
   
   while i <= length do
		local curByte = string.byte(input, i)
        local byteCount = 1;
        if curByte>=0 and curByte<=127 then
            byteCount = 1
        elseif curByte>=192 and curByte<=223 then
            byteCount = 2
        elseif curByte>=224 and curByte<=239 then
            byteCount = 3
        elseif curByte>=240 and curByte<=247 then
            byteCount = 4
        end	
	
        local char = string.sub(input, i, i+byteCount-1)
        i = i+byteCount
        table.insert(arr, char)       
   end
   return arr   
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
  local randomIndex = math.random(1, #postsJsonInfo)
  local title = postsJsonInfo[randomIndex]["title"]
  local content = postsJsonInfo[randomIndex]["content"]
  local tags = ""
  local array = postsJsonInfo[randomIndex]["tags"]
  
  for i=1, #array do
    local item = array[i]
    tags = tags .. " " .. item
  end
  
  if globalData.GameLanguage == "en" then
    titleArray = splitString(title, " ")
    contentArray = splitString(content, " ")
    tagsArray = splitString(tags, " ")
    prevTxt = ""
   else
    titleArray = splitChineseString(title)
    contentArray = splitChineseString(content)
    tagsArray = splitChineseString(tags)
    prevTxt = ""
   end 
end

local function typeContent()
  if (wordsIndex <= #contentArray) then
      
      if (#prevTxt == 0) then
        -- uiContent:setLabel(contentArray[wordsIndex])
        prevTxt = contentArray[wordsIndex]
        label.setLabel(uiContent, prevTxt)
      else
		if globalData.GameLanguage == "en"  then  
			prevTxt = prevTxt .. " " .. contentArray[wordsIndex]
		else
			local a = contentArray[wordsIndex]
			local b = nil
			
			if (wordsIndex + 1) <= #contentArray then
				wordsIndex = wordsIndex + 1
				b = contentArray[wordsIndex]
				prevTxt = prevTxt .. a .. b
			else	
				prevTxt = prevTxt .. a
			end
		end	
        -- uiContent:setLabel(txt)
        label.setLabel(uiContent, prevTxt)
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
        if globalData.GameLanguage == "en"  then
			uiTags:setLabel(oldTxt .. " " .. tagsArray[wordsIndex])
		else
			local a = tagsArray[wordsIndex]
			local b = nil
			
			if (wordsIndex + 1) <= #tagsArray then
				wordsIndex = wordsIndex + 1
				b = tagsArray[wordsIndex]
				uiTags:setLabel(oldTxt .. a .. b)
			else
				uiTags:setLabel(oldTxt .. a)
			end	
			
		end
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
    click = click + 1
	generateParticles()
  end
  if (titleFinished and contentFinished == false) then
    typeContent()
    click = click + 1
	generateParticles()
  end  
  if (titleFinished and contentFinished and tagsFinished == false) then
    typeTag()
    click = click + 1
	generateParticles()
  end  
  if (titleFinished and contentFinished and tagsFinished) then
    currentStatus = buttonStatus["Post"]
    uiTypeButton.isVisible = false
    uiPostButton.isVisible = true
  end
end

local function refreshStatistic()
  transition.fadeOut(uiMail,{time=200, onComplete=function() transition.moveTo(uiMail, {x=display.contentCenterX, y=display.contentCenterY}) end})
  coins = coins + 100* (1 + posts) + followers * 10
end

local function playMailAnim()
  uiMail.alpha = 1
  transition.moveTo(uiMail, {x=uiStatistic.x, y=uiStatistic.y, time=500, onComplete=refreshStatistic})
end

local function postText()
  posts = posts + 1
  coins = coins + math.random(1,10);
  
  -- 屏蔽输入
  uiPostButton:setEnabled(false)
  -- 准备下一个json
  pickupJson()
  -- 清除
  uiTitle:setLabel("")
  label.setLabel(uiContent, "")
  uiTags:setLabel("")
  titleFinished = false
  contentFinished = false
  tagsFinished = false
  
  -- 播放动画 1. 飞出 2. 增加1
  playMailAnim()
  
  -- 启动输入，状态变为type
  currentStatus = buttonStatus["Type"]
  uiPostButton.isVisible = false
  uiTypeButton.isVisible = true
  uiPostButton:setEnabled(true)
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

  local sceneGroup = self.view
  
  -- Code here runs when the scene is first created but has not yet appeared on screen
  if (globalData.GameLanguage == "en") then
    postsJsonInfo = json.decodeFile( system.pathForFile( "json-content/posts_en-US.json", system.ResourceDirectory ) )
  else  
    postsJsonInfo = json.decodeFile( system.pathForFile( "json-content/posts_zh-CN.json", system.ResourceDirectory ) )
  end

  local top_base = display.contentCenterY * 0.2

  -- title
  uiTitle = widget.newButton({
      left = display.contentWidth * 0.15,
      top = top_base + 80,
      id = "uiTitle",
      label = "",
      labelAlign  = "left",
      --shape = "rect",
      width = display.contentWidth * 0.7,
      height = 40,
      defaultFile = "images/in-game/title-content-background.png",
    })
  uiTitle:setEnabled(false)
  
  -- content
  uiContent = label.new({x=display.contentCenterX, y=top_base+175, width=display.contentWidth * 0.7, height=100})
  label.setLabel(uiContent, prevTxt)
  
  -- tags
  uiTags = widget.newButton({
      left = display.contentWidth * 0.15,
      top = top_base + 230,
      id = "uiTags",
      label = "",
      labelAlign  = "left",
      --shape = "rect",
      width = display.contentWidth * 0.7,
      height = 40,
      defaultFile = "images/in-game/title-content-background.png",
    })
  uiTags:setEnabled(false)

  -- post button
  uiTypeButton = widget.newButton(
    {
      left = display.contentWidth * 0.15,
      top = top_base + 320,
      id = "uiPostButton",
      label = "Type",
      defaultFile = "images/in-game/type-normal.png",
      overFile = "images/in-game/type-pressed.png",
      width = 100,
      height = 40,
      onPress = 
      function(event)
        uiTypeButton:scale(0.8, 0.8)
      end,
      onRelease = 
      function(event) 
          uiTypeButton:scale(1.25, 1.25)
          typeText()   
		  particleNum = particleNum + 1
      end
    }
  )
  
  uiPostButton = widget.newButton(
    {
      left = display.contentWidth * 0.15,
      top = top_base+320,
      id = "uiPostButton",
      defaultFile = "images/in-game/post-normal.png",
      overFile = "images/in-game/post-pressed.png",
      width = 100,
      height = 40,
      onPress = 
      function(event)
        uiPostButton:scale(0.8, 0.8)
      end,
      onRelease = 
      function(event) 
          uiPostButton:scale(1.25, 1.25)
          postText()
      end
    }
  )
  
  currentStatus = buttonStatus["Type"]
  uiPostButton.isVisible = false
  
  uiUsername = display.newText("@" .. globalData.username, globalData.GUI_position.uiUsername.x, globalData.GUI_position.uiUsername.y, globalData.GUI_position.uiUsername.width, globalData.GUI_position.uiUsername.height, native.systemFont, globalData.GUI_position.uiUsername.font);
  
  uiCoins = display.newText("$" .. coins .. " STEEM", globalData.GUI_position.uiCoins.x, globalData.GUI_position.uiCoins.y, globalData.GUI_position.uiCoins.width, globalData.GUI_position.uiCoins.height, native.systemFont, globalData.GUI_position.uiCoins.font)
  
  uiStatistic = display.newText(followers .. " followers | " .. posts .. " posts | " .. following .. " followings", globalData.GUI_position.uiStatistic.x, globalData.GUI_position.uiStatistic.y, native.systemFont, globalData.GUI_position.uiStatistic.font)

  uiMail = display.newImageRect("images/in-game/email.png", 64, 40);
  uiMail.x = display.contentCenterX
  uiMail.y = display.contentCenterY
  uiMail.alpha = 0
  
  uiTimer = display.newText("60 seconds", globalData.GUI_position.uiTimer.x, globalData.GUI_position.uiTimer.y, native.systemFont, globalData.GUI_position.uiTimer.font)

  pickupJson()
  
  sceneGroup:insert(uiTitle)
  sceneGroup:insert(uiContent)
  sceneGroup:insert(uiTags)
  sceneGroup:insert(uiPostButton)
  sceneGroup:insert(uiTypeButton)
  sceneGroup:insert(uiUsername)
  sceneGroup:insert(uiCoins)
  sceneGroup:insert(uiStatistic)
  sceneGroup:insert(uiMail)
  sceneGroup:insert(uiTimer)
  
  local background = display.newImage("images/in-game/background.png", display.contentWidth, display.contentHeight)
  background.x = display.contentCenterX
  background.y = display.contentCenterY
  sceneGroup:insert(background)
  background:toBack()
  
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
  
  if (gameTimer ~= nil) then
    timer.cancel(gameTimer)
  end

  gameTimer = nil
  
  scene:removeEventListener( "create", scene )
  scene:removeEventListener( "show", scene )
  scene:removeEventListener( "hide", scene )
  scene:removeEventListener( "destroy", scene )
  
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