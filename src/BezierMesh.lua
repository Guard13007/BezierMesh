local BezierMesh, meshObject = {}, {}

setmetatable(BezierMesh, BezierMesh)

function BezierMesh:new(curve, image, resolution, meshMode)
  local _object = {}

  image:setWrap("repeat", "clamp")

  local points = curve:render(resolution)

  -- this is a weird workaround
  --   duplicating first set of points
  table.insert(points, 1, points[1])
  table.insert(points, 2, points[3])

  local vertices = {}
  local width = image:getWidth()
  local u = 0

  for x = 1, #points - 1, 2 do
    local pv = {points[x-2], points[x-1]}
    local v = {points[x], points[x+1]}
    local nv = {points[x+2], points[x+3]}

    local dist, vert
    if x == 1 then
      -- at beginning, can only use nv and v
      dist = ((nv[1]-v[1])^2+(nv[2]-v[2])^2)^.5
      vert = {(nv[2]-v[2])*width/(dist*2), -(nv[1]-v[1])*width/(dist*2)}
    elseif x == #points - 1 then
      -- at end, can only use pv and v
      dist = ((v[1]-pv[1])^2+(v[2]-pv[2])^2)^.5
      vert = {(v[2]-pv[2])*width/(dist*2), (v[1]-pv[1])*width/(dist*2)}
    else
      -- in middle, can use pv and nv
      dist = ((nv[1]-pv[1])^2+(nv[2]-pv[2])^2)^.5
      vert = {(nv[2]-pv[2])*width/(dist*2), (nv[1]-pv[1])*width/(dist*2)}
    end

    u = u + dist / width

    table.insert(vertices, {
      v[1]+vert[1], v[2]-vert[2], u, 0
    })
    table.insert(vertices, {
      v[1]-vert[1], v[2]+vert[2], u, 1
    })
  end

  -- weird workaround
  --   removing those first duplicate points
  table.remove(vertices, 1)
  table.remove(vertices, 1)

  if meshMode then
    _object.mesh = love.graphics.newMesh(vertices, "strip", meshMode)
  else
    _object.mesh = love.graphics.newMesh(vertices, "strip", "static")
  end
  _object.mesh:setTexture(image)

  setmetatable(_object, { __index = meshObject })

  return _object
end

function meshObject:draw()
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.draw(self.mesh, 0, 0)
end

function meshObject:debugDraw()
  love.graphics.setColor(255, 0, 0, 255)
  for v=1, self.mesh:getVertexCount() do
    local x, y = self.mesh:getVertex(v)
    love.graphics.points(x, y)
  end

  love.graphics.setColor(0, 0, 255, 120)
  for v = 1, self.mesh:getVertexCount() - 2 do
    local x1, y1 = self.mesh:getVertex(v)
    local x2, y2 = self.mesh:getVertex(v+1)
    local x3, y3 = self.mesh:getVertex(v+2)
    love.graphics.line(x1, y1, x2, y2, x3, y3, x1, y1)
  end
end

return  BezierMesh
