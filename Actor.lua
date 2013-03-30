--- Construct for the actor class. No params.
-- If you are subclassing the actor, make sure to call Actor.init(self).
-- @class function
-- @name Actor
-- @param self self
Actor = class(function(self)

end)

--- Called upon the update.
-- @param dt Time in seconds to update this actor by
function Actor:update(dt)

end

--- Called upon the draw.
-- @param dt Time in seconds to update the drawn parts of this actor by
function Actor:draw(dt)

end

--- Removes this actor from the global actors list.
-- It will no longer be updated, and draw will no longer be called on it.
function Actor:remove()
    removeActor(self.__actor_id)
    self.__actor_id = 0
end

actors = newFreeList()

--- Adds an actor to the global list of actors.
-- The update and draw methods will be called periodically along with the other actors in this
-- simulation.
-- @param actor An actor instance to be added to the list
function addActor(actor)
    actor.__actor_id = actors:allocate(actor)
end

function removeActor(index)
    actors:deallocate(index)
end