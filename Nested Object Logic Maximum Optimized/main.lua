local sprite
local randomizer = love.math.newRandomGenerator()
local objectsBatch = {}
local objects = {}
local objectCount = 0
local startTime
local fps = 0
local spawnsCount = 50
local startTimer = 3 -- in seconds

local windowHeight
local windowWidth


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
  objectsBatch = love.graphics.newSpriteBatch(sprite, 250000)
end

function createObject()
  return gameObj:create(
    randomizer:random( windowWidth ), -- x
    randomizer:random( windowHeight ), -- y
    randomizer:random(2000) / 1000, -- speed
    (randomizer:random(1000) - 1000) / 1000, -- direction x
    (randomizer:random(1000) - 1000) / 1000, -- direction y
    randomizer:random(2000) / 1000, -- time
    randomizer:random(1000 / 1000) -- threshold
  )
end

function processObjects(dt)
  for i=0,objectCount-1 do
    local object = objects[i]
    object.entity:process(dt)
    objectsBatch:set(object.id, object.entity.x, object.entity.y )
  end
end

function love.update(dt)
  fps = love.timer.getFPS()
  startTimer = startTimer - dt

  for i=1, spawnsCount do
    objects[objectCount] = {}
    local object = objects[objectCount]
    object.entity = createObject()
    object.id = objectsBatch:add( object.entity.x, object.entity.y )

    objectCount = objectCount + 1
  end

  processObjects(dt)

  if fps < 60 and startTimer <= 0 then
    print(objectCount)
    love.event.quit( 0 )
  end
end

function love.draw()
  love.graphics.draw(
    objectsBatch,
    0, -- x
    0, -- y
    0, 1, 1
  )
  love.graphics.print("FPS: " .. fps, 10, 10)
  love.graphics.print("Objects: " .. objectCount, 10, 30)
end
