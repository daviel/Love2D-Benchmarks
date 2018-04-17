local Tilemap = {
    windowSize = {},

    minSetSize = {0, 0},
    maxSetSize = {0, 0},

    tilesetImg = {},
    tilesetSize= {},

    tileWidth = 16,
    tileHeight= 16,

    mapWidth = 64,
    mapHeight= 64,
    map = {},

    imgQuad = {},
    spriteBatch = {}
}


function Tilemap:load(mapSize)
    self.windowSize = {love.graphics.getDimensions()}
    self.mapWidth = mapSize[1]
    self.mapHeight = mapSize[2]
    self.tilesetImg = AssetLoader:loadImage("Tileset", "/Assets/tileset.png")
    self.imgQuad = love.graphics.newQuad(0,0, self.tileWidth, self.tileHeight, self.tilesetImg:getDimensions())
    self.spriteBatch = love.graphics.newSpriteBatch(self.tilesetImg, mapSize[1]*mapSize[2])
    self:loadMap()
end

function Tilemap:unload()
end

function Tilemap:loadMap()
    local rng = love.math.newRandomGenerator()

    for x=1,self.mapWidth do
        self.map[x] = {}
        for y=1,self.mapHeight do
            self.map[x][y] = {2 + rng:random(4), 3 + rng:random(4)}
        end
    end
end

function Tilemap:getTile(tile)
    self.imgQuad:setViewport(tile[1] * self.tileWidth, tile[2] * self.tileHeight, self.tileWidth, self.tileHeight)
    return self.imgQuad
end

function Tilemap:calcMap(xOffset, yOffset, zoom)
    local minX, minY, maxX, maxY
    local zoomFactor = 1/zoom

    if xOffset <= 0 then
        minX = math.floor(zoomFactor * math.abs(xOffset / self.tileWidth))
        maxX = math.floor(zoomFactor * self.windowSize[1] / self.tileWidth) + minX + 2
    else
        local x = math.floor(zoomFactor * xOffset / self.tileWidth)
        minX = 1
        maxX = math.floor(zoomFactor * self.windowSize[1] / self.tileWidth) + 2 - x
    end

    if yOffset <= 0 then
        minY = math.floor(zoomFactor * math.abs(yOffset / self.tileHeight))
        maxY = math.floor(zoomFactor * self.windowSize[2] / self.tileHeight) + minY + 2
    else
        local y = math.floor(zoomFactor * yOffset / self.tileHeight)
        minY = 1
        maxY = math.floor(zoomFactor * self.windowSize[2] / self.tileHeight) + 2 - y
    end

    if minX < 1 then minX = 1 end
    if minY < 1 then minY = 1 end
    if maxX > self.mapWidth then maxX = self.mapWidth end
    if maxY > self.mapHeight then maxY = self.mapHeight end

    if minX ~= self.minSetSize[1] or minY ~= self.minSetSize[2] or
       maxX ~= self.maxSetSize[1] or maxY ~= self.maxSetSize[2] then
        self.minSetSize[1] = minX
        self.minSetSize[2] = minY
        self.maxSetSize[1] = maxX
        self.maxSetSize[2] = maxY
        -- print(minX, minY, maxX, maxY)
        self:renderMap()
    end
end

function Tilemap:renderMap()
    self.spriteBatch:clear()
    for x=self.minSetSize[1], self.maxSetSize[1] do
        for y=self.minSetSize[2], self.maxSetSize[2] do
            local id = self.spriteBatch:add(
                self:getTile(self.map[x][y]),
                x * self.tileWidth, y * self.tileHeight
            )
        end
    end
    self.spriteBatch:flush()
end

function Tilemap:draw(xOffset, yOffset, zoom)
    love.graphics.draw(self.spriteBatch, xOffset - 16, yOffset - 16, 0, zoom, zoom)
end

return Tilemap
