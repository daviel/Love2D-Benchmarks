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
    self:calcMap()
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

  minX = 1
  minY = 1
  maxX = self.mapWidth - 1
  maxY = self.mapHeight - 1

  local i = 0
  for x=minX, maxX do
      for y=minY, maxY do
          i = i + 1
          local tile = self.map[x][y]

          tile[3] = self.spriteBatch:add(
                    self:getTile(tile),
                    x * self.tileWidth, y * self.tileHeight )
      end
  end
  --print("Tiles added: " .. i)
end

function Tilemap:removeTiles()
    local i = 0


    -- remove tiles which are at the top of the view
    for x=self.viewPrevious.minX, self.viewPrevious.maxX do
        for y=self.viewPrevious.minY, self.view.minY do
            i = i + 1
            self.spriteBatch:set(self.map[x][y][3], 0, 0, 0, 0, 0)
        end
    end

    -- remove tiles which are at the left of the view
    for x=self.viewPrevious.minX, self.view.minX do
      for y=self.view.minY, self.viewPrevious.maxY do
            i = i + 1
            self.spriteBatch:set(self.map[x][y][3], 0, 0, 0, 0, 0)
        end
    end

    -- remove tiles which are at the right of the view
    for x=self.view.maxX, self.viewPrevious.maxX do
      for y=self.view.minY, self.viewPrevious.maxY do
            i = i + 1
            self.spriteBatch:set(self.map[x][y][3], 0, 0, 0, 0, 0)
        end
    end

    -- remove tiles which are at the bottom of the view
    for x=self.view.minX, self.view.maxX do
      for y=self.view.maxY, self.viewPrevious.maxY do
            i = i + 1
            self.spriteBatch:set(self.map[x][y][3], 0, 0, 0, 0, 0)
        end
    end

    print("Tiles removed: " .. i)
end

function Tilemap:addTiles()
  local i = 0

  -- add tiles which are at the top in the view
  for x=self.view.minX, self.view.maxX do
      for y=self.view.minY, self.viewPrevious.minY - 1 do
          i = i + 1
          self.spriteBatch:set(
             self.map[x][y][3], self:getTile(self.map[x][y]), x * self.tileWidth, y * self.tileHeight, 0, 1, 1
          )
      end
  end

  -- add tiles which are at the left in the view
  for x=self.view.minX, self.viewPrevious.minX - 1 do
    for y=self.viewPrevious.minY, self.view.maxY do
          i = i + 1
          self.spriteBatch:set(
             self.map[x][y][3], self:getTile(self.map[x][y]), x * self.tileWidth, y * self.tileHeight, 0, 1, 1
          )
      end
  end

  -- add tiles which are at the right in the view
  for x=self.viewPrevious.maxX, self.view.maxX -1 do
    for y=self.view.minY, self.view.maxY do
          i = i + 1
          self.spriteBatch:set(
             self.map[x][y][3], self:getTile(self.map[x][y]), x * self.tileWidth, y * self.tileHeight, 0, 1, 1
          )
      end
  end

  -- add tiles which are at the bottom in the view
  for x=self.view.minX, self.viewPrevious.maxX do
    for y=self.viewPrevious.maxY, self.view.maxY - 1 do
          i = i + 1
          self.spriteBatch:set(
             self.map[x][y][3], self:getTile(self.map[x][y]), x * self.tileWidth, y * self.tileHeight, 0, 1, 1
          )
      end
  end

  print("Tiles added: " .. i)
end

function Tilemap:renderTiles()
    local i = 0
    for x=self.view.minX, self.view.maxX do
        for y=self.view.minY, self.view.maxY do
            i = i + 1
            local tile = self.map[x][y]

            tile[3] = self.spriteBatch:add(
                      self:getTile(tile),
                      x * self.tileWidth, y * self.tileHeight )
        end
    end
    print("Tiles added: " .. i)
end

function Tilemap:draw(xOffset, yOffset, zoom)
    love.graphics.draw(self.spriteBatch, xOffset - 16, yOffset - 16, 0, zoom, zoom)
end

return Tilemap
