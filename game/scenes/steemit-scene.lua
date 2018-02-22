local composer = require( "composer" )
local widget = require( "widget" )
local globalData = require ( "globalData" )
local json = require("json")

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local uiTitle = nil
local uiContent = nil
local uiTags = nil
local uiPostButton = nil

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
      top = top_base,
      id = "uiTitle",
      label = "hello " .. globalData.username,
      labelAlign  = "left",
      shape = "rect",
      width = display.contentWidth * 0.8,
      height = 40,
    })
  uiTitle:setEnabled(false)

  -- content
  uiContent = widget.newButton({
      left = display.contentCenterX * 0.2,
      top = top_base + 45,
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
      top = top_base + 150,
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
      left = 100,
      top = 270,
      id = "uiPostButton",
      label = "Post",
      shape = "roundedRect",
      width = 100,
      height = 40,
      onRelease = 
      function(event) 
        local randomIndex = math.random(1, #postsJsonInfo)
        uiTitle:setLabel(postsJsonInfo[randomIndex]["title"])
        uiContent:setLabel(postsJsonInfo[randomIndex]["content"])
        uiTags:setLabel(
          postsJsonInfo[randomIndex]["tags"][1] .. " " .. 
          postsJsonInfo[randomIndex]["tags"][2]
        )
      end
    }
  )

  sceneGroup:insert(uiTitle)



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