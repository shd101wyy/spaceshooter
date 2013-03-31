--- E HE
--- Library Loading Code
-- Loads each lua file in a given folder using require.
-- If libTable is given, the modules' return values is inserted into it.
-- @param folder Folder to load lua files from.
-- @param libTable (Optional) A table to put the module's return values using
--   table.insert.
function loadLibrary(folder, libTable)
    local libFiles = love.filesystem.enumerate(folder)
    for _,file in ipairs(libFiles) do
        if love.filesystem.isFile(folder.."/"..file) then
            local match = file:match("(.+)[.]lua$")
            if match and match ~= "main" then
                local lib = require(folder.."/"..match)
                if libTable and lib then
                    table.insert(libTable, lib)
                end
            end
        end
    end
end



loadLibrary("core")
loadLibrary("")

-- Declare these params now. They are filled in at love.load
displayWidth = 200
arenaWidth = 0
arenaHeight = 0

-- Game Assets
local debugFont
local guiFont
local scoreFont


-- Gameplay Globals
score = 0
player = nil
weapon = nil

-- Enemy Classes
enemyClasses = { }
loadLibrary("enemies", enemyClasses)


-- Weapon Classes
weaponClasses = { }
loadLibrary("weapons", weaponClasses)
table.sort(weaponClasses, function(w1, w2) return w1.weaponOrder < w2.weaponOrder end)

-- new code here
--======================================
--require "./UFO.lua"

life = {"*","*","*","*","*"}
can_gg = false
game_level = 1
weapon_mode = 1 -- the # of weapon
weapon_name = {"simple laser", "triple laser", "3-way laser"} -- output name for weapon

function love.keypressed(key)
	 if key=="tab" then
	    print("Press Tab")
        if game_level == 2 then
    	    if weapon_mode == 1 then
    	       weapon_mode = 2
    	    else
    	       weapon_mode = 1
    	    end
        elseif game_level == 3 then
            if weapon_mode == 1 then
                weapon_mode = 2
            elseif weapon_mode == 2 then
                weapon_mode = 3
            else
                weapon_mode = 1
            end
        end
	 elseif key=="escape" then
	 	os.exit()
	 end

	 if can_gg==true and key=="y" then
	    can_gg=false
	    score=0
	    game_level=1
	    life={"*","*","*","*","*"}
	 end
end

--======================================

function love.load()


    -- Load fonts
    debugFont = love.graphics.newFont(12)
    guiFont = love.graphics.newFont("gui_font.ttf", 32)
    scoreFont = love.graphics.newFont("score_font.ttf", 26)

    -- Set the playable area geometry
    arenaWidth = love.graphics.getWidth() - displayWidth
    arenaHeight = love.graphics.getHeight()

    -- Add each enemy type
    for _,enemy in ipairs(enemyClasses) do
        addActor(enemy())
    end

    -- Add the player and weapon actor
    player = Player()
    weapon = weaponClasses[1]()
    addActor(player)
    addActor(weapon)

    audioSource = love.audio.newSource("hdl.mp3")
    love.audio.setVolume(2.0)
    audioSource:setLooping(true)
    love.audio.play(audioSource)

     -- new code here by PODH

      UFO_load()
    

    -------------------------------------
end




function love.update(dt)

    -- new code by PODH
    if score>=20 then
       UFO_update(dt)
    end
    -------------------

    if #life==0 then
      can_gg=true
    end

    if can_gg==false then
        for _,actor in ipairs(actors) do
            if actor then
                actor:update(dt)
            end
        end
    end
end

function love.draw()



    -- Draw all the actors
    love.graphics.push()
    love.graphics.translate(displayWidth, 0)
    for _,actor in ipairs(actors) do
        if actor then
            actor:draw(dt)
        end
    end
    love.graphics.pop()

    -- Draw the side pane
    local margin = 8
    local y = margin
    love.graphics.setColor(128, 128, 128, 255)
    love.graphics.rectangle("fill", 0, 0, displayWidth, arenaHeight)

    -- Draw the score label
    love.graphics.setFont(guiFont)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print("Score =", margin, y)
    y = y + guiFont:getHeight()

    -- Draw the score
    love.graphics.setFont(scoreFont)
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.rectangle("fill", margin, y, displayWidth - margin * 2, scoreFont:getHeight() + 2 * margin)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print(numberToString(score, 6), margin * 2, y + margin * 2)
    y = y + scoreFont:getHeight() + margin * 2

    -- Draw the current Level
    love.graphics.setFont(guiFont)
    love.graphics.setColor(255, 255, 255, 255)
    local lvlprint = "Level = " .. game_level
    love.graphics.print(lvlprint, margin, y)
    y = y + guiFont:getHeight()

    -- Draw the weapons label
    love.graphics.setFont(guiFont)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print("Weapons =", margin, y)
    y = y + guiFont:getHeight()

    -- Draw the weapon class labels
    love.graphics.setFont(guiFont)
    for i = 1, game_level do
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.print(weapon_name[i], margin, y)
        y = y + guiFont:getHeight()
    end

 -- update laser according to score
    if score<=100 then
       game_level = 1
       weapon_mode = 1
    elseif score>100 and score<400 then
       game_level = 2
       weapon_mode = 2
    else
       game_level = 3
       weapon_mode = 3
    end

 -- Draw the life label
    love.graphics.setFont(guiFont)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print("\n\nLife =", margin, y)
    y = y + guiFont:getHeight()

    -- because of \n\n above, so do it twice
    y = y + guiFont:getHeight()
    y = y + guiFont:getHeight()
    life_string="";
    for i,v in ipairs(life) do
    	life_string=life_string..v.." "
    end
    love.graphics.print(life_string,margin,y)


    -- check gg
    if can_gg==true then
    
       -- reset laser level
       game_level=1
	
       print("GAME OVER")
       love.graphics.setFont(guiFont)
       love.graphics.setColor(255, 255, 255, 255)
       love.graphics.print("GAME OVER",arenaWidth/2,arenaWidth/2)
       
       print("Want to TRY AGAIN???? MAN?")
       love.graphics.setFont(guiFont)
       love.graphics.setColor(255, 255, 255, 255)
       love.graphics.print("Want to TRY AGAIN???? MAN?",arenaWidth/2,arenaWidth/2+50)

       print("Press Y to restart!!!!")
       love.graphics.setFont(guiFont)
       love.graphics.setColor(255, 255, 255, 255)
       love.graphics.print("Press Y to restart!!!!",arenaWidth/2,arenaWidth/2+100)
       
       
       
    end




    love.graphics.setColor(255, 255, 255, 255)

    -- Draw some debug stuff. Disable by replacing the condition with false, or set it to true to
    -- enable it.
    if false then
        love.graphics.setFont(debugFont)
        local debugFontHeight = debugFont:getHeight()
        love.graphics.print("Memory: " .. math.ceil(collectgarbage("count")) .. "KB", 0, debugFontHeight * 0)
        love.graphics.print("Actors: " .. (#actors - #actors.free),                   0, debugFontHeight * 1)
        love.graphics.print("Free Actors: " .. (#actors.free),                        0, debugFontHeight * 2)
        love.graphics.print("Targets: " .. (#targets),                                0, debugFontHeight * 3)
    end


      -- new code here by PODH
    if score>=20 then
      UFO_draw()
    end
    ------------------------

end