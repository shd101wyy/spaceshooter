-- THIS IS THE PLANE
Player = class(Actor,
    function(self)
        Actor.init(self)
        self.x = arenaWidth / 2
        self.y = arenaHeight - 72
        self.width = 128
        self.height = 128
        self.moveSpeed = 400
        self.targetTiltAngle = 0
        self.tiltAngle = 0
        self.playerAtlas = love.graphics.newImage("ship.png")
        self.playerQuads = makeAtlasQuads(self.playerAtlas, 13)
    end
)

local kd = love.keyboard.isDown
function Player:update(dt)
    -- Check movement keys
    if kd("a") then
        self.x = self.x - self.moveSpeed * dt
        self.targetTiltAngle = -45

        -- Ensure we don't fall off the screen
        if self.x - self.width / 2 < 0 then
            self.x = self.width / 2
        end
    elseif kd("d") then
        self.x = self.x + self.moveSpeed * dt
        self.targetTiltAngle = 45

        -- Ensure we don't fall off the screen
        if self.x + self.width / 2 > arenaWidth then
            self.x = arenaWidth - self.width / 2
        end
    else
        self.targetTiltAngle = 0
    end

    -- Tilt Angle Calc
    local tiltDelta = self.targetTiltAngle - self.tiltAngle
    if math.abs(tiltDelta) < dt * 500 then -- To prevent jiggle around the 0 angle.
        self.tiltAngle = self.targetTiltAngle
    else
        self.tiltAngle = self.tiltAngle + (tiltDelta / math.abs(tiltDelta)) * dt * 500
        self.tiltAngle = math.min(math.max(self.tiltAngle, -45), 45)
    end
end

function Player:draw(dt)
    love.graphics.drawq(self.playerAtlas, self.playerQuads[math.floor(self.tiltAngle) + 46], self.x - self.width / 2, self.y - self.width / 2)
    --love.graphics.rectangle("fill", self.x - self.width / 2, self.y - self.width / 2, self.width, self.height)
end
