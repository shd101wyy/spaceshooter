local MeteorClass = class(Actor,
    function(self)
        local meteorAtlas = love.graphics.newImage("sprites.png")
        self.spriteGroup = SpriteGroup(meteorAtlas, 10)
    end
)

local function meteorGetBB(self)
    local bb = { }
    bb.min_x = self.x - 64
    bb.max_x = self.x + 64
    bb.min_y = self.y - 64
    bb.max_y = self.y + 64
    return bb
end

local function meteorDamage(self, point_x, point_y, velocity_x, velocity_y, damageAmount)
    self.vel_y = self.vel_y / 1.01
    self.health = self.health - damageAmount
    if self.health <= 0 then
        self.x = -1000
        self.y = -1000
        score = score + 10
        removeTarget(self.__target_id)
    end
end

local function makeMeteor()
    local meteor = {}
    meteor.health = 10
    meteor.y = -64
    meteor.x = math.random(0, arenaWidth)
    meteor.vel_x = 0
    meteor.vel_y = 100 + math.random(-20, 20)
    meteor.time = math.random(0, 99)
    meteor.frameRate = math.random(24, 100)
    meteor.getBB = meteorGetBB
    meteor.damage = meteorDamage
    return meteor
end

function MeteorClass:update(dt)
    if math.random() < 0.01 then
        local newMeteor = makeMeteor()
        self.spriteGroup:addSprite(newMeteor)
        addTarget(newMeteor)
    end
    for _,meteor in ipairs(self.spriteGroup.sprites) do
        meteor.x = meteor.x + meteor.vel_x * dt
        meteor.y = meteor.y + meteor.vel_y * dt
    end
    self.spriteGroup:update(dt)
end

function MeteorClass:draw()
    self.spriteGroup:draw()
end

return MeteorClass