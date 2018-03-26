
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local mini_steemit
local logo_timer

local function nextScene()
  local fo_param = { time = 1000, onComplete = function() 
        composer.gotoScene("scenes.login-scene")
    end}
  transition.fadeOut(mini_steemit, fo_param)
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
  
  mini_steemit = display.newImageRect("images/logo/mini-steemit-game-logo.png", 256, 256)
  mini_steemit.x = display.contentCenterX
  mini_steemit.y = display.contentCenterY
  mini_steemit:scale(0.5, 0.5)
  mini_steemit.alpha = 0
  local fi_param={ time=1000, onComplete = function (logo_timer) 
    
      logo_timer = timer.performWithDelay(1000, nextScene)
    end}
  transition.fadeIn(mini_steemit, fi_param)
  
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
