local spriteMeta = { x = 0, y = 0, rotation = 0, scaleX = 1, scaleY = 1, time = 0, frameRate = 1, enabled = true }
spriteMeta.__index = spriteMeta

SpriteGroup = class(function(self, image, columns)
    self.image = image
    self.halfWidth = self.image:getWidth() / columns / 2
    self.quads = makeAtlasQuads(image, columns)
    self.spriteBatch = love.graphics.newSpriteBatch(image, 10000)
    self.sprites = {}
    return self
end)

SpriteGroup.x = 0
SpriteGroup.y = 0

function SpriteGroup:addSprite(sprite)
    setmetatable(sprite, spriteMeta)
    sprite.id = self.spriteBatch:addq(self.quads[1], 0, 0)
    self:prepareSprite(sprite)
    table.insert(self.sprites, sprite)
end

function SpriteGroup:update(dt)
    for _,sprite in ipairs(self.sprites) do
        sprite.time = sprite.time + dt * sprite.frameRate
        if sprite.time >= #self.quads then
            sprite.time = sprite.time - #self.quads
        end
    end
end

function SpriteGroup:prepareSprite(sprite)
    local quadNum = math.floor(sprite.time) + 1
    self.spriteBatch:setq(sprite.id, self.quads[quadNum], sprite.x, sprite.y, sprite.rotation, 1, 1, self.halfWidth, self.halfWidth)
end

function SpriteGroup:prepareBatch()
    for _,sprite in ipairs(self.sprites) do
        if sprite.enabled then
            self:prepareSprite(sprite)
        end
    end
end

function SpriteGroup:draw()
    self:prepareBatch()
    love.graphics.draw(self.spriteBatch, 0, 0)
end