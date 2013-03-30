local GooGunClass = class(Actor,
    function(self)
        Actor.init(self)
        self.cooloff = 0
    end
)

GooGunClass.weaponOrder = 1
GooGunClass.weaponName = "GooGun++"
GooGunClass.weaponColor = { 32, 240, 32 }
GooGunClass.fireRate = 1

local kd = love.keyboard.isDown -- A small shortcut to this crucial functino

function GooGunClass:update(dt)
    if kd("w") then
        self.cooloff = self.cooloff + dt
        while self.cooloff >= 0 do
            local goo = GooBlob(player.x, player.y)
            addActor(goo)
            goo:update(self.cooloff)
            self.cooloff = self.cooloff - self.fireRate
        end
    else
        self.cooloff = 0
    end
end

return GooGunClass