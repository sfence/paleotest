---------------------
-- Fossil Analyzer --
---------------------
------ Ver 2.0 ------

local fossil_output = {
	"hades_paleotest:dna_part_brachiosaurus", "hades_paleotest:dna_part_carnotaurus",
	"hades_paleotest:dna_part_dunkleosteus", "hades_paleotest:dna_part_plesiosaurus",
    "hades_paleotest:dna_part_mosasaurus","hades_paleotest:dna_part_quetzalcoatlus",
    "hades_paleotest:dna_part_pteranodon", "hades_paleotest:dna_part_sarcosuchus",
    "hades_paleotest:dna_part_spinosaurus", "hades_paleotest:dna_part_stegosaurus",
    "hades_paleotest:dna_part_triceratops", "hades_paleotest:dna_part_tyrannosaurus",
    "hades_paleotest:dna_part_velociraptor",
	"hades_core:ash 3", "hades_core:gravel 3", "hades_paleotest:bones_dinosaur",
	"hades_core:ash 3", "hades_core:gravel 3", "hades_paleotest:bones_dinosaur",
    "hades_core:ash 3", "hades_core:gravel 3", "hades_paleotest:bones_dinosaur"
}
local waste_fossil = {"hades_core:ash 3", "hades_core:gravel 3", "hades_core:cobble 3"}

local bone_output = {
    "hades_paleotest:dna_part_dire_wolf", "hades_paleotest:dna_part_elasmotherium",
    "hades_paleotest:dna_part_mammoth", "hades_paleotest:dna_part_procoptodon",
    "hades_paleotest:dna_part_smilodon", "hades_paleotest:dna_part_thylacoleo", "hades_core:ash 3",
    "hades_core:gravel 3", "hades_paleotest:bones_iceage"
}
local waste_bone = {"hades_paleotest:bones_iceage", "hades_core:tuff", "hades_core:dirt 3"}

local plant_output = {
    "hades_paleotest:fossilized_cycad_seeds", "hades_paleotest:fossilized_horsetail_spores",
    "hades_paleotest:metasequoia_sapling_petrified"
}
local waste_plant = {"hades_core:coalblock", "hades_core:coal_lump 4"}

local bone_recent_output = {"hades_paleotest:bones_recent"};
local waste_bone_recent = {"hades_paleotest:bones_recent", "hades_core:tuff", "hades_core:ash", "hades_paleotest:bones_recent", "hades_paleotest:bones_recent"};

local plant_recent_output = {"hades_core:tuff", "hades_core:fertile_sand"};
local waste_plant_recent = {"hades_core:tuff", "hades_core:fertile_sand"};

if (minetest.get_modpath("hades_farming")~=nil) then
  for key, name in pairs(paleotest.hades_seeds) do
    table.insert(plant_recent_output, "hades_paleotest:fossilized_"..key.."_seeds");
  end
end
if (minetest.get_modpath("hades_trees")~=nil) then
  for key, name in pairs(paleotest.hades_sapling) do
    table.insert(plant_recent_output, "hades_paleotest:fossilized_"..key.."_sapling");
  end
end
if (minetest.get_modpath("hades_extrafarming")~=nil) then
  for key, name in pairs(paleotest.hades_extra_seeds) do
    table.insert(plant_recent_output, "hades_paleotest:fossilized_"..key.."_seeds");
  end
end
if (paleotest.hades_cool_sapling) then
  for key, name in pairs(paleotest.hades_cool_sapling) do
    table.insert(plant_recent_output, "hades_paleotest:fossilized_cool_"..key.."_sapling");
  end
end
if (minetest.get_modpath("hades_technic_sapling")~=nil) then
  for key, name in pairs(paleotest.hades_technic_sapling) do
    table.insert(plant_recent_output, "hades_paleotest:fossilized_"..key.."_sapling");
  end
end

if (minetest.get_modpath("hades_animals")~=nil) then
  for key, name in pairs(paleotest.hades_animals) do
    table.insert(bone_recent_output, "hades_paleotest:dna_part_"..key);
  end
end

if (minetest.get_modpath("hades_horse")~=nil) then
  for key, name in pairs(paleotest.hades_horse) do
    table.insert(bone_recent_output, "hades_paleotest:dna_part_"..key);
  end
end

if (minetest.get_modpath("hades_villages")~=nil) then
  for key, name in pairs(paleotest.hades_villages) do
    table.insert(bone_recent_output, "hades_paleotest:dna_part_"..key);
  end
end

-----------------------
-- Initial Functions --
-----------------------

paleotest.fossil_analyzer = {}

