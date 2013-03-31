require "Projectile"

-- Definition of the laser beam projectile class
local LaserBeam = class(Actor,
    function(self, x, y, vel_x) -- additional argument determing the x velocity
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
    
    removeUFO={}
    -- check attack UFO
    for i,v in ipairs(ufo_group) do
        if self.x+displayWidth>=ufo_group[i].x and self.x+displayWidth<=ufo_group[i].x+ufo_group[i].width and self.y<=ufo_group[i].y then
        
            print("HIT UFO")
            table.insert(removeUFO,i)
            ufo_num=ufo_num-1
            if ufo_num<=0 then
                ufo_num=4
                break
            end
        end
    end
    
    -- remove UFO
    for i,v in ipairs(removeUFO) do
        table.remove(ufo_group,i)
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
            if laser_level == 1 then -- level 1: Original single straight beam
                local laser = LaserBeam(player.x, player.y, 0)
                addActor(laser)
                laser:update(self.cooloff)
            elseif laser_level == 2 then -- level 2: Three parallel beam
                local laserM = LaserBeam(player.x, player.y, 0)
                local laserL = LaserBeam(player.x - 30, player.y, 0)
                local laserR = LaserBeam(player.x + 30, player.y, 0)
                addActor(laserM)
                addActor(laserL)
                addActor(laserR)
                laserM:update(self.cooloff)
                laserL:update(self.cooloff)
                laserR:update(self.cooloff)
            else -- level 3: Powerful 3-way beam
                local laserM1 = LaserBeam(player.x - 10, player.y, 0)
                local laserM2 = LaserBeam(player.x + 10, player.y, 0)
                local laserL1 = LaserBeam(player.x - 40, player.y, -300)
                local laserL2 = LaserBeam(player.x - 20, player.y, -300)
                local laserR1 = LaserBeam(player.x + 20, player.y, 300)
                local laserR2 = LaserBeam(player.x + 40, player.y, 300)
                addActor(laserM1)
                addActor(laserM2)
                addActor(laserL1)
                addActor(laserL2)
                addActor(laserR1)
                addActor(laserR2)
                laserM1:update(self.cooloff)
                laserM2:update(self.cooloff)
                laserL1:update(self.cooloff)
                laserL2:update(self.cooloff)
                laserR1:update(self.cooloff)
                laserR2:update(self.cooloff)
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