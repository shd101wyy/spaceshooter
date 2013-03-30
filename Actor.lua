--- Construct for the actor class. No params.
-- If you are subclassing the actor, make sure to call Actor.init(self).
-- @class function
-- @name Actor
-- @param self self
Actor = class(function(self)
end)

--- Called upon the update
-- @param dt time since last update.
function Actor:update(dt)

end

function Actor:draw(dt)

end

function Actor:remove()
    removeActor(self.__actor_id)
    self.__actor_id = 0
end

actors = newFreeList()

function addActor(actor)
    actor.__actor_id = actors:allocate(actor)
end

function removeActor(index)
    actors:deallocate(index)
end