---------------------
-- Embryo Incubator --
----------------------
------ Ver 1.0 -------
-----------------------
-- Initial Functions --
-----------------------

-- Added primary for Hades Revisited by SFENCE
paleotest.embryo_incubator = {}

local embryo_incubator = paleotest.embryo_incubator

embryo_incubator.recipes = {}

function embryo_incubator.register_recipe(input, output, time)
    embryo_incubator.recipes[input] = {output=output,time=time*10}
end

--------------
-- Formspec --
--------------

local embryo_incubator_fs = "formspec_version[3]" .. "size[12.75,8.5]" ..
                              "background[-1.25,-1.25;15,10;paleotest_machine_formspec.png]" ..
                              "image[5.6,0.5;1.5,1.5;paleotest_progress_bar.png^[transformR270]]" ..
                              "list[current_player;main;1.5,3;8,4;]" ..
                              "list[context;input;4,0.25;1,1;]" ..
                              "list[context;nutrients_in;4,1.5;1,1;]" ..
                              "list[context;output;7.75,0.25;1,1;]" ..
                              "list[context;nutrients_out;7.75,1.5;1,1;]" ..
                              "listring[current_player;main]" ..
                              "listring[context;input]" ..
                              "listring[current_player;main]" ..
                              "listring[context;output]" ..
                              "listring[current_player;main]"

local function get_active_embryo_incubator_fs(item_percent)
    local form = {
        "formspec_version[3]", "size[12.75,8.5]",
        "background[-1.25,-1.25;15,10;paleotest_machine_formspec.png]",
        "image[5.6,0.5;1.5,1.5;paleotest_progress_bar.png^[lowpart:" ..
            (item_percent) ..
            ":paleotest_progress_bar_full.png^[transformR270]]",
        "list[current_player;main;1.5,3;8,4;]",
        "list[context;input;4,0.25;1,1;]",
        "list[context;nutrients_in;4,1.5;1,1;]",
        "list[context;output;7.75,0.25;1,1;]",
        "list[context;nutrients_out;7.75,1.5;1,1;]",
        "label[2,2.75;"..minetest.colorize("#000000","Keep process running without interrupt!").."]",
        "listring[current_player;main]",
        "listring[context;input]", "listring[current_player;main]",
        "listring[context;output]", "listring[current_player;main]"
    }
    return table.concat(form, "")
end

local function update_formspec(progress, goal, meta)
    local formspec

    if progress > 0 and progress <= goal then
        local item_percent = math.floor(progress / goal * 100)
        formspec = get_active_embryo_incubator_fs(item_percent)
    else
        formspec = embryo_incubator_fs
    end

    meta:set_string("formspec", formspec)
end

---------------
-- Cultivate --
---------------

local function cultivate(pos)
    local meta = minetest.get_meta(pos)
    local inv = meta:get_inventory()
    local input_item = inv:get_stack("input", 1)
    --local nutrients_item = inv:get_stack("nutrients", 1)
    local output_item = embryo_incubator.recipes[input_item:get_name()].output
    input_item:set_count(1)

    if not embryo_incubator.recipes[input_item:get_name()] or
        not inv:room_for_item("output", output_item) then
        minetest.get_node_timer(pos):stop()
        update_formspec(0, 3, meta)
    else
        inv:remove_item("input", input_item)
        inv:add_item("output", output_item)
    end
end

----------
-- Node --
----------

local def_desc = "Embryo incubator";

