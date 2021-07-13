local modname = minetest.get_current_modname()

minetest.register_craftitem(modname..":test",{
    mesh = "plane.obj",
    description = "panel",
    inventory_image = "key.png",
    on_use = function(itemstack, user, pointed_thing)
        local name = user:get_player_name()
        local pos = user:get_pos()
        pos.y = pos.y + 1
        gwell.createWell(pos,gwell.getRotation(name))
    end,
    on_secondary_use = function()
    end,
    on_place = function()
    end
})