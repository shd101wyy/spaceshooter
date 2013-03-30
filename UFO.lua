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

	 ufo_picture=love.graphics.newImage("UFO.png")
	 ufo_width=ufo_picture:getWidth()
	 ufo_height=ufo_picture:getHeight()
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



function UFO_draw()
	 print("UFO_draw")
	 for i,v in ipairs(ufo_group) do
	     print("DRAW HERE")
	     love.graphics.rectangle("fill", v.x, v.y, v.width, v.height)

	     --love.graphics.draw(ufo_picture,v.x,v.y,v.width,v.height)
	 end
end
