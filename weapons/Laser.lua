require "Projectile"

-- Definition of the laser beam projectile class
local LaserBeam = class(Actor,
    function(self, x, y)
        Actor.init(self)
        self.x = x
        self.y = y
        self.vel_x = 0
        self.vel_y = -1000
    end
)

function LaserBeam:update(dt)
    self.x = self.x + self.vel_x * dt
    self.y = self.y + self.vel_y * dt

    -- Remove this laser beam when it gets to far up.
    if self.y < -100 then
        self:remove()
    end
    if damageTarget(self.x, self.y, 1) then
        self:remove()
    end
end

function  LaserBeam:draw()
    if laser_level==1 then	  
        love.graphics.setColor(255, 0, 0, 255)
        love.graphics.rectangle("fill", self.x - 5, self.y - 5, 10, 10)
        love.graphics.setColor(255, 255, 255, 255)
    else
        love.graphics.setColor(255, 0, 0, 255)
        love.graphics.rectangle("fill", self.x - 5, self.y - 5, 10, 10)
        love.graphics.rectangle("fill", self.x - 20, self.y - 5, 10, 10)
        love.graphics.rectangle("fill", self.x + 15, self.y - 5, 10, 10)
        love.graphics.setColor(255, 255, 255, 255)
    end
end
---

-- Definition of the laser weapon class
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

local kd = love.keyboard.isDown -- A small shortcut to this crucial functino

function LaserClass:update(dt)
    if kd("w") then
        self.cooloff = self.cooloff + dt
        while self.cooloff >= 0 do
            local laser = LaserBeam(player.x, player.y)
            addActor(laser)
            laser:update(self.cooloff)
            self.cooloff = self.cooloff - self.fireRate
        end
    elseif kd("q") then
       print("q")
    else
        self.cooloff = 0
    end
end

return LaserClass