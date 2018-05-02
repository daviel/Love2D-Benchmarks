local Tilemap = {
    windowSize = {},

    view = {minX = 1, minY = 1, maxX = 1, maxY = 1},
    viewPrevious= {minX = 1, minY = 1, maxX = 1, maxY = 1},

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
            self.map[x][y] = {2 + rng:random(4), 3 + rng:random(4), 0}
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

    -- we calculate our view in tiles so we know which tiles should be added/removed
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

    if minX ~= self.view.minX or minY ~= self.view.minY or
       maxX ~= self.view.maxX or maxY ~= self.view.maxY then

        self.viewPrevious.minX = self.view.minX
        self.viewPrevious.minY = self.view.minY
        self.viewPrevious.maxX = self.view.maxX
        self.viewPrevious.maxY = self.view.maxY

        self.view.minX = min(minX, self.view.minX)
        self.view.minY = min(minY, self.view.minY)
        self.view.maxX = max(maxX, self.view.maxX)
        self.view.maxY = max(maxY, self.view.maxY)

        --print(self.view.minX, self.view.minY, self.view.maxX, self.view.maxY)
        --local start = love.timer.getTime()

        -- add the tiles needed first then remove the ones not in the view
        self:addTiles()
        self:removeTiles()

        --local result = love.timer.getTime() - start
        --print( string.format( "RenderMap: %.5f", result * 1000 ))

        self.view.minX = minX
        self.view.minY = minY
        self.view.maxX = maxX
        self.view.maxY = maxY
    end
end

function Tilemap:removeTiles()
  -- TODO: removing of tiles isn't working correctly by now
  --       There are tiles removed twice which costs performance


  --print("prevMinX: " .. self.viewPrevious.minX)
  --print("prevMaxX: " .. self.viewPrevious.maxX)
  --print("prevMinY: " .. self.viewPrevious.minY)
  --print("prevMaxY: " .. self.viewPrevious.maxY)
  --print("MinX: " .. self.view.minX)
  --print("MaxX: " .. self.view.maxX)
  --print("MinY: " .. self.view.minY)
  --print("MaxY: " .. self.view.maxY)


    --local i = 0
    -- remove tiles which are at the top of the view
    for x=self.viewPrevious.minX, self.viewPrevious.maxX do
        for y=self.viewPrevious.minY, self.view.minY - 1 do
            --i = i + 1
            self.spriteBatch:set(self.map[x][y][3], 0, 0, 0, 0, 0)
        end
    end
    --print("Tiles removed top: " .. i)

    --i = 0
    -- remove tiles which are at the left of the view
    for x=self.viewPrevious.minX, self.view.minX do
      for y=self.view.minY, self.viewPrevious.maxY do
            --i = i + 1
            self.spriteBatch:set(self.map[x][y][3], 0, 0, 0, 0, 0)
        end
    end
    --print("Tiles removed left: " .. i)

    --i = 0
    -- remove tiles which are at the right of the view
    for x=self.view.maxX, self.viewPrevious.maxX do
      for y=self.view.minY, self.viewPrevious.maxY do
            --i = i + 1
            self.spriteBatch:set(self.map[x][y][3], 0, 0, 0, 0, 0)
        end
    end
    --print("Tiles removed right: " .. i)

    --i = 0
    -- remove tiles which are at the bottom of the view
    for x=self.view.minX, self.view.maxX do
      for y=self.view.maxY, self.viewPrevious.maxY - 1 do
            --i = i + 1
            self.spriteBatch:set(self.map[x][y][3], 0, 0, 0, 0, 0)
        end
    end
    --print("Tiles removed bottom: " .. i)

end

function Tilemap:addTiles()
  --local i = 0

  -- add tiles which are at the top in the view
  for x=self.view.minX, self.view.maxX - 1 do
      for y=self.view.minY, self.viewPrevious.minY - 1 do
          --i = i + 1
          self.spriteBatch:set(
             self.map[x][y][3], self:getTile(self.map[x][y]), x * self.tileWidth, y * self.tileHeight, 0, 1, 1
          )
      end
  end
  --print("Tiles added top: " .. i)

  --i = 0
  -- add tiles which are at the left in the view
  for x=self.view.minX, self.viewPrevious.minX - 1 do
    for y=self.viewPrevious.minY, self.view.maxY - 1 do
          --i = i + 1
          self.spriteBatch:set(
             self.map[x][y][3], self:getTile(self.map[x][y]), x * self.tileWidth, y * self.tileHeight, 0, 1, 1
          )
      end
  end
  --print("Tiles added left: " .. i)

  --i = 0
  -- add tiles which are at the right in the view
  for x=self.viewPrevious.maxX, self.view.maxX - 1 do
    for y=self.view.minY, self.view.maxY - 1 do
          --i = i + 1
          self.spriteBatch:set(
             self.map[x][y][3], self:getTile(self.map[x][y]), x * self.tileWidth, y * self.tileHeight, 0, 1, 1
          )
      end
  end
  --print("Tiles added right: " .. i)

  --i = 0
  -- add tiles which are at the bottom in the view
  for x=self.view.minX, self.viewPrevious.maxX - 1 do
    for y=self.viewPrevious.maxY, self.view.maxY - 1 do
          --i = i + 1
          self.spriteBatch:set(
             self.map[x][y][3], self:getTile(self.map[x][y]), x * self.tileWidth, y * self.tileHeight, 0, 1, 1
          )
      end
  end
  --print("Tiles added bottom: " .. i)

end

function Tilemap:draw(xOffset, yOffset, zoom)
    love.graphics.draw(self.spriteBatch, xOffset - 16, yOffset - 16, 0, zoom, zoom)
end

return Tilemap
