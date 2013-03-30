--- Gives each sprite default properties. This also enumerates each variable a sprite has that
--- matters.
-- @param x The x coordinate of the sprite
-- @param y The y coordinate of the sprite
-- @param rotation The rotation of the sprite in radians
-- @param scaleX The multiplication factor of the width for the sprite
-- @param scaleY The multiplication factor of the height for the sprite
-- @param time Used to keep track of which frame the sprite sheet animation to use
-- @param frameRate The number of frames per second to show of the sprite's animation
-- @param enabled A boolean value indicating whether the sprite's data gets pushed into the
--                SpriteBatch every frame. Disabling the sprite has the affect of apparently
--                freezing it in place on screen.

local spriteMeta = { x = 0, y = 0, rotation = 0, scaleX = 1, scaleY = 1, time = 0, frameRate = 1, enabled = true }
spriteMeta.__index = spriteMeta

SpriteGroup = class(function(self, image, columns)
    self.image = image
    self.halfWidth = self.image:getWidth() / columns / 2 -- Used for centering the image at its position
    self.quads = makeAtlasQuads(image, columns)
    self.spriteBatch = love.graphics.newSpriteBatch(image, 10000)
    self.sprites = {}
    return self
end)

SpriteGroup.x = 0
SpriteGroup.y = 0

--- Adds a sprite to this sprite group.
-- Note that the Sprite's metatable is set, so sprites should just be plain old tables of data.
-- @param sprite The sprite table data to add to this sprite group
function SpriteGroup:addSprite(sprite)
    setmetatable(sprite, spriteMeta)
    sprite.id = self.spriteBatch:addq(self.quads[1], 0, 0)
    self:prepareSprite(sprite)
    table.insert(self.sprites, sprite)
end

function SpriteGroup:update(dt)
    for _,sprite in ipairs(self.sprites) do
        -- Update the animation for this sprite
        sprite.time = sprite.time + dt * sprite.frameRate

        -- Wrap around the animation for the sprite when it runs out of frames
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