minetest.register_node("hades_paleotest:embryo_incubator", {
    description = def_desc,
    _tt_help = "Connect to power and water".."\n".."Keep process running".."\n".."Allow embryos to grow like in uterus.".."\n".."Use nutrients to support embryos grow. Depends on animal size.".."\n".."Etc one nutrient per kilogram for bigger animals (from 32kg). Small animals (to 32kg) have lower effectivity.",
    tiles = {
        "paleotest_embryo_incubator_top.png",
        "paleotest_embryo_incubator_bottom.png",
        "paleotest_embryo_incubator_side.png",
        "paleotest_embryo_incubator_side.png",
        "paleotest_embryo_incubator_side.png",
        "paleotest_embryo_incubator_front.png"
    },
    paramtype2 = "facedir",
    groups = {cracky = 2, tubedevice = 1, tubedevice_receiver = 1},
    legacy_facedir_simple = true,
    is_ground_content = false,
    sounds = hades_sounds.node_sound_stone_defaults(),
    drawtype = "node",
    
    -- mssecon action
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
        return inv:is_empty("input") and inv:is_empty("nutrients_in") and inv:is_empty("output") and inv:is_empty("nutrients_out")
    end,

    on_timer = function(pos)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        local stack = inv:get_stack("input", 1)
        local nutrients_in = inv:get_stack("nutrients_in", 1)
        local nutrients_out = inv:get_stack("nutrients_out", 1)
        if not embryo_incubator.recipes[stack:get_name()] then return false end
        
        local cultivating_time = meta:get_int("cultivating_time") or 0
        
        -- do test for water connection
        local node_over = minetest.get_node({x=pos.x;y=pos.y+1;z=pos.z});
        if (node_over.name~="pipeworks:entry_panel_loaded") then 
          if (cultivating_time>0) then
            -- incubation break, input is lost
            stack:take_item(1);
            inv:set_stack("input", 1, stack);
            meta:set_int("cultivating_time", 0)
            update_formspec(0, 3, meta)
          end
          return true;
        end
        -- check if node is powered
        local is_powered = minetest.get_meta(pos):get_int("is_powered");
        if (is_powered==0) then
          if (cultivating_time>0) then
            -- incubation break, input is lost
            stack:take_item(1);
            inv:set_stack("input", 1, stack);
            meta:set_int("cultivating_time", 0)
            update_formspec(0, 3, meta)
          end
          return true;
        end
        -- check for nutrients
        if (nutrients_in:get_count()==0) then
          if (cultivating_time>0) then
            -- incubation break, input is lost
            stack:take_item(1);
            inv:set_stack("input", 1, stack);
            meta:set_int("cultivating_time", 0)
            update_formspec(0, 3, meta)
          end
          return true;
        end
        -- check for free space of nutrients
        if (nutrients_out:get_free_space()==0) then
          if (cultivating_time>0) then
            -- incubation break, input is lost
            stack:take_item(1);
            inv:set_stack("input", 1, stack);
            meta:set_int("cultivating_time", 0)
            update_formspec(0, 3, meta)
          end
          return true;
        end
      
        local recipe = embryo_incubator.recipes[stack:get_name()]
        local output_item = recipe.output;
        local output_time = recipe.time;
        cultivating_time = cultivating_time + 1
        if ((cultivating_time%10)==0) then
          nutrients_in:take_item(1);
          inv:set_stack("nutrients_in", 1, nutrients_in);
          inv:add_item("nutrients_out", ItemStack("vessels:steel_bottle"));
        end
        if not inv:room_for_item("output", output_item) then return true end
        if cultivating_time % output_time == 0 then cultivate(pos) end
        update_formspec(cultivating_time % output_time, output_time, meta)
        meta:set_int("cultivating_time", cultivating_time)

        if (not stack:is_empty()) then
            return true
        else
            meta:set_int("cultivating_time", 0)
            update_formspec(0, 3, meta)
            return false
        end
    end,

    allow_metadata_inventory_put = function(pos, listname, _, stack, player)
        if minetest.is_protected(pos, player:get_player_name()) then
            return 0
        end
        if listname == "input" then
            return embryo_incubator.recipes[stack:get_name()] and
                       stack:get_count() or 0
        end
        if listname == "nutrients_in" then
            return stack:get_name()=="hades_paleotest:nutrients" and
                       stack:get_count() or 0
        end
        return 0
    end,

    allow_metadata_inventory_move = function() return 0 end,

    allow_metadata_inventory_take = function(pos, listname, _, stack, player)
        if minetest.is_protected(pos, player:get_player_name()) then
            return 0
        end
        
        if (listname=="input") then
          local meta = minetest.get_meta(pos);
          local cultivating_time = meta:get_int("cultivating_time") or 0
          if (cultivating_time>0) then
            local count = stack:get_count();
            if (count > 0) then return count-1; end
            return 0;
          end
        end
        
        return stack:get_count()
    end,

    on_metadata_inventory_put = function(pos)
        local meta, timer = minetest.get_meta(pos), minetest.get_node_timer(pos)
        local inv = meta:get_inventory()
        local stack = inv:get_stack("input", 1)
        local nutrients_in = inv:get_stack("nutrients_in", 1)
        local output_item = embryo_incubator.recipes[stack:get_name()]
        local cultivating_time = meta:get_int("cultivating_time") or 0
        if not embryo_incubator.recipes[stack:get_name()] then
            timer:stop()
            meta:set_string("formspec", embryo_incubator_fs)
            return
        end
        if nutrients_in:get_count()==0 then
            timer:stop()
            meta:set_string("formspec", embryo_incubator_fs)
            return
        end
        if not inv:room_for_item("output", output_item) then
            --timer:stop()
            return
        else
            if cultivating_time < 1 then update_formspec(0, 3, meta) end
            timer:start(1)
        end
    end,

    on_metadata_inventory_take = function(pos)
        local meta, timer = minetest.get_meta(pos), minetest.get_node_timer(pos)
        local inv = meta:get_inventory()
        local stack = inv:get_stack("input", 1)
        local cultivating_time = meta:get_int("cultivating_time") or 0
        if not embryo_incubator.recipes[stack:get_name()] then
            timer:stop()
            meta:set_string("formspec", embryo_incubator_fs)
            if cultivating_time > 0 then
                meta:set_int("cultivating_time", 0)
            end
            return
        end
        timer:stop()
        if cultivating_time < 1 then update_formspec(0, 3, meta) end
        timer:start(1)
    end,

    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        meta:set_string("formspec", embryo_incubator_fs)
        meta:set_string("infotext", def_desc)
        local inv = meta:get_inventory()
        inv:set_size("input", 1)
        inv:set_size("nutrients_in", 1)
        inv:set_size("output", 1)
        inv:set_size("nutrients_out", 1)
    end,
    on_blast = function(pos)
        local drops = {}
        default.get_inventory_drops(pos, "input", drops)
        default.get_inventory_drops(pos, "output", drops)
        table.insert(drops, "hades_paleotest:embryo_incubator")
        minetest.remove_node(pos)
        return drops
    end,
    
    after_place_node = function(pos)
      pipeworks.scan_for_pipe_objects(pos);
      if (not minetest.global_exists("mesecon")) then
        minetest.get_meta(pos):set_int("is_powered", 1);
      end
    end,
    after_dig_node = function(pos)
      pipeworks.scan_for_pipe_objects(pos);
    end,
})

