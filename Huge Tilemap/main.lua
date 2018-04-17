AssetLoader = require '/classes/AssetLoader'
local MapLoader = require '/classes/TileMap'
flux = require 'flux'

local spriteBatch
local image

local camera = {x = 0, y = 0, zoom = 1}
local mapSize = {512, 512}
local windowWidth, windowHeight

local score = 0
local fps = 0

function love.load()
    windowWidth, windowHeight = love.graphics.getDimensions()

    love.graphics.setDefaultFilter("nearest", "nearest", 1)
    MapLoader:load(mapSize)
    image = AssetLoader:loadImage("Tileset", "/Assets/units.png")

    flux.to(camera, 4, { x = -512*16+windowWidth })
    :after(camera, 4, { x = -256*16 + windowWidth, y = -256*16 + windowHeight })
    :after(camera, 4, { zoom = 0.5, x = -256*16 + 2 * windowWidth, y = -256*16 + 2 * windowHeight })
    :after(camera, 4, { x = 0, y = 0 })
    :after(camera, 6, { zoom = 0.1 })
    :after(camera, 6, { x = -16*16 })
    :after(camera, 8, { zoom = 2, x = -32*16, y = -32*16 })
    :oncomplete(exit)
end

function exit()
  print(score)
  love.event.quit( 0 )
end

function love.update(dt)
    fps = love.timer.getFPS()
    score = score + fps
    flux.update(dt)
    MapLoader:calcMap(camera.x, camera.y, camera.zoom)
end

function love.draw()
    MapLoader:draw(camera.x, camera.y, camera.zoom)
    love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 10)
    love.graphics.print("Score: " .. score, 10, 30)
    love.graphics.print("Tiles: " .. mapSize[1] .. "x" .. mapSize[2], 10, 50)
end
