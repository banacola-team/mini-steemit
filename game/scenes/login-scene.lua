
local composer = require( "composer" )
local widget = require( "widget" )
local globalData = require( "globalData" )
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local txt_username
local ui_textBox
local error_msg
local show = false 
local err_timer
local submit_btn

local function hideError()
  transition.fadeOut(error_msg, {time=500, onComplete = function() show = false end})
end

local function startTimer()
  err_timer = timer.performWithDelay(1000, hideError)
end

local function showErrorMessage()
  if (show == false) then
    transition.fadeIn(error_msg, {time=300, onComplete = function() show = true 
          startTimer() end })
  end
end

local function textListener(event)
  local length = 32
  
  if ( event.phase == "began" ) then
        -- User begins editing "defaultField"
 
  elseif ( event.phase == "ended" or event.phase == "submitted" ) then
        -- Output resulting text from "defaultField"
        print( event.target.text )
 
  elseif ( event.phase == "editing" ) then
    if (string.len(event.text) > length) then
      ui_textBox.text = event.oldText
      -- print("exceeded 32 ")
      showErrorMessage()
    end 
  end
end
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
  txt_username = display.newText( "Input Username: ", 200, display.contentCenterY, native.systemFont, 36 )
  
  ui_textBox = native.newTextField( display.contentWidth * 0.7, display.contentCenterY, 320, 36 )
  ui_textBox:addEventListener("userInput", textListener)
  
  error_msg = display.newText( "Exceeded 32 characters", display.contentCenterX, display.contentCenterY + 100, native.systemFont, 36 )
  
  error_msg.alpha = 0
  
  submit_btn = widget.newButton({
      x = display.contentCenterX,
      y = display.contentCenterY + 100,
      id = "uiLoginButton",
      label = "Login",
      shape = "roundedRect",
      width = 100,
      height = 40,
      onRelease = 
      function(event) 
        local username = ui_textBox.text
        
        if (string.len(username) == 0) then
          -- print("empty string")
          return
        end
        globalData.username = username
        composer.gotoScene("scenes.steemit-scene");
      end
    })
  -- 本地对象不能加入到场景组中，在hide事件中删除
  sceneGroup:insert(submit_btn)
  sceneGroup:insert(error_msg)
  sceneGroup:insert(txt_username)
  
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

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

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen    
    ui_textBox:removeSelf()
    ui_textBox = nil
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
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene