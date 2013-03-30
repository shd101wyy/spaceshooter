local function allocate(self, o)
    if #self.free > 0 then
        local index = table.remove(self.free)
        self[index] = o
        return index
    else
        table.insert(self, o)
        return #self
    end
end

local function deallocate(self, index)
    if index > 0 and self[index] then
        -- If this is the last index, just pop it from the table without adding to the free list.
        if index == #self then
            table.remove(self)
        else
            self[index] = false
            table.insert(self.free, index)
        end
    end
end

function newFreeList()
    local self = { free = {}, allocate = allocate, deallocate = deallocate }
    return self
end
