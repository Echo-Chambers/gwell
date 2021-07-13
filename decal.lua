local modname = minetest.get_current_modname()
for n = 1,2 do
local ent = {
    hp_max = 1,
    breath_max = 0,
    zoom_fov = 0.0,
    eye_height = 1.625,
    physical = true,
    collide_with_objects = true,
    weight = 5,
    collisionbox = {-0.5, 0.0, -0.5, 0.5, 1.0, 0.5},
    selectionbox = {-0.5, 0.0, -0.5, 0.5, 1.0, 0.5},
    pointable = true,
    visual = "mesh",
    visual_size = {x = 10, y = 10},
    mesh = "flare_ring2.obj",
    textures = {"shine.png"},
    colors = {},
    use_texture_alpha = true,
    spritediv = {x = 1, y = 1},
    initial_sprite_basepos = {x = 0, y = 0},
    is_visible = true,
    makes_footstep_sound = false,
    automatic_rotate = 0,
    stepheight = 0,
    automatic_face_movement_dir = 0.0,
    automatic_face_movement_max_rotation_per_sec = -1,
    backface_culling = false,
    glow = 12,
    nametag = "",
    infotext = "",
    static_save = false,
    on_activate = function(self, staticdata)
        local data = minetest.deserialize(staticdata)
        local obj = self.object
        obj:set_rotation(data)
    end,
    on_step = function(self)
        local obj = self.object
        local props = obj:get_properties()
        props.hp_max = props.hp_max + 1 < 4 and props.hp_max + 1 or 1
        if(props.hp_max == 3)then
        props.breath_max = props.breath_max + 1 < 24 and props.breath_max + 1 or 1
        props.textures = {"shine.png^[verticalframe:23:"..props.breath_max}
        end
        obj:set_properties(props)
    end

}
local name = modname..":entity_rift_decal"..n
minetest.register_entity(name, ent)
end