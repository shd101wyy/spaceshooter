targets = newFreeList()

--- Add a target to the global list of targets.
-- The target's __target_id property is set so don't use a property of the same name in your code.
-- The target must have the damage and getBB methods.
-- @param target The target table to be added to the global list of targets
function addTarget(target)
    target.__target_id = targets:allocate(target)
end

--- Removes the target from the global list of targets
-- @param target The target to be removed
function removeTarget(target)
    targets:deallocate(target.__target_id)
end

--- Damages a target in the global list of targets.
-- @param point_x The x coordinate of the point where damage is happening
-- @param point_y The y coordinate of the point where damage is happening
-- @param damageAmount The amount of damage to apply to the target
function damageTarget(point_x, point_y, damageAmount)
    for _,target in ipairs(targets) do
        if target then
            local bb = target:getBB()
            if bb.max_x >= point_x and bb.min_x <= point_x then
                if bb.max_y >= point_y and bb.min_y <= point_y then
                    target:damage(point_x, point_y, damageAmount)
                    return true
                end
            end
        end
    end
    return false
end