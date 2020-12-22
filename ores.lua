--------------------
-- PaleoTest Ores --
--------------------
------ Ver 2.0 -----


--------------------
-- Ore Definition --
--------------------

-- Fossil Block --

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "hades_paleotest:fossil_block",
	wherein        = "hades_core:stone",
	clust_scarcity = 64 * 64 * 64,
	clust_num_ores = 5,
	clust_size     = 3,
	y_max          = 64,
	y_min          = -32,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "hades_paleotest:fossil_block",
	wherein        = "hades_core:stone",
	clust_scarcity = 32 * 32 * 32,
	clust_num_ores = 4,
	clust_size     = 3,
	y_max          = -32,
	y_min          = -128,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "hades_paleotest:fossil_block",
	wherein        = "hades_core:stone",
	clust_scarcity = 16 * 16 * 16,
	clust_num_ores = 5,
	clust_size     = 3,
	y_max          = -128,
	y_min          = -31000,
})

-- Suspicious Tuff --

--[[
minetest.register_ore({
	ore_type       = "scatter",
	ore            = "hades_paleotest:suspicious_permafrost",
	wherein        = "default:permafrost_with_stones",
	clust_scarcity = 32 * 32 * 32,
	clust_num_ores = 5,
	clust_size     = 3,
	y_max          = 256,
	y_min          = -256,
})
--]]

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "hades_paleotest:suspicious_tuff",
	wherein        = "hades_core:tuff",
	clust_scarcity = 32 * 32 * 32,
	clust_num_ores = 4,
	clust_size     = 3,
	y_max          = 256,
	y_min          = -256,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "hades_paleotest:suspicious_tuff_recent",
	wherein        = "hades_core:tuff",
	clust_scarcity = 32 * 32 * 32,
	clust_num_ores = 4,
	clust_size     = 3,
	y_max          = 256,
	y_min          = -256,
})
minetest.register_ore({
	ore_type       = "scatter",
	ore            = "hades_paleotest:suspicious_tuff_recent",
	wherein        = "hades_core:tuff",
	clust_scarcity = 16 * 16 * 16,
	clust_num_ores = 120,
	clust_size     = 10,
	y_max          = 256,
	y_min          = -128,
})

-- Suspicious Ash --

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "hades_paleotest:suspicious_ash_recent",
	wherein        = "hades_core:ash",
	clust_scarcity = 32 * 32 * 32,
	clust_num_ores = 4,
	clust_size     = 3,
	y_max          = 256,
	y_min          = -256,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "hades_paleotest:suspicious_ash_recent",
	wherein        = "hades_core:ash",
	clust_scarcity = 16 * 16 * 16,
	clust_num_ores = 40,
	clust_size     = 10,
	y_max          = 256,
	y_min          = -16,
})

