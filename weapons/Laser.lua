require "Projectile"

-- Definition of the laser beam projectile class
local LaserBeam = class(Actor,
    function(self, x, y, vel_x)
        Actor.init(self)
        self.x = x
        self.y = y
        self.vel_x = vel_x
        self.vel_y = -1000
    end
)

function LaserBeam:update(dt, dir)
    self.x = self.x + self.vel_x * dt
    self.y = self.y + self.vel_y * dt

    -- Remove this laser beam when it gets to far up.
    if self.y < -100 or self.x < 0 or self.x > love.graphics.getWidth() then
        self:remove()
    end
    if damageTarget(self.x, self.y, 1) then
        self:remove()
    end
end

function  LaserBeam:draw()
    love.graphics.setColor(255, 0, 0, 255)
    love.graphics.rectangle("fill", self.x - 3, self.y - 5, 6, 10)
    love.graphics.setColor(255, 255, 255, 255)
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
            if laser_level == 1 then
                local laser = LaserBeam(player.x, player.y, 0)
                addActor(laser)
                laser:update(self.cooloff)
            elseif laser_level == 2 then
                local laserM = LaserBeam(player.x, player.y, 0)
                local laserL = LaserBeam(player.x - 30, player.y, 0)
                local laserR = LaserBeam(player.x + 30, player.y, 0)
                addActor(laserM)
                addActor(laserL)
                addActor(laserR)
                laserM:update(self.cooloff)
                laserL:update(self.cooloff)
                laserR:update(self.cooloff)
            else
                local laserM = LaserBeam(player.x, player.y, 0)
                local laserL = LaserBeam(player.x, player.y, -300)
                local laserR = LaserBeam(player.x, player.y, 300)
                addActor(laserM)
                addActor(laserL)
                addActor(laserR)
                laserM:update(self.cooloff)
                laserL:update(self.cooloff)
                laserR:update(self.cooloff)
            end

            self.cooloff = self.cooloff - self.fireRate
        end
    elseif kd("q") then
       print("q")
    else
        self.cooloff = 0
    end
end

return LaserClass