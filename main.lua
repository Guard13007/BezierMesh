local BezierMesh = require "BezierMesh"
local curves, roads, debug, hide = {}, {}, true, false
local resolution = 4

function love.load()
  love.graphics.setPointSize(3)
  love.graphics.setLineJoin("none")

  curves[1] = love.math.newBezierCurve(100, 100, 300, 100, 200, 200, 400, 200)
  curves[1]:translate(-100+20, -100+25)
  curves[2] = love.math.newBezierCurve(50, 100, 550, 100, 50, 200, 550, 200)
  curves[2]:translate(-100+300, -100+25)
  curves[3] = love.math.newBezierCurve(10, 205, -500, 205, 790, 205)
  curves[4] = love.math.newBezierCurve(0, 0, 0, 10, 0, 50, 50, 200)
  curves[4]:translate(50, 240)

  for i = 1, #curves do
    if i % 2 == 0 then
      roads[i] = BezierMesh:new(curves[i], love.graphics.newImage("demo-images/road.png"), resolution)
    else
      roads[i] = BezierMesh:new(curves[i], love.graphics.newImage("demo-images/road2.png"), resolution)
    end
  end
end

function love.draw()
  for i = 1, #roads do
    if not hide then
      roads[i]:draw()
    end

    if debug then
      roads[i]:debugDraw()
      love.graphics.setColor(0, 255, 0, 125)
      love.graphics.line(curves[i]:render(resolution))
    end
  end
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
  if key == "h" then
    hide = not hide
  end
  if key == "d" then
    debug = not debug
  end
end
