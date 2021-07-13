local modname = minetest.get_current_modname()

local ent = {
    physical = true,
    collide_with_objects = true,
    collisionbox = {-0.5, 0.0, -0.5, 0.5, 1.0, 0.5},
    selectionbox = {-0.5, 0.0, -0.5, 0.5, 1.0, 0.5},
    pointable = false,
    is_visible = false,
    static_save = false,
    on_activate = function(self, staticdata)
        local obj = self.object
        local vel = minetest.deserialize(staticdata)
        obj:set_velocity(vel)
    end,
    on_step = function(self)
        local obj = self.object
        local name = gwell.getMeta(obj, "parent_player")

        if(gwell.isDragging(obj) or not gwell.playerIsAlive(name))then
            gwell.delist(name)
            gwell.invertPlayerPhysics(name,true)
            obj:remove()
            say(name)
        else
            gwell.attenuateVel(obj)
            gwell.enforceGravity(obj)
            gwell.movePlayer(obj,name)
        end
    end

}
local name = modname..":entity_force"
minetest.register_entity(name, ent)