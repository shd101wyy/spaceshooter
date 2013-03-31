local MeteorClass = class(Actor,
    function(self)
        Actor.init(self)
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

local function meteorDamage(self, point_x, point_y, damageAmount)
    self.vel_y = self.vel_y / 0.99
    self.health = self.health - damageAmount
    if self.health <= 0 then
        -- Upon death the sprite is moved some place unreachable. It's impossible to remove sprites
        -- from a sprite group.
        self.x = -1000
        self.y = -1000
        score = score + 10
        removeTarget(self)
    end
end

local function makeMeteor()
    local meteor = {}
    local lvl = game_level -- convenient name
    if lvl == 1 then
        meteor.health = 10 -- relatively easy
    elseif lvl == 2 then
        meteor.health = 15 -- moderate
    else
        meteor.health = 20 -- more difficult
    end
    meteor.y = -64
    meteor.x = math.random(0, arenaWidth)
    meteor.vel_x = 0
    meteor.vel_y = 150 + 75 * game_level + math.random(-50, 50) -- faster for higher level
    meteor.time = math.random(0, 99)
    meteor.frameRate = math.random(24, 100)
    meteor.getBB = meteorGetBB
    meteor.damage = meteorDamage
    return meteor
end

function MeteorClass:update(dt)
    -- Random chance that a new meteor appears.
    if math.random() < 0.02 then
        local newMeteor = makeMeteor()
        self.spriteGroup:addSprite(newMeteor)
        addTarget(newMeteor)
    end


    local removeMeteor={}

    for _,meteor in ipairs(self.spriteGroup.sprites) do
        meteor.x = meteor.x + meteor.vel_x * dt
        meteor.y = meteor.y + meteor.vel_y * dt

	local bb=meteor:getBB()	


	-- check collision
	if bb.max_y >= player.y and bb.min_x<player.x and bb.max_x>player.x and bb.min_y<=player.y and can_gg==false then
	   print("METEOR IS BELOW SHIP")
	   table.insert(removeMeteor,_)
	   --explosion_mp3=love.audio.newSource("explosion.mp3")
	   --explosion_mp3:setLooping(false)
	   --love.audio.play(explosion_mp3)

	   -- remove meteor
	   meteor.x=-10000
	   meteor.y=-10000

	   print("life"..#life)
	   table.remove(life,#life)
	end
    


    end
    
    self.spriteGroup:update(dt)
end

function MeteorClass:draw()
    self.spriteGroup:draw()
end

return MeteorClass