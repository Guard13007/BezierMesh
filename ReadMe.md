# BezierMesh

Library to create meshes based on bezier curves.

## Usage

```
curve = love.math.newBezierCurve(0, 0, 0, 100, -50, 0, 50, 100)

BezierMesh:new(curve, image, resolution, meshMode)
-- image, resolution, and meshMode are optional
-- resolution is what value to use when rendering the bezier curve
-- meshModes: https://love2d.org/wiki/SpriteBatchUsage
```
