ufo_num=4
remove_ufo_num=0
max_ufo_num=8
ufo_can_move_down=false
ufo_have_shot=false


function UFO_update(dt)
     -- update UFO
	 for i,v in ipairs(ufo_group) do
	     v.x=v.x+dt*v.velocity*math.random(1,2)
	     if v.x>=arenaWidth then
	         v.velocity=-v.velocity
		     v.x=v.x-10
	     end
	     if v.x<=displayWidth then
	         v.velocity=-v.velocity
		     v.x=v.x+10
	     end
	 end


	 local x2,y2=player.x,player.y
	 -- update bullets
	 for i,v in ipairs(bullets) do

	 
	     --aim ship
	     if i==1 then
	     -- have not shot
	       if ufo_have_shot==false then
	        	local x1=v.x
			    local y1=v.y
			    v.vx=(x2-x1)/(y2-y1)*v.vy*1.0
		        ufo_have_shot=true
	       -- have shot	
	       else
			    v.x=v.x+v.vx*dt
			    v.y=v.y+v.vy*dt
		
			    -- bullet outside windows
		    	if v.y>=arenaHeight or v.x<displayWidth or v.x>love.graphics.getWidth() then
		   	       v.x=ufo_group[i].x
			       v.y=ufo_group[i].y
		           v.vx=0
			       ufo_have_shot=false
		    	end
           end
	     
	     --dont aim ship
	     else
		    v.x=v.x+v.vx*dt
		    v.y=v.y+v.vy*dt
		    -- bullet outside windows
		    if v.y>=arenaHeight or v.x<displayWidth or v.x>love.graphics.getWidth() then
		     	v.x=ufo_group[i].x
		    	v.y=ufo_group[i].y	   	
	        end	     
	     end
     
         -- check collision
        for i,v in ipairs(bullets) do
           
            if v.x+v.width/2>=player.x+displayWidth and v.x+v.width/2<=player.x+player.width+displayWidth and v.y>=player.y then
                print("HIT")
                v.x=ufo_group[i].x
                v.y=ufo_group[i].y
                v.vx=0
                
                if i==1 then
                    ufo_have_shot=false
                end
                table.remove(life,#life)
            end
        end
        

      end
end

function UFO_load()
print("UFO_load")
	 ufo_group={}

	
	 ufo_width=30
	 ufo_height=10
	 for i=1,ufo_num do
	     	 ufo={}
        	 ufo.x=math.random(0,arenaWidth)+displayWidth
		 while ufo.x>=arenaWidth-10 do
		    ufo.x=math.random(0,arenaWidth)+displayWidth
		 end
		 ufo.y=50
	         ufo.width=ufo_width
	         ufo.height=ufo_height
		 ufo.velocity=100
		 local temp=math.random(0,1)
		 if temp<0.5 then
		    ufo.velocity=-1*ufo.velocity
		 end
		 table.insert(ufo_group,ufo)
	 end
	 
	 bullets={}
	 for i=1,#ufo_group do
	     bullet={}
	     bullet.x=ufo_group[i].x+ufo_width/2
	     bullet.y=ufo_group[i].y+ufo_height
	     bullet.width=10
	     bullet.vx=100
	     bullet.vy=200
	     table.insert(bullets,bullet)
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

	 local r,g,b,alpha=love.graphics.getColor()
	 -- draw ufos
	 for i,v in ipairs(ufo_group) do

	      love.graphics.setColor(126,161,181,255)
	      love.graphics.ellipse( "fill", v.x+10, v.y-10, v.width/2,v.height/2,10,100)
	      love.graphics.setColor(219,219,219,255)
	      love.graphics.ellipse( "fill", v.x, v.y, v.width,v.height,10,100)
	      
	 end

	 -- draw bullets
	 for i,v in ipairs(bullets) do
	     love.graphics.setColor(255,10,10,255)
	     love.graphics.circle("fill",v.x,v.y,v.width)
	 end
	 love.graphics.setColor(r,g,b,alpha)
end
