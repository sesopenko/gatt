extends Node
class_name TileTemplateBuilder

# this has to be a separate class to get around self reference problems.

static func build(grid_mode: int, block_size: int)->DataDb.TileTemplate:
	var set: Array
	var offset_scalars: Array = DataDb.TileTemplate.offset_scalar_map[grid_mode]
	var dimension_scalars: Array = DataDb.TileTemplate.dimension_scalar_map[grid_mode]
	var template_cell_qty: Vector2
	if grid_mode == DataDb.TileTemplate.GRID_MODE.MODE_2X2:
		set = get_2x2()
		template_cell_qty = Vector2(4, 4)
	elif grid_mode == DataDb.TileTemplate.GRID_MODE.MODE_3X3_MINIMAL:
		set = get_3x3()
		template_cell_qty = Vector2(12, 4)
	elif grid_mode == DataDb.TileTemplate.GRID_MODE.MODE_3X3_TOP_FLOOR:
		set = get_3x3_top_floor()
		template_cell_qty = Vector2(4, 4)
	return DataDb.TileTemplate.new(block_size, set, offset_scalars, dimension_scalars, template_cell_qty)

static func get_2x2()->Array:
	# Provides all the possible combinations for 2x2
	# Using an aesthetic, easier to understand map rather than
	# computing them all.
	
	# Reference: https://docs.godotengine.org/en/stable/tutorials/2d/using_tilemaps.html#autotiles
	var squares = [
		# Row 0
		[0, 0,
		1, 0],
		
		[0, 1,
		0, 1],
		
		[1, 0,
		1, 1,],
		
		[0, 0,
		1, 1,],
		
		# Row 1
		[1, 0,
		0, 1,],
		
		[0, 1,
		1, 1,],
		
		[1, 1,
		1, 1,],
		
		[1 ,1,
		1, 0],
		
		# Row 2
		[0, 1,
		0, 0,],
		
		[1, 1,
		0, 0,],
		
		[1, 1,
		0, 1,],
		
		[1, 0,
		1, 0,],
		
		# Row 3
		[0, 0,
		0, 0,],
		
		[0, 0,
		0, 1,],
		
		[0, 1,
		1, 0,],
		
		[1, 0,
		0, 0,],
	]
	return squares
	
static func get_3x3()->Array:
	# Provides all the possible combinations for 3x3 in a more aesthetic manner than automatically
	# generating them.
	
	# Source: https://docs.godotengine.org/en/stable/tutorials/2d/using_tilemaps.html#autotiles
	var squares = [
		[0, 0, 0,
		0, 1, 0,
		0, 1, 0],
		
		[0, 0, 0,
		0, 1, 1,
		0, 1, 0,],
		
		[0, 0, 0,
		1, 1, 1,
		0, 1, 0,],
		
		[0, 0, 0,
		1, 1, 0,
		0, 1, 0,],
		
		[1, 1, 0,
		1, 1, 1,
		0, 1, 0,],
		
		[0, 0, 0,
		1, 1, 1,
		0, 1, 1,],
		
		[0, 0, 0,
		1, 1, 1,
		1, 1, 0,],
		
		[0, 1, 1,
		1, 1, 1,
		0, 1, 0,],
		
		[0, 0, 0,
		0, 1, 1,
		0, 1, 1,],
		
		[0, 1, 0,
		1, 1, 1,
		1, 1, 1,],
		
		[0, 0, 0,
		1, 1, 1,
		1, 1, 1,],
		
		[0, 0, 0,
		1, 1, 0,
		1, 1, 0,],
		
		[0, 1, 0,
		0, 1, 0,
		0, 1, 0,],
		
		[0, 1, 0,
		0, 1, 1,
		0, 1, 0],
		
		[0, 1, 0,
		1, 1, 1,
		0, 1, 0],
		
		[0, 1, 0,
		1, 1, 0,
		0, 1, 0,],
		
		[0, 1, 0,
		0, 1, 1,
		0, 1, 1,],
		
		[0, 1, 1,
		1, 1, 1,
		1, 1, 1,],
		
		[1, 1, 0,
		1, 1, 1,
		1, 1, 1,],
		
		[0, 1, 0,
		1, 1, 0,
		1, 1, 0,],
		
		[0, 1, 1,
		0, 1, 1,
		0, 1, 1,],
		
		[0, 1, 1,
		1, 1, 1,
		1, 1, 0,],
		
		[0, 0, 0,
		0, 0, 0,
		0, 0, 0],
		
		[1, 1, 0,
		1, 1, 1,
		1, 1, 0,],
		
		[0, 1, 0,
		0, 1, 0,
		0, 0, 0],
		
		[0, 1, 0,
		0, 1, 1,
		0, 0, 0],
		
		[0, 1, 0,
		1, 1, 1,
		0, 0, 0,],
		
		[0, 1, 0,
		1, 1, 0,
		0, 0, 0,],
		
		[0, 1, 1,
		0, 1, 1,
		0, 1, 0,],
		
		[1, 1, 1,
		1, 1, 1,
		0, 1, 1,],
		
		[1, 1, 1,
		1, 1, 1,
		1, 1, 0,],
		
		[1, 1, 0,
		1, 1, 0,
		0, 1, 0,],
		
		[0, 1, 1,
		1, 1, 1,
		0, 1, 1,],
		
		[1, 1, 1,
		1, 1, 1,
		1, 1, 1,],
		
		[1, 1, 0,
		1, 1, 1,
		0, 1, 1,],
		
		[1, 1, 0,
		1, 1, 0,
		1, 1, 0,], 
		
		[0, 0, 0,
		0, 1, 0, 
		0, 0, 0,],
		
		[0, 0, 0,
		0, 1, 1,
		0, 0, 0,],
		
		[0, 0, 0,
		1, 1, 1,
		0, 0, 0],
		
		[0, 0, 0,
		1, 1, 0,
		0, 0, 0,],
		
		[0, 1, 0,
		1, 1, 1,
		1, 1, 0,],
		
		[0, 1, 1,
		1, 1, 1,
		0, 0, 0,],
		
		[1, 1, 0,
		1, 1, 1,
		0, 0, 0],
		
		[0, 1, 0,
		1, 1, 1,
		0, 1, 1,],
		
		[0, 1, 1,
		0, 1, 1,
		0, 0, 0,],
		
		[1, 1, 1,
		1, 1, 1,
		0, 0, 0,],
		
		[1, 1, 1,
		1, 1, 1,
		0, 1, 0,],
		
		[1, 1, 0,
		1, 1, 0,
		0, 0, 0,]
		
	]
	return squares
	
