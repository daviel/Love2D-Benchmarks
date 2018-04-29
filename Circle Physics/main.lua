local sprite
local randomizer = love.math.newRandomGenerator()
local objectsBatch
local objectCount = 2000
local score = 0
local startTime
local runningTime = 8 -- in seconds
local fps = 0

local windowHeight
local windowWidth
local pixelPerMeter = 32

function love.load()
  startTime = love.timer.getTime()

  windowHeight = love.graphics.getHeight()
  windowWidth = love.graphics.getWidth()

  sprite = love.graphics.newImage( "/assets/blobl.png" )
  objectsBatch = love.graphics.newSpriteBatch(sprite, objectCount)

  love.physics.setMeter(pixelPerMeter)
  world = love.physics.newWorld(0, 9.81*pixelPerMeter, true)

  ground = {}
  ground.body = love.physics.newBody(world, windowWidth/2, windowHeight)
  ground.shape = love.physics.newRectangleShape(windowWidth, 1)
  ground.fixture = love.physics.newFixture(ground.body, ground.shape)

  leftWall = {}
  leftWall.body = love.physics.newBody(world, 0, windowHeight/2)
  leftWall.shape = love.physics.newRectangleShape(1, windowHeight)
  leftWall.fixture = love.physics.newFixture(leftWall.body, leftWall.shape)

  rightWall = {}
  rightWall.body = love.physics.newBody(world, windowWidth, windowHeight/2)
  rightWall.shape = love.physics.newRectangleShape(1, windowHeight)
  rightWall.fixture = love.physics.newFixture(rightWall.body, rightWall.shape)

  objects = {} -- table to hold all our physical objects
  for i=0,objectCount do
    objects[i] = {}
    objects[i].body = love.physics.newBody(world, randomizer:random(windowWidth), randomizer:random(windowHeight), "dynamic") --place the body in the center of the world and make it dynamic, so it can move around
    objects[i].shape = love.physics.newCircleShape(4) --the ball's shape has a radius of 20
    objects[i].fixture = love.physics.newFixture(objects[i].body, objects[i].shape, 1) -- Attach fixture to body and give it a density of 1.
    objects[i].fixture:setRestitution(0) --let the ball bounce
  end
end

function renderObjects()
  objectsBatch:clear()
  for x=0, objectCount do
      objectsBatch:add( objects[x].body:getX(), objects[x].body:getY(), objects[x].body:getAngle() )
  end
  objectsBatch:flush()
end

function love.update(dt)
  world:update(dt)

  fps = love.timer.getFPS()
  score = score + fps
  if love.timer.getTime() - startTime > runningTime then
    print(score)
    love.event.quit( 0 )
  end
end

function love.draw()
  renderObjects()
  love.graphics.draw(
    objectsBatch,
    0, -- x
    0, -- y
    0, 1, 1
  )
  love.graphics.print("FPS: " .. fps, 10, 10)
  love.graphics.print("Score: " .. score, 10, 30)
  love.graphics.print("Objects: " .. objectCount, 10, 50)
end
