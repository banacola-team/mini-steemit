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
  local rect = display.newRoundedRect(x, y, w, h, r)
  rect.w = w
  rect.h = h
  instance:insert(1, rect)
  return instance
end  

function M.setFillColor(instance, c)
  local rect = instance[1]
  rect:setFillColor(c.r, c.g, c.b, c.a)
end

function M.setLabel(instance, txt)
  local rect = instance[1]
  instance:remove(instance[2])  
  instance[2] = nil
  local text = display.newText(txt, rect.x, rect.y, rect.w, rect.h, native.systemFont, 16)
  instance:insert(2, text)
  text:toFront()
  text:setFillColor( 0, 0.5, 1 )
end

function M.getLabel(instance)
  local txt = instance[2]
  return txt.text
end

return M