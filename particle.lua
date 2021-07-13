local function box_sparkles(pos,dir,texture)
    local dir = dir or {x=0, y=4.4, z=0}
minetest.add_particlespawner({
    amount = 1,
    time = 1,
    minpos = {x=pos.x-1, y=pos.y-0.4, z=pos.z-1},
    maxpos = {x=pos.x+1, y=pos.y+1, z=pos.z+1},
    minvel = dir,
    maxvel = vector.multiply(dir,1),
    minacc = {x=0, y=0, z=0},
    maxacc = {x=0, y=1, z=0},
    minexptime = 0.2,
    maxexptime = 1.2,
    minsize = 0.5,
    maxsize = 1.2,

    collisiondetection = false,
    collision_removal = false,
    vertical = true,
    texture = texture or "spark.png",
    animation = {
        type = "vertical_frames",
        aspect_w = 16,
        aspect_h = 16,
        length = 1},
        {
            type = "sheet_2d",
            frames_w = 1,
            frames_h = 16,
            frame_length = 1,
        },
    glow = 12
})
end

gwell.sparkle = box_sparkles
