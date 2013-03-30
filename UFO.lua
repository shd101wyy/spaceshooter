function UFO_update(dt)
	 print("UFO_update")
	 for i,v in ipairs(ufo_group) do
	     v.x=v.x+dt*v.velocity
	     if v.x>=arenaWidth then
	         v.velocity=-v.velocity
	     end
	 end
end

function UFO_load()
	 print("UFO_load")
	 ufo_group={}

	
	 ufo_width=30
	 ufo_height=10
	 for i=1,4 do
	     	 ufo={}
        	 ufo.x=math.random(0,arenaWidth)
		 ufo.y=100
	         ufo.width=ufo_width
	         ufo.height=ufo_height
		 ufo.velocity=100
		 table.insert(ufo_group,ufo)
	 end
end

function love.graphics.ellipse(mode, x, y, a, b, phi, points)
  phi = phi or 0
  points = points or 10
  if points <= 0 then points = 1 end

  local two_pi = math.pi*2
  local angle_shift = two_pi/points
  local theta = 0
  local sin_phi = math.sin(phi)
  local cos_phi = math.cos(phi)

  local coords = {}
  for i = 1, points do
    theta = theta + angle_shift
    coords[2*i-1] = x + a * math.cos(theta) * cos_phi 
                      - b * math.sin(theta) * sin_phi
    coords[2*i] = y + a * math.cos(theta) * sin_phi 
                    + b * math.sin(theta) * cos_phi
  end

  coords[2*points+1] = coords[1]
  coords[2*points+2] = coords[2]

  love.graphics.polygon(mode, coords)
end

function UFO_draw()
	 print("UFO_draw")
	 for i,v in ipairs(ufo_group) do
	     print("DRAW HERE")
	     --love.graphics.rectangle("fill", v.x, v.y, v.width, v.height)
  love.graphics.ellipse( "fill", 400, 300, 100,100)

	     --love.graphics.draw(ufo_picture,v.x,v.y,v.width,v.height)
	 end
end
