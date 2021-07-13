local modname = minetest.get_current_modname()

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
    mesh = "rift3.obj",
    textures = {"bg.png"},
    colors = {},
    use_texture_alpha = false,
    spritediv = {x = 1, y = 1},
    initial_sprite_basepos = {x = 0, y = 0},
    is_visible = true,
    makes_footstep_sound = false,
    automatic_rotate = 0,
    stepheight = 0,
    automatic_face_movement_dir = 0.0,
    automatic_face_movement_max_rotation_per_sec = -1,
    backface_culling = false,
    glow = 0,
    nametag = "",
    infotext = "",
    static_save = false,
    on_activate = function(self, staticdata)
        local data = minetest.deserialize(staticdata)
        local obj = self.object
        obj:set_rotation(data)
        gwell.addFlare(obj)
    end,
    on_step = function(self)
        local obj = self.object
        local pos = obj:get_pos()
        local dir = gwell.dir_from_rot(obj:get_rotation())

        local nearby_ents = gwell.scanForPlayers(pos)
        if(#nearby_ents > 0)then
            local pow = 12
            gwell.propelPlayers(nearby_ents,dir,pow)
        end
    end

}
local name = modname..":entity_rift"
minetest.register_entity(name, ent)