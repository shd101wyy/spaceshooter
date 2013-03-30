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

-- local cooloffs = {}
-- function cooloff(token, id, dt, time)
--     if cooloffs[token] == nil then
--         cooloffs[token] = {}
--     end
--     if cooloffs[token][id] == nil or cooloffs[token][id] <= 0 then
--         cooloffs[token][id] = time
--         return true
--     end
--     cooloffs[token][id] = cooloffs[token][id] - dt
--     return false
-- end

local kd = love.keyboard.isDown
function Player:update(dt)
    if kd("a") then
        self.x = self.x - self.moveSpeed * dt
        if self.x - self.width / 2 < 0 then
            self.x = self.width / 2
        end
        self.targetTiltAngle = -45
    elseif kd("d") then
        self.x = self.x + self.moveSpeed * dt
        if self.x + self.width / 2 > arenaWidth then
            self.x = arenaWidth - self.width / 2
        end
        self.targetTiltAngle = 45
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