static func get_3x3_top_floor()->Array:
	var set:Array = [
		# Row 0 ###########################
		[1,1,1,
		1,0,1,
		1,0,1,],
		
		[1,1,1,
		1,0,0,
		1,0,1,],
		
		[1,1,1,
		0,0,0,
		1,0,1,],
		
		[1,1,1,
		0,0,1,
		1,0,1],
		
		[0,0,1,
		0,0,0,
		1,0,1],
		
		[1, 1, 1,
		0, 0, 0,
		1, 0, 0,],
		
		[1,1,1,
		0,0,0,
		0,0,1],
		
		[1,0,0,
		0,0,0,
		1,0,1,],
		
		[1,1,1,
		1,0,0,
		1,0,0,],
		
		[1, 0, 1,
		0,0,0,
		0,0,0,],
		
		[1,1,1,
		0,0,0,
		0,0,0,],
		
		[1,1,1,
		0, 0, 1,
		0, 0, 1],
		
		# Row 1 ###########################
		
		[1, 0, 1,
		1, 0, 1,
		1, 0, 1,],
		
		[1, 0, 1,
		1,0,0,
		1, 0, 1,],
		
		[1, 0, 1,
		0,0,0,
		1, 0, 1,],
		
		[1, 0, 1,
		0,0,1,
		1, 0, 1],
		
		[1, 0, 1,
		1, 0, 0,
		1, 0, 0,],
		
		[1, 0, 0,
		0,0,0,
		0,0,0,],
		
		[0, 0, 1,
		0,0,0,
		0,0,0,],
		
		[1, 0, 1,
		0, 0, 1,
		0, 0, 1,],
		
		[1, 0, 0,
		1, 0, 0,
		1, 0, 0,],
		
		[1, 0, 0,
		0, 0, 0,
		0, 0, 0,],
		
		[-1, -1, -1, #transparent air
		-1, -1, -1,
		-1, -1, -1,],
		
		
		[0, 0, 1,
		0, 0, 0,
		0, 0, 1],
		
		# Row 2 ###########################
		[1, 0, 1,
		1, 0, 1,
		1, 1, 1,],
		
		[1, 0, 1,
		1, 0, 0,
		1, 1, 1],
		
		[1, 0, 1,
		0, 0, 0,
		1, 1, 1,],
		
		[1, 0, 1,
		0, 0, 1,
		1, 1, 1,],
		
		[1, 0, 0,
		1, 0, 0,
		1, 0, 1,],
		
		[0, 0, 0,
		0, 0, 0,
		1, 0, 0,],
		
		[0, 0, 0,
		0, 0, 0,
		0, 0, 1],
		
		[0, 0, 1,
		0, 0, 1,
		1, 0, 1],
		
		[1, 0, 0,
		0, 0, 0,
		1, 0, 0],
		
		[0, 0, 0,
		0, 0, 0,
		0, 0, 0,],
		
		[0, 0, 1,
		0, 0, 0,
		1, 0, 0],
		
		[0, 0, 1,
		0, 0, 1,
		0, 0, 1,],
		
		# Row 3 ###########################
		[1, 1, 1,
		1, 0, 1,
		1, 1, 1],
		
		[1, 1, 1,
		1, 0, 0,
		1, 1, 1],
		
		[1, 1, 1,
		0, 0, 0,
		1, 1, 1,],
		
		[1, 1, 1,
		0, 0, 1,
		1, 1, 1,],
		
		[1, 0, 1,
		0, 0, 0,
		0, 0, 1],
		
		[1, 0, 0,
		0, 0, 0,
		1, 1, 1],
		
		[0, 0, 1,
		0, 0, 0,
		1, 1, 1],
		
		[1, 0, 1,
		0, 0, 0,
		1, 0, 0],
		
		[1, 0, 0,
		1, 0, 0,
		1, 1, 1,],
		
		[0, 0, 0,
		0, 0, 0,
		1, 1, 1,],
		
		[0, 0, 0,
		0, 0, 0,
		1, 0, 1],
		
		[0, 0, 1,
		0, 0, 1,
		1, 1, 1,],
		
	]
	return set
