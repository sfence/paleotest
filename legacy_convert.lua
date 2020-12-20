-----------------------
-- Legacy Conversion --
--------- 2.0 ---------

-- Convert Mobs --

minetest.register_globalstep(function()
    local mobs = minetest.luaentities
    for _, mob in pairs(mobs) do
        if mob
        and mob.name:match("^hades_paleotest:")
        and mob._cmi_is_mob then
            if mob.name == "hades_paleotest:elasmosaurus" then
                local pos = mob.object:get_pos()
                minetest.add_entity(pos, "hades_paleotest:plesiosaurus")
                mob.object:remove()
                return
            end
            local pos = mob.object:get_pos()
            mob_core.spawn_child(pos, mob.name)
            mob.object:remove()
        end
    end
end)

-- Convert Items/Nodes --

local old_names = {
    "Brachiosaurus",
    "Cycad",
    "Dilophosaurus",
    "Direwolf",
    "Dunkleosteus",
    "Elasmosaurus",
    "Elasmotherium",
    "Horsetails",
    "Mammoth",
    "Mosasaurus",
    "Procoptodon",
    "Pteranodon",
    "Sarcosuchus",
    "Smilodon",
    "Stegosaurus",
    "Thylacoleo",
    "Triceratops",
    "Tyrannosaurus",
    "Velociraptor",
}

local eggs = {
    "Brachiosaurus",
    "Dilophosaurus",
    "Pteranodon",
    "Sarcosuchus",
    "Spinosaurus",
    "Stegosaurus",
    "Triceratops",
    "Tyrannosaurus",
    "Velociraptor"
}

local syringes = {
    "Elasmotherium",
    "Mammoth",
    "Procoptodon",
    "Smilodon",
    "Thylacoleo"
}

for _, name in pairs(old_names) do
    minetest.register_alias_force("hades_paleotest:desert_"..name.."_fossil_block", "hades_paleotest:fossil_block")
    minetest.register_alias_force("hades_paleotest:"..name.."_fossil_block", "hades_paleotest:fossil_block")
    minetest.register_alias_force("hades_paleotest:"..name.."_fossil", "hades_paleotest:fossil")
    minetest.register_alias_force("hades_paleotest:"..name.."_dna", "hades_paleotest:dna_"..string.lower(name))
end

for _, name in pairs(eggs) do
    minetest.register_alias_force("hades_paleotest:"..name.."_egg", "hades_paleotest:egg_"..string.lower(name))
end

for _, name in pairs(syringes) do
    minetest.register_alias_force("hades_paleotest:"..name.."_baby", "hades_paleotest:syringe_"..string.lower(name))
end

-- New name DNA --

minetest.register_alias_force("hades_paleotest:Direwolf_dna", "hades_paleotest:dna_dire_wolf")
minetest.register_alias_force("hades_paleotest:Elasmosaurus_dna", "hades_paleotest:dna_plesiosaurus")

-- New name birth items --

minetest.register_alias_force("hades_paleotest:Direwolf_baby", "hades_paleotest:syringe_dire_wolf")
minetest.register_alias_force("hades_paleotest:Dunkleosteus_baby", "hades_paleotest:sac_dunkleosteus")
minetest.register_alias_force("hades_paleotest:Elasmosaurus_baby", "hades_paleotest:sac_plesiosaurus")
minetest.register_alias_force("hades_paleotest:Mosasaurus_baby", "hades_paleotest:sac_mosasaurus")

-- Plants --

minetest.register_alias_force("hades_paleotest:Cycad", "hades_paleotest:cycad_3")
minetest.register_alias_force("hades_paleotest:Horsetails", "hades_paleotest:horsetail_3")

-- Fence --

minetest.register_alias_force("hades_paleotest:dinosaur_fence", "hades_paleotest:electric_fence_wires")
