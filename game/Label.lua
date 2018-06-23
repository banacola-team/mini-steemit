local M = {}
local composer = require( "composer" )

function M.new(options)
  options = options or {}
  
  local instance = display.newGroup()
  local x = options.x or display.contentCenterX
  local y = options.y or display.contentCenterY
  local w = options.width or display.contentWidth * 0.8
  local h = options.height or display.contentHeight * 0.8
  local r = options.radius or 0
  
  local bg = display.newImageRect("images/in-game/title-content-background.png", w, h)
  bg.x = x
  bg.y = y
  
  local text = display.newText("", x, y, w, h, native.systemFont, 16)
  text:setFillColor( 0, 0.5, 1 )
  
  instance:insert(1, bg)
  instance:insert(2, text)
  text:toFront()
  return instance
end  

function M.setFillColor(instance, c)
  local rect = instance[1]
  rect:setFillColor(c.r, c.g, c.b, c.a)
end

function M.setLabel(instance, txt)
  local t = instance[2]
  t.text = txt
end

function M.getLabel(instance)
  local txt = instance[1]
  return txt.text
end

return M