local GooGunClass = class(
    function(self)
        self.cooloff = 0
    end
)

GooGunClass.weaponOrder = 1
GooGunClass.weaponName = "GooGun++"
GooGunClass.weaponColor = { 32, 240, 32 }
GooGunClass.fireRate = 0.05

function GooGunClass:fire(dt, triggered, x, y)
    if triggered then

    end
end

return GooGunClass