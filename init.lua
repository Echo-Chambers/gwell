local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)

gwell = {}
gwell.occupied = {} -- player table

-- MOD CONSTANTS
gwell.GRAVITY_BASE = 0.987
gwell.POWER_BASE = 10
gwell.DEFAULT_SCAN_RADIUS = 3


dofile(modpath.."/particle.lua")
dofile(modpath.."/rift.lua")
dofile(modpath.."/force.lua")
dofile(modpath.."/item.lua")
dofile(modpath.."/decal.lua")


say = function(x)
    return minetest.chat_send_all(type(x) == "string" and x or minetest.serialize(x))
end


gwell.enlist = function(name)
    if(name and type(name) == "string")then
        gwell.occupied[name] = true
    end
end

gwell.delist = function(name)
    gwell.occupied[name] = nil
end

gwell.playerIsAlive = function(name)
    if(name and type(name) == "string" and minetest.get_player_by_name(name))then
        return minetest.get_player_by_name(name):get_hp() > 0
    end
end

local function getRotation(name)
    if(name and type(name) == "string")then
    local player = minetest.get_player_by_name(name)
        if(player)then
            local yaw = player:get_look_horizontal()
            local pitch = player:get_look_vertical()*-1 -- might need to re-evaluate facing dir from .blend
            return {x = pitch, y = yaw, z = 0}
        end
    end
end
gwell.getRotation = getRotation


local function dir_from_rot(rot)
    local yaw = rot.y
    local pitch = rot.x
    local dir = minetest.yaw_to_dir(yaw)
    dir.y = pitch
    return dir
end
gwell.dir_from_rot = dir_from_rot

local function findEntityWithParent(pos,name,r)
    r = r or gwell.DEFAULT_SCAN_RADIUS
    local ents = minetest.get_objects_inside_radius(pos, r)
    if(ents and #ents > 0)then
        for i = 1, #ents do
            ent = ents[i]
            local parent = ent and gwell.getMeta(ent,"parent_player")
            if(parent and parent == name)then return ent end
        end
    end
end
-- Well creation

local function createWell(pos, dir)
    dir = dir or {x = 0, y = 1, z = 0}
    minetest.add_entity(pos, modname .. ":entity_rift", minetest.serialize(dir))

end
gwell.createWell = createWell

local function addFlare(obj)
    local pos = obj:get_pos()
    local rot = obj:get_rotation()
    minetest.add_entity(pos, modname .. ":entity_rift_decal2", minetest.serialize(rot))
end
gwell.addFlare = addFlare
-- PHYSICS STUFF

local function invertPlayerPhysics(name, state)
    local player = minetest.get_player_by_name(name)
    if(name and type(name) == "string" and player)then
        local val = state and 1 or 0
        local physics_params = player:get_physics_override()
        physics_params.gravity = val
        physics_params.speed = 1
        physics_params.jump = val
        player:set_physics_override(physics_params)
    end
end

gwell.invertPlayerPhysics = invertPlayerPhysics

local function impulse(obj,vec)
    local vel = obj:get_velocity()
    vec = vector.add(vel,vec)
    obj:set_velocity(vec)
end
gwell.impulse = impulse

-- Well behavior

local function scanForPlayers(pos, r)
    r = r or gwell.DEFAULT_SCAN_RADIUS
    local objects = minetest.get_objects_inside_radius(pos, r, true)
    if(objects and #objects > 0)then
        for i = 1, #objects do
            local obj = objects[i]
            if obj and obj:is_player() then
            else table.remove(objects,i) end
        end
    end

    return objects
end

gwell.scanForPlayers = scanForPlayers

local function propelPlayers(players, vec,pow)
    pow = pow or gwell.POWER_BASE
    for i = 1, #players do
        if(players[i])then
            
            gwell.generateAngularVel(players[i]:get_player_name(),vector.multiply(vec,pow))
        end
    end
end
gwell.propelPlayers = propelPlayers




gwell.findEntityWithParent = findEntityWithParent
-- Physics stuff
local function generateAngularVel(name,vec)
    if(name and type(name) == "string")then
        local player = minetest.get_player_by_name(name)
        
        if(player)then
            local pos = player:get_pos()
            vec = vec
            if(gwell.occupied[name])then
                local ent = gwell.findEntityWithParent(pos,name,3)
                if ent then
                say("33")

                    gwell.impulse(ent,vec)
                end
            else
                gwell.enlist(name)
                gwell.invertPlayerPhysics(name)
                local ent = minetest.add_entity(pos, modname .. ":entity_force", minetest.serialize(vec))
                gwell.setMeta(ent,{parent_player = name})
            end
        end

    end

end
gwell.generateAngularVel = generateAngularVel

local function movePlayer(obj,name)
    local pos = obj:get_pos()
    local player = minetest.get_player_by_name(name)
    if(player)then
        player:move_to(pos)
    end
end
gwell.movePlayer = movePlayer

local function enforceGravity(obj)
    local vel = obj:get_velocity()
    vel.y = vel.y - gwell.GRAVITY_BASE
    obj:set_velocity(vel)
end
gwell.enforceGravity = enforceGravity

local function isDragging(obj)
    local vel = obj:get_velocity()
    return vel.y == 0
end
gwell.isDragging = isDragging

local function attenuateVel(obj)
    local vel = obj:get_velocity()
    vel = vector.divide(vel,1.0005)
    obj:set_velocity(vel)
end
gwell.attenuateVel = attenuateVel

-- DATA STUFF
local function setMeta(obj,metadef)
    if(obj and obj:get_luaentity())then
        local luaent = obj:get_luaentity()
        for k,v in pairs(metadef)do
            luaent[k] = v
        end
    end
end

gwell.setMeta = setMeta


local function getMeta(obj, label)
    if(obj and obj:get_luaentity())then
        local luaent = obj:get_luaentity()
        return luaent[label]
    end
end

gwell.getMeta = getMeta