minetest.register_on_mods_loaded(function()
    for _, waste in pairs(waste_fossil) do
        while #fossil_output < 64 do table.insert(fossil_output, waste) end
    end
    for _, waste in pairs(waste_bone) do
        while #bone_output < 64 do table.insert(bone_output, waste) end
    end
    for _, waste in pairs(waste_plant) do
        while #plant_output < 16 do table.insert(plant_output, waste) end
    end
    for _, waste in pairs(waste_bone_recent) do
        while #bone_recent_output < 64 do table.insert(bone_recent_output, waste) end
    end
    for _, waste in pairs(waste_plant_recent) do
        while #plant_recent_output < 16 do table.insert(plant_recent_output, waste) end
    end
end)

local fossil_analyzer = paleotest.fossil_analyzer

fossil_analyzer.recipes = {}

function fossil_analyzer.register_recipe(input, output)
    fossil_analyzer.recipes[input] = output
end

--------------
-- Formspec --
--------------

local fossil_analyzer_fs = "formspec_version[3]" .. "size[12.75,8.5]" ..
                               "background[-1.25,-1.25;15,10;paleotest_machine_formspec.png]" ..
                               "image[5.15,0.5;1.5,1.5;paleotest_progress_bar.png^[transformR270]]" ..
                               "list[current_player;main;1.5,3;8,4;]" ..
                               "list[context;input;3.5,0.75;1,1;]" ..
                               "list[context;output;7.25,0.25;2,2;]" ..
                               "listring[current_player;main]" ..
                               "listring[context;input]" ..
                               "listring[current_player;main]" ..
                               "listring[context;output]" ..
                               "listring[current_player;main]"

local function get_active_fossil_analyzer_fs(item_percent)
    local form = {
        "formspec_version[3]", "size[12.75,8.5]",
        "background[-1.25,-1.25;15,10;paleotest_machine_formspec.png]",
        "image[5.15,0.5;1.5,1.5;paleotest_progress_bar.png^[lowpart:" ..
            (item_percent) ..
            ":paleotest_progress_bar_full.png^[transformR270]]",
        "list[current_player;main;1.5,3;8,4;]",
        "list[context;input;3.5,0.75;1,1;]",
        "list[context;output;7.25,0.25;2,2;]", "listring[current_player;main]",
        "listring[context;input]", "listring[current_player;main]",
        "listring[context;output]", "listring[current_player;main]"
    }
    return table.concat(form, "")
end

local function update_formspec(progress, goal, meta)
    local formspec
    if progress > 0 and progress <= goal then
        local item_percent = math.floor(progress / goal * 100)
        formspec = get_active_fossil_analyzer_fs(item_percent)
    else
        formspec = fossil_analyzer_fs
    end
    meta:set_string("formspec", formspec)
end

-------------
-- Analyze --
-------------

local function analyze(pos)
    local meta = minetest.get_meta(pos)
    local inv = meta:get_inventory()
    local input_item = inv:get_stack("input", 1)
    local output_item = fossil_analyzer.recipes[input_item:get_name()]()
    input_item:set_count(1)

    if not fossil_analyzer.recipes[input_item:get_name()] or
        not inv:room_for_item("output", output_item) then
        minetest.get_node_timer(pos):stop()
        meta:set_string("formspec", fossil_analyzer_fs)
    else
        inv:remove_item("input", input_item)
        inv:add_item("output", output_item)
    end
end

----------
-- Node --
----------

local def_desc = "Fossil Analyzer";

