
local composer = require( "composer" )
local globalData = require ( "globalData" )
local scene = composer.newScene()
local fx = require( "com.ponywolf.ponyfx" )
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local badge = nil
local uiReward = nil
local summary = nil
local myBox = nil
local foreGrp = nil
local backGrp = nil

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
  
  print("End Scene")
  print("Post:" .. globalData.posts)
  print("Coins:" .. globalData.coins)
  
  backGrp = display.newGroup()
  foreGrp = display.newGroup()
  
  --myBox = display.newRect( display.contentCenterX, display.contentCenterY, 0.8 * display.contentWidth, display.contentHeight * 0.6 )
  --myBox.strokeWidth = 3
  --myBox:setStrokeColor( 1, 1, 1 )
  --myBox:setFillColor(0,0,0)
  --backGrp:insert(myBox)
  
  badge = display.newImageRect("../design/logo/mini-steemit-game-logo.png", 128, 128);
  badge.x = display.contentCenterX
  badge.y = display.contentCenterY
  foreGrp:insert(badge)
    
  local streaks = fx.newStreak({length=120})
	streaks.x, streaks.y = badge.x, badge.y
	foreGrp:insert( streaks )
  streaks:toBack()
  
  uiReward = display.newText("Gain Rewards!", globalData.GUI_position.uiRewards.x, globalData.GUI_position.uiRewards.y, native.systemFont,globalData.GUI_position.uiRewards.font)
  backGrp:insert(uiReward)
  
  sceneGroup:insert(backGrp)
  sceneGroup:insert(foreGrp)
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
