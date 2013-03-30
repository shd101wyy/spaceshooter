require "Projectile"

local LaserBeam = class(Actor,
    function(self, x, y)
        Actor.init()
        self.x = x
        self.y = y
        self.vel_x = 0
        self.vel_y = -1000
    end
)

function LaserBeam:update(dt)
    self.x = self.x + self.vel_x * dt
    self.y = self.y + self.vel_y * dt
    if self.y < -100 then
        self:remove()
    end
    if damageTarget(self.x, self.y, self.vel_x, self.vel_y, 1) then
        self:remove()
    end
end

function  LaserBeam:draw(x, y, age)
    love.graphics.setColor(255, 0, 0, 255)
    love.graphics.rectangle("fill", self.x - 5, self.y - 5, 10, 10)
    love.graphics.setColor(255, 255, 255, 255)
end

local LaserClass = class(Actor,
    function(self)
        Actor.init(self)
        self.cooloff = 0
    end
)

LaserClass.weaponOrder = 0
LaserClass.weaponName = "Laser++"
LaserClass.weaponColor = { 255, 0, 0 }
LaserClass.fireRate = 0.05

local kd = love.keyboard.isDown

function LaserClass:update(dt)
    if kd("w") then
        self.cooloff = self.cooloff + dt
        while self.cooloff >= 0 do
            local laser = LaserBeam(player.x, player.y)
            addActor(laser)
            laser:update(self.cooloff)
            self.cooloff = self.cooloff - self.fireRate
        end
    else
        self.cooloff = 0
    end
end

return LaserClass