extends Node
class_name DataDb

enum BUILD_SPEC { GRID_MODE, BLOCK_SIZE}

static func build(build_spec: Dictionary)->TileTemplate:
	var set: Array
	var grid_mode: int = build_spec[BUILD_SPEC.GRID_MODE]
	var block_size: int = build_spec[BUILD_SPEC.BLOCK_SIZE]
	var offset_scalars: Array = TileTemplate.offset_scalar_map[grid_mode]
	var dimension_scalars: Array = TileTemplate.dimension_scalar_map[grid_mode]
	var template_cell_qty: Vector2
	if grid_mode == TileTemplate.GRID_MODE.MODE_2X2:
		set = get_2x2()
		template_cell_qty = Vector2(4, 4)
	elif grid_mode == TileTemplate.GRID_MODE.MODE_3X3_MINIMAL:
		set = get_3x3()
		template_cell_qty = Vector2(12, 4)
	elif grid_mode == TileTemplate.GRID_MODE.MODE_3X3_TOP_FLOOR:
		set = get_3x3_top_floor()
		template_cell_qty = Vector2(12, 4)
	return TileTemplate.new(block_size, set, offset_scalars, dimension_scalars, template_cell_qty)

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

## Acts as database for querying tile template dimensional data.
## Mean to be constructed with the static build() method
class TileTemplate:

	enum GRID_MODE {MODE_2X2, MODE_3X3_MINIMAL, MODE_3X3_TOP_FLOOR}

	var set: Array setget , _get_set

	var _offset_scalars: Array
	var _dimension_scalars: Array

	## The quantity of subtiles in each dimension of the template
	var template_subtile_qty: Vector2

	## the dimensions of the base block used to generate the template subtiles
	var _block_size: int

	## The dimension of a given subtile (width or height)
	var subtile_dimension: int setget, _get_subtile_dimension

	## The number of blocks spanning a subtile (in both x and y, these are symmetrical)
	var num_blocks_per_subtile: int setget , _get_num_blocks_per_subtile

	const offset_scalar_map = {
		GRID_MODE.MODE_2X2: [0, 1],
		GRID_MODE.MODE_3X3_MINIMAL: [0, 1, 2],
		GRID_MODE.MODE_3X3_TOP_FLOOR: [0, 1, 3]
	}

	const dimension_scalar_map = {
		GRID_MODE.MODE_2X2: [1, 1],
		GRID_MODE.MODE_3X3_MINIMAL: [1, 1, 1],
		GRID_MODE.MODE_3X3_TOP_FLOOR: [1, 2, 1]
	}

	## Builds a TileTemplate database.
		
	func _init(block_size: int, init_set: Array, offset_scalars:Array, dimension_scalars: Array, input_template_subtile_qty: Vector2):
		set = init_set
		_block_size = block_size
		_offset_scalars = offset_scalars
		_dimension_scalars = dimension_scalars
		template_subtile_qty = input_template_subtile_qty
		num_blocks_per_subtile = _offset_scalars.size()
		subtile_dimension = _calculate_subtile_dimension()
		
	func _get_num_blocks_per_subtile()->int:
		return num_blocks_per_subtile
		
	func _get_set()->Array:
		return set
		
	func _get_subtile_dimension()->int:
		return subtile_dimension

	func get_image_dimensions()->Vector2:
		return template_subtile_qty * subtile_dimension

	func get_subtile_offset(subtile_x: int, subtile_y: int)->Vector2:
		return Vector2(
			subtile_x * subtile_dimension,
			subtile_y * subtile_dimension
		)
		

	func get_block_offset(block_x:int, block_y: int)->Vector2:
		return Vector2(
			block_x as float * _offset_scalars[block_x] as float,
			block_y as float * _offset_scalars[block_y] as float
		)
		
	func get_block_dimension_scalar(block_x:int, block_y: int)->Vector2:
		return Vector2(
			_dimension_scalars[block_x],
			_dimension_scalars[block_y]
		)

	func get_subtile(subtile_x:int, subtile_y: int)->Array:
		var subtile_index := _get_subtile_index(subtile_x, subtile_y)
		return set[subtile_index]

	func get_block(subtile_x: int, subtile_y: int, block_x: int, block_y: int)->int:
		var subtile: Array = get_subtile(subtile_x, subtile_y)
		var block_index:int = (block_y * num_blocks_per_subtile + posmod(block_x, num_blocks_per_subtile)) as int
		return subtile[block_index]
		
		
	func _calculate_subtile_dimension()->int:
		var dimension:int = 0
		for dimension_scalar in _dimension_scalars:
			dimension += dimension_scalar * _block_size
		return dimension

	func _get_subtile_index(subtile_x: int, subtile_y: int)->int:
		var y_offset: int = subtile_y * (template_subtile_qty.x as int)
		var x_offset: int = posmod(subtile_x, template_subtile_qty.x as int)
		return y_offset + x_offset
		
	func _get_block_index(block_x: int, block_y: int)->int:
		return (block_y * num_blocks_per_subtile + posmod(block_x, num_blocks_per_subtile)) as int