minetest.register_node("hades_paleotest:fossil_analyzer", {
    description = def_desc,
    _tt_help = "Connect to power".."\n".."Analyze fossils and try to find something useful.",
    tiles = {
        "paleotest_fossil_analyzer_top.png",
        "paleotest_fossil_analyzer_bottom.png",
        "paleotest_fossil_analyzer_side.png",
        "paleotest_fossil_analyzer_side.png",
        "paleotest_fossil_analyzer_side.png",
        "paleotest_fossil_analyzer_front.png"
    },
    paramtype2 = "facedir",
    groups = {cracky = 2, tubedevice = 1, tubedevice_receiver = 1},
    legacy_facedir_simple = true,
    is_ground_content = false,
    sounds = hades_sounds.node_sound_stone_defaults(),
    drawtype = "node",
    
    -- mesecon action
    mesecons = {
      effector = {
        action_on = function(pos, node)
          minetest.get_meta(pos):set_int("is_powered", 1);
        end,
        action_off = function(pos, node)
          minetest.get_meta(pos):set_int("is_powered", 0);
        end,
      },
    },

    can_dig = function(pos)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        return inv:is_empty("input") and inv:is_empty("output")
    end,

    on_timer = function(pos)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        local stack = meta:get_inventory():get_stack("input", 1)
        if not fossil_analyzer.recipes[stack:get_name()] then
            return false
        end
        -- check if node is powered
        local is_powered = minetest.get_meta(pos):get_int("is_powered");
        if (is_powered==0) then
          return true;
        end
        
        local output_item = fossil_analyzer.recipes[stack:get_name()]()
        local analyzing_time = meta:get_int("analyzing_time") or 0
        analyzing_time = analyzing_time + 1
        if analyzing_time % 17 == 0 then analyze(pos) end
        update_formspec(analyzing_time % 17, 17, meta)
        meta:set_int("analyzing_time", analyzing_time)
        if not inv:room_for_item("output", output_item) then return false end
        if not stack:is_empty() then
            return true
        else
            meta:set_int("analyzing_time", 0)
            update_formspec(0, 3, meta)
            return false
        end
    end,

    allow_metadata_inventory_put = function(pos, listname, _, stack, player)
        if minetest.is_protected(pos, player:get_player_name()) then
            return 0
        end
        if listname == "input" then
            return fossil_analyzer.recipes[stack:get_name()] and
                       stack:get_count() or 0
        end
        return 0
    end,

    allow_metadata_inventory_move = function() return 0 end,

    allow_metadata_inventory_take = function(pos, _, _, stack, player)
        if minetest.is_protected(pos, player:get_player_name()) then
            return 0
        end
        return stack:get_count()
    end,

    on_metadata_inventory_put = function(pos) -- Recalculate on_put
        local meta, timer = minetest.get_meta(pos), minetest.get_node_timer(pos)
        local inv = meta:get_inventory()
        local stack = inv:get_stack("input", 1)
        if not fossil_analyzer.recipes[stack:get_name()] then
            return false
        end
        local output_item = fossil_analyzer.recipes[stack:get_name()]()
        local analyzing_time = meta:get_int("analyzing_time") or 0
        if not fossil_analyzer.recipes[stack:get_name()] then
            timer:stop()
            meta:set_string("formspec", fossil_analyzer_fs)
            return
        end
        if not inv:room_for_item("output", output_item) then
            timer:stop()
            return
        else
            if analyzing_time < 1 then update_formspec(0, 3, meta) end
            timer:start(1)
        end
    end,

    on_metadata_inventory_take = function(pos)
        local meta, timer = minetest.get_meta(pos), minetest.get_node_timer(pos)
        local inv = meta:get_inventory()
        local stack = inv:get_stack("input", 1)
        local analyzing_time = meta:get_int("analyzing_time") or 0
        if not fossil_analyzer.recipes[stack:get_name()] then
            timer:stop()
            meta:set_string("formspec", fossil_analyzer_fs)
            if analyzing_time > 0 then
                meta:set_int("analyzing_time", 0)
            end
            return
        end
        timer:stop()
        if analyzing_time < 1 then update_formspec(0, 3, meta) end
        timer:start(1)
    end,

    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        meta:set_string("formspec", fossil_analyzer_fs)
        meta:set_string("infotext", def_desc)
        local inv = meta:get_inventory()
        inv:set_size("input", 1)
        inv:set_size("output", 4)
    end,

    on_blast = function(pos)
        local drops = {}
        default.get_inventory_drops(pos, "input", drops)
        default.get_inventory_drops(pos, "output", drops)
        table.insert(drops, "hades_paleotest:fossil_analyzer")
        minetest.remove_node(pos)
        return drops
    end,
    
    after_place_node = function(pos)
      if (not minetest.global_exists("mesecon")) then
        minetest.get_meta(pos):set_int("is_powered", 1);
      end
    end,
})

-------------------------
-- Recipe Registration --
-------------------------

fossil_analyzer.register_recipe("hades_paleotest:fossil", function()
    return fossil_output[math.random(1, #fossil_output)]
end)

fossil_analyzer.register_recipe("hades_paleotest:ancient_bones", function()
    return bone_output[math.random(1, #bone_output)]
end)

fossil_analyzer.register_recipe("hades_paleotest:plant_fossil", function()
    return plant_output[math.random(1, #plant_output)]
end)

-- for Haddes Revisited 
fossil_analyzer.register_recipe("hades_paleotest:ancient_bones_recent", function()
    return bone_recent_output[math.random(1, #bone_recent_output)]
end)

fossil_analyzer.register_recipe("hades_paleotest:plant_fossil_recent", function()
    return plant_recent_output[math.random(1, #plant_recent_output)]
end)

