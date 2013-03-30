targets = newFreeList()

function addTarget(target)
    target.__target_id = targets:allocate(target)
end

function removeTarget(index)
    targets:deallocate(index)
end

function damageTarget(point_x, point_y, velocity_x, velocity_y, damageAmount)
    for _,target in ipairs(targets) do
        if target then
            local bb = target:getBB()
            if bb.max_x >= point_x and bb.min_x <= point_x then
                if bb.max_y >= point_y and bb.min_y <= point_y then
                    target:damage(point_x, point_y, velocity_x, velocity_y, damageAmount)
                    return true
                end
            end
        end
    end
    return false
end