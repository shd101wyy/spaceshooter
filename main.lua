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


-- my code here
life={"*","*","*","*","*"}
-- life={"*",arenaWidth/2,arenaHeight/2}
can_gg=false


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
   	  love.audio.play(audioSource)

end




function love.update(dt)
    if #life==0 then
      can_gg=true
    end


    for _,actor in ipairs(actors) do
        if actor then
            actor:update(dt)
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

    -- Draw the weapons label
    love.graphics.setFont(guiFont)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print("Weapons =", margin, y)
    y = y + guiFont:getHeight()

    -- Draw the weapon class labels
    love.graphics.setFont(guiFont)
    for _,weapon in ipairs(weaponClasses) do
        local c = weapon.weaponColor
        love.graphics.setColor(c[1], c[2], c[3], 255)
        love.graphics.print(weapon.weaponName, margin, y)
        y = y + guiFont:getHeight()
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
       print("GAME OVER")
       love.graphics.setFont(guiFont)
       love.graphics.setColor(255, 255, 255, 255)
       love.graphics.print("GAME OVER",arenaWidth/2,arenaWidth/2)
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
end
