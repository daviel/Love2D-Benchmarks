local sprite
local randomizer = love.math.newRandomGenerator()
local objectsBatch
local objectCount = 25000
local score = 0
local startTime
local runningTime = 8 -- in seconds
local fps = 0

local windowHeight
local windowWidth
local pixelPerMeter = 32


gameObj = {}
gameObj.__index = gameObj

function gameObj:create(x, y, speed, directionX, directionY, time, threshold)
   local obj = {}
   setmetatable(obj,gameObj)
   obj.x = x
   obj.y = y
   obj.speed = speed
   obj.time = time
   obj.threshold = threshold
   obj.directionX = directionX
   obj.directionY = directionY
   return obj
end

function gameObj:process(dt)
  self.time = self.time + dt

  if self.time > self.threshold then
    self.time = 0
    self.directionX = self.directionX * (-1)
    self.directionY = self.directionY * (-1)
  end

  self.x = self.x + self.speed * self.directionX
  self.y = self.y + self.speed * self.directionY
end

function love.load()
  startTime = love.timer.getTime()

  windowHeight = love.graphics.getHeight()
  windowWidth = love.graphics.getWidth()

  sprite = love.graphics.newImage( "/assets/blobl.png" )
  objectsBatch = love.graphics.newSpriteBatch(sprite, objectCount)

  objects = {}
  for i=0,objectCount do
    objects[i] = {}
    objects[i].entity = gameObj:create(
      randomizer:random( windowWidth ), -- x
      randomizer:random( windowHeight ), -- y
      randomizer:random(2000) / 1000, -- speed
      (randomizer:random(1000) - 1000) / 1000, -- direction x
      (randomizer:random(1000) - 1000) / 1000, -- direction y
      randomizer:random(2000) / 1000, -- time
      randomizer:random(1000 / 1000) -- threshold
    )
  end
  addObjects()
end

function processObjects(dt)
  for x=0,objectCount do
    objects[x].entity:process(dt)
    objectsBatch:set(objects[x].id, objects[x].entity.x, objects[x].entity.y )
  end
end

function addObjects()
  for x=0, objectCount do
      objects[x].id = objectsBatch:add( objects[x].entity.x, objects[x].entity.y )
  end
end

function love.update(dt)
  processObjects(dt)

  fps = love.timer.getFPS()
  score = score + fps
  if love.timer.getTime() - startTime > runningTime then
    print(score)
    love.event.quit( 0 )
end

function love.draw()
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
end
