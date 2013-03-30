-- This was an attempt to make it so projectiles had little traisl. It doesn't work properly at the
-- moment, but it's here anyways.
Projectile = class(Actor,
    function(self, trailCount, trailTime)
        Actor.init(self)
        self.x = 0
        self.y = 0
        self.trailCount = trailCount
        self.trailTime = trailTime
        self.trailTimeAccum = 0
        self.trails = { }
        self.trailsIndex = 1
    end
)

function Projectile:updateProjectile(dt)

end

function Projectile:update(dt)
    self.trailTimeAccum = self.trailTimeAccum + dt
    for i,trail in ipairs(self.trails) do
        trail.age = trail.age + dt
    end
    while self.trailTimeAccum > self.trailTime and self.__actor_id ~= 0 do
        self:updateProjectile(self.trailTime)
        self.trailTimeAccum = self.trailTimeAccum - self.trailTime
        self.trails[self.trailsIndex] = { x = self.x, y = self.y, age = self.trailTimeAccum }
        self.trailsIndex = (self.trailsIndex % self.trailCount) + 1
    end
end

function Projectile:draw()
    for i,trail in ipairs(self.trails) do
        self:drawProjectile(trail.x, trail.y, trail.age)
    end
end