local AssetLoader = {
    imagesCount = 0,
    imagesLoaded = 0,
    imagesUnloaded = 0,
    images = {}
}

function AssetLoader:loadImage(key, path)
    if not self.images[key] then
        self.images[key] = {
            img = love.graphics.newImage(path),
            usedByCount = 1,
            loaded = true,
            loadedTimestamp = love.timer.getTime()
        }
        self.imagesCount = self.imagesCount + 1
        self.imagesLoaded = self.imagesLoaded + 1
    elseif self.images[key] and self.images[key]["loaded"] == false then
        self.images[key]["loaded"] = true
        self.images[key]["loadedTimestamp"] = love.timer.getTime()
        self.images[key]["img"] = love.graphics.newImage(path)
        self.images[key]["usedByCount"] = 1
       
        self.imagesLoaded = self.imagesLoaded + 1
    else
        self.images[key]["usedByCount"] = self.images[key]["usedByCount"] + 1
    end
    return self.images[key]["img"]
end

function AssetLoader:unloadImage(key)
    if self.images[key] then
        self.images[key]["usedByCount"] = self.images[key]["usedByCount"] - 1
    
        if self.images[key]["usedByCount"] == 0 then
            self.images[key]["loaded"] = false
            self.images[key]["loadedTimestamp"] = 0
            self.images[key]["img"] = null

            self.imagesLoaded = self.imagesLoaded - 1
            self.imagesUnloaded = self.imagesUnloaded - 1
        end
    end
end

return AssetLoader
