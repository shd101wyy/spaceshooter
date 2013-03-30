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


function love.load()
    debugFont = love.graphics.newFont(12)
    guiFont = love.graphics.newFont("gui_font.ttf", 32)
    scoreFont = love.graphics.newFont("score_font.ttf", 26)

    arenaWidth = love.graphics.getWidth() - displayWidth
    arenaHeight = love.graphics.getHeight()

    for _,enemy in ipairs(enemyClasses) do
        addActor(enemy())
    end

    player = Player()
    weapon = weaponClasses[1]()
    addActor(player)
    addActor(weapon)
end

function love.update(dt)
    for _,actor in ipairs(actors) do
        if actor then
            actor:update(dt)
        end
    end
end

function love.draw()
    love.graphics.push()
    love.graphics.translate(displayWidth, 0)
    for _,actor in ipairs(actors) do
        if actor then
            actor:draw(dt)
        end
    end
    love.graphics.pop()

    local margin = 8
    local y = margin
    love.graphics.setColor(128, 128, 128, 255)
    love.graphics.rectangle("fill", 0, 0, displayWidth, arenaHeight)

    love.graphics.setFont(guiFont)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print("Score =", margin, y)
    y = y + guiFont:getHeight()

    love.graphics.setFont(scoreFont)
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.rectangle("fill", margin, y, displayWidth - margin * 2, scoreFont:getHeight() + 2 * margin)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print(numberToString(score, 6), margin * 2, y + margin * 2)
    y = y + scoreFont:getHeight() + margin * 2

    love.graphics.setFont(guiFont)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print("Weapons =", margin, y)
    y = y + guiFont:getHeight()

    love.graphics.setFont(guiFont)
    for _,weapon in ipairs(weaponClasses) do
        local c = weapon.weaponColor
        love.graphics.setColor(c[1], c[2], c[3], 255)
        love.graphics.print(weapon.weaponName, margin, y)
        y = y + guiFont:getHeight()
    end

    love.graphics.setColor(255, 255, 255, 255)

    if false then
        love.graphics.setFont(debugFont)
        local debugFontHeight = debugFont:getHeight()
        love.graphics.print("Memory: " .. math.ceil(collectgarbage("count")) .. "KB", 0, debugFontHeight * 0)
        love.graphics.print("Actors: " .. (#actors - #actors.free),                   0, debugFontHeight * 1)
        love.graphics.print("Free Actors: " .. (#actors.free),                        0, debugFontHeight * 2)
        love.graphics.print("Targets: " .. (#targets),                                0, debugFontHeight * 3)
    end
end
