
paleotest.dinosaurs = {
    brachiosaurus = "Brachiosaurus", carnotaurus = "Carnotaurus",
    pteranodon = "Pteranodon", quetzalcoatlus = "Quetzalcoatlus", 
    sarcosuchus = "Sarcosuchus", spinosaurus = "Spinosaurus", 
    stegosaurus = "Stegosaurus", triceratops = "Triceratops",
    tyrannosaurus = "Tyrannosaurus", velociraptor = "Velociraptor"
  };

paleotest.iceage_animals = { 
    dire_wolf = "Dire_wolf", elasmotherium = "Elasmotherium",
    mammoth = "Mammoth", procoptodon = "Procoptodon",
    smilodon = "Smilodon", thylacoleo = "Thylacoleo"
  };

paleotest.water_dinosaurs = {
    dunkleosteus = "Dunkleosteus", mosasaurus = "Mosasaurus", 
    plesiosaurus = "Plesiosaurus"
  };

paleotest.hades_seeds = { 
    wheat = "Wheat", cotton = "Cotton",
    spice = "Spice", potato = "Potato",
    strawberry = "Strawberry", tomato = "Tomato",
  };

paleotest.hades_animals = {
    bee = "Bee", chicken = "Chicken", bunny = "Bunny",
    cow = "Cow", kitten = "Kitten", panda = "Panda", 
    penguin = "Penguin", pumba = "Pumba", rat = "Rat", 
    sheep = "Sheep",
  };
paleotest.hades_petz = {};
paleotest.hades_villages = {
  villager_male = "Villager Male",
  villager_female = "Villager Female",
};

minetest.register_alias("default:diamond", "hades_core:diamond");


--
-- Fence registration helper
--
local fence_collision_extra = minetest.settings:get_bool("enable_fence_tall") and 3/8 or 0

function paleotest.register_fence_rail(name, def)
 minetest.register_craft({
  output = name .. " 16",
  recipe = {
   { def.material, def.material },
   { "", ""},
   { def.material, def.material },
  }
 })

 local fence_rail_texture = "paleotest_fence_rail_overlay.png^" .. def.texture ..
   "^paleotest_fence_rail_overlay.png^[makealpha:255,126,126"
 -- Allow almost everything to be overridden
 local default_fields = {
  paramtype = "light",
  drawtype = "nodebox",
  node_box = {
   type = "connected",
   fixed = {{-1/16,  3/16, -1/16, 1/16,  5/16, 1/16},
     {-1/16, -3/16, -1/16, 1/16, -5/16, 1/16}},
   -- connect_top =
   -- connect_bottom =
   connect_front = {{-1/16,  3/16, -1/2,   1/16,  5/16, -1/16},
             {-1/16, -5/16, -1/2,   1/16, -3/16, -1/16}},
   connect_left =  {{-1/2,   3/16, -1/16, -1/16,  5/16,  1/16},
             {-1/2,  -5/16, -1/16, -1/16, -3/16,  1/16}},
   connect_back =  {{-1/16,  3/16,  1/16,  1/16,  5/16,  1/2 },
             {-1/16, -5/16,  1/16,  1/16, -3/16,  1/2 }},
   connect_right = {{ 1/16,  3/16, -1/16,  1/2,   5/16,  1/16},
                           { 1/16, -5/16, -1/16,  1/2,  -3/16,  1/16}}
  },
  collision_box = {
   type = "connected",
   fixed = {-1/8, -1/2, -1/8, 1/8, 1/2 + fence_collision_extra, 1/8},
   -- connect_top =
   -- connect_bottom =
   connect_front = {-1/8, -1/2, -1/2,  1/8, 1/2 + fence_collision_extra, -1/8},
   connect_left =  {-1/2, -1/2, -1/8, -1/8, 1/2 + fence_collision_extra,  1/8},
   connect_back =  {-1/8, -1/2,  1/8,  1/8, 1/2 + fence_collision_extra,  1/2},
   connect_right = { 1/8, -1/2, -1/8,  1/2, 1/2 + fence_collision_extra,  1/8}
  },
  connects_to = {"group:fence", "group:wall"},
  inventory_image = fence_rail_texture,
  wield_image = fence_rail_texture,
  tiles = {def.texture},
  sunlight_propagates = true,
  is_ground_content = false,
  groups = {},
 }
 for k, v in pairs(default_fields) do
  if def[k] == nil then
   def[k] = v
  end
 end

 -- Always add to the fence group, even if no group provided
 def.groups.fence = 1

 def.texture = nil
 def.material = nil

 minetest.register_node(name, def)
end