-------------------------
-- Recipe Registration --
-------------------------

-- etc one nutrient for 1kg from 32kg size.
-- down limit is 4 nutrients per animal.
-- animal lower then 32kg, use 4+((28/32)*mass)


-- Animal Embryos --
if minetest.get_modpath("hades_animals") then
  embryo_incubator.register_recipe("hades_paleotest:embryo_bee", -- 0.2 g
                                 "hades_animals:bee", 4) -- 40 s
  embryo_incubator.register_recipe("hades_paleotest:embryo_chicken", -- 780 g
                                 "hades_animals:chicken", 5) -- 1 min
  embryo_incubator.register_recipe("hades_paleotest:embryo_bunny", -- 1.75 kg
                                 "hades_animals:bunny", 6) -- 1 min
  embryo_incubator.register_recipe("hades_paleotest:embryo_cow", -- 750 kg
                                 "hades_animals:cow", 750) -- 125 min
  embryo_incubator.register_recipe("hades_paleotest:embryo_kitten", -- 4 kg
                                 "hades_animals:kitten", 8) -- 2 min
  embryo_incubator.register_recipe("hades_paleotest:embryo_panda", -- 110 kg
                                 "hades_animals:panda", 110) -- 19 min
  embryo_incubator.register_recipe("hades_paleotest:embryo_penguin", -- 23 kg
                                 "hades_animals:penguin", 24) -- 4 min
  embryo_incubator.register_recipe("hades_paleotest:embryo_pumba", -- 90 kg
                                 "hades_animals:pumba", 90) -- 15 min
  embryo_incubator.register_recipe("hades_paleotest:embryo_rat", -- 150 g
                                 "hades_animals:rat", 4) -- 1 min
  embryo_incubator.register_recipe("hades_paleotest:embryo_sheep", -- 100 kg
                                 "hades_animals:sheep_white", 100) -- 17 min
end
if minetest.get_modpath("hades_horse") then
  embryo_incubator.register_recipe("hades_paleotest:embryo_horse", -- 690 kg
                                 "hades_horse:horse", 690) -- 115 min
end
if minetest.get_modpath("hades_petz") then
end
if minetest.get_modpath("hades_villages") then
  -- two more nutrients because of controled brain grow 
  embryo_incubator.register_recipe("hades_paleotest:embryo_villager_male", -- 80 kg
                                 "hades_villages:villager_male_egg", 160) -- 27 min
  embryo_incubator.register_recipe("hades_paleotest:embryo_villager_female", -- 80 kg
                                 "hades_villages:villager_female_egg", 160) -- 27 min
end

