function numberToString(number, length)
    local strNumber = tostring(number)
    while #strNumber < length do
        strNumber = "0" .. strNumber
    end
    return strNumber
end

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
