-----------------------
-- Craftting Recipes --
-----------------------
------- Ver 2.0 -------

--------------
-- Crafting --
--------------

minetest.register_craft({
	output = "hades_paleotest:feeder_carnivore",
	recipe = {
		{"dye:red", "hades_core:glass", "dye:red"},
		{"", "pipeworks:storage_tank_0", ""},
		{"", "hades_core:steelblock", ""},
	}
})

minetest.register_craft({
	output = "hades_paleotest:feeder_piscivore",
	recipe = {
		{"dye:blue", "hades_core:glass", "dye:blue"},
		{"", "pipeworks:storage_tank_0", ""},
		{"", "hades_core:steelblock", ""},
	}
})

minetest.register_craft({
	output = "hades_paleotest:feeder_herbivore",
	recipe = {
		{"dye:green", "hades_core:glass", "dye:green"},
		{"", "pipeworks:storage_tank_0", ""},
		{"", "hades_core:steelblock", ""},
	}
})

minetest.register_craft({
	output = "hades_paleotest:field_guide",
	recipe = {
		{"", "", ""},
		{"group:fossil", "", ""},
		{"hades_core:book", "dye:blue", ""},
	}
})

minetest.register_craft({
	output = "hades_paleotest:whip",
	recipe = {
		{"", "", "hades_farming:cotton"},
		{"", "hades_core:stick", "hades_farming:cotton"},
		{"hades_core:stick", "", "hades_farming:cotton"},
	}
})


minetest.register_craft({
	output = "hades_paleotest:pursuit_ball",
	recipe = {
		{"hades_farming:string", "wool:pink", "hades_farming:string"},
		{"wool:pink", "hades_farming:cotton", "wool:pink"},
		{"hades_farming:string", "wool:pink", "hades_farming:string"},
	}
})

minetest.register_craft({
	output = "hades_paleotest:scratching_post",
	recipe = {
		{"wool:white", "hades_trees:wood", "wool:white"},
		{"wool:white", "hades_trees:wood", "wool:white"},
		{"hades_trees:tree", "hades_trees:tree", "hades_trees:tree"},
	}
})

minetest.register_craft({
    output = "hades_paleotest:dna_cultivator",
    recipe = {
        {"hades_core:steel_ingot", "hades_core:steel_ingot", "hades_core:steel_ingot"},
        {"hades_core:glass", "pipeworks:storage_tank_0", "hades_core:glass"},
        {"hades_core:steel_ingot", "hades_core:bronze_ingot", "hades_core:steel_ingot"}
    }
})

minetest.register_craft({
    output = "hades_paleotest:fossil_analyzer",
    recipe = {
        {"hades_core:steel_ingot", "hades_core:steel_ingot", "hades_core:steel_ingot"},
        {"hades_core:steel_ingot", "hades_core:copper_ingot", "hades_core:steel_ingot"},
        {"hades_core:bronze_ingot", "hades_core:bronze_ingot", "hades_core:bronze_ingot"}
    }
})

minetest.register_craft({
	type = "cooking",
	output = "hades_paleotest:dinosaur_meat_cooked",
	recipe = "hades_paleotest:dinosaur_meat_raw",
	cooktime = 5
})

minetest.register_craft({
	type = "cooking",
	output = "hades_paleotest:mammal_meat_cooked",
	recipe = "hades_paleotest:mammal_meat_raw",
	cooktime = 5
})

minetest.register_craft({
	type = "cooking",
	output = "hades_paleotest:reptile_meat_cooked",
	recipe = "hades_paleotest:reptile_meat_raw",
	cooktime = 5
})

minetest.register_craft({
	type = "cooking",
	output = "hades_paleotest:fish_meat_cooked",
	recipe = "hades_paleotest:fish_meat_raw",
	cooktime = 5
})

minetest.register_craft({
    output = "hades_paleotest:nutrients",
    recipe = {
        {"hades_farming:flour", "hades_core:sugar", "hades_farnimg:flour"},
        {"hades_core:sugar", "hades_food:bottle_olive_oil", "hades_core:sugar"},
        {"hades_food:bottle_olive_oil", "vessels:steel_bottle", "hades_food:bottle_olive_oil"}
    },
    replacements = {{"hades_food:bottle_olive_oil", "vessels:steel_bottle"},},
})

if 1 then
  local animals = {"brachiosaurus", "carnotaurus",
    "pteranodon", "quetzalcoatlus", "sarcosuchus",
    "spinosaurus", "stegosaurus", "triceratops",
    "tyrannosaurus", "velociraptor"};
  for animal in pairs(animals) do
    local dna_part = "hades_paleotest:dna_part_"..animal;
    minetest.register_craft({
        output = "hades_paleotest:dna_"..animal,
        recipe = {{dna_part, dna_part, dna_part},
                  {dna_part, dna_part, dna_part},
                  {dna_part, dna_part, dna_part}},
      })
  end
end

if 1 then
  local animals = { "dire_wolf", "elasmotherium", "mammoth",
    "procoptodon", "smilodon", "thylacoleo"};

  for key, animal in pairs(animals) do
    local dna_part = "hades_paleotest:dna_part_"..animal;
    minetest.register_craft({
        output = "hades_paleotest:dna_"..animal,
        recipe = {{dna_part, dna_part, dna_part},
                  {dna_part, dna_part, dna_part}},
      })
  end
end

if 1 then
  local animals = { "dunkleosteus",
    "mosasaurus", "plesiosaurus"};
  for key, animal in pairs(animals) do
    local dna_part = "hades_paleotest:dna_part_"..animal;
    minetest.register_craft({
        output = "hades_paleotest:dna_"..animal,
        recipe = {{dna_part, dna_part, dna_part},
                  {dna_part, dna_part, dna_part},
                  {dna_part, dna_part, dna_part}},
      })
  end
end

if minetest.get_modpath("hades_animals")~=nil then
  for key, name in pairs(paleotest.hades_animals) do
    local dna_part = "hades_paleotest:dna_part_"..key;
    minetest.register_craft({
        type = "shapeless",
        output = "hades_paleotest:dna_"..key,
        recipe = {dna_part, dna_part, dna_part},
      })
  end
end
if minetest.get_modpath("hades_petz")~=nil then
end
if minetest.get_modpath("hades_villages")~=nil then
  for key, name in pairs(paleotest.hades_villages) do
    local dna_part = "hades_paleotest:dna_part_"..key;
    minetest.register_craft({
        output = "hades_paleotest:dna_"..key,
        recipe = {{dna_part, dna_part, dna_part},
                  {dna_part, dna_part, dna_part},
                  {dna_part, dna_part, dna_part}},
      })
  end
end


