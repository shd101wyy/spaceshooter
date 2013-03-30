function numberToString(number, length)
    local strNumber = tostring(number)
    while #strNumber < length do
        strNumber = "0" .. strNumber
    end
    return strNumber
end

--- Produce an array of LOVE quads that correspond to the frames in a sprite sheet.
-- This assumes that the sprite sheet is made of all square frames.
-- @param image The loaded image to be partitioned by quads
-- @param columns The number of columns in the sprite sheet. The number of rows is inferred.
function makeAtlasQuads(image, columns)
    local quads = {}
    local width = image:getWidth() / columns
    local height = width
    local rows = image:getHeight() / width
    for y=1,rows do
        for x=1,columns do
            table.insert(quads, love.graphics.newQuad((x-1)*width, (y-1)*height, width, height, image:getWidth(), image:getHeight()))
        end
    end
    return quads
end
