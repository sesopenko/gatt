extends Node

## Acts as database for querying tile template dimensional data.
## Mean to be constructed with the static build() method
class_name TileTemplate

enum GRID_MODE {MODE_2X2, MODE_3X3_MINIMAL, MODE_3X3_TOP_FLOOR}

var set: Array setget , _get_set

var _offset_scalars: Array
var _dimension_scalars: Array

var _template_cell_qty: Vector2

var _block_size: int

var cell_dimension: int setget, _get_cell_dimension

var num_blocks_per_cell: int setget , _get_num_blocks_per_cell

const offset_scalar_map = {
	GRID_MODE.MODE_2X2: [0, 1],
	GRID_MODE.MODE_3X3_MINIMAL: [0, 1, 2],
	GRID_MODE.MODE_3X3_TOP_FLOOR: [0, 1, 3]
}

const dimension_scalar_map = {
	GRID_MODE.MODE_2X2: [1, 1],
	GRID_MODE.MODE_3X3_MINIMAL: [1, 2, 1],
	GRID_MODE.MODE_3X3_TOP_FLOOR: [1, 2, 1]
}

## Builds a TileTemplate database.
	
func _init(block_size: int, set: Array, offset_scalars:Array, dimension_scalars: Array, template_cell_qty: Vector2):
	set = set
	_block_size = block_size
	_offset_scalars = offset_scalars
	_dimension_scalars = dimension_scalars
	_template_cell_qty = template_cell_qty
	num_blocks_per_cell = _offset_scalars.size()
	cell_dimension = _calculate_cell_dimension()
	
func _get_num_blocks_per_cell()->int:
	return num_blocks_per_cell
	
func _get_set()->Array:
	return set
	
func _get_cell_dimension()->int:
	return cell_dimension

func get_image_dimensions()->Vector2:
	return _template_cell_qty * cell_dimension

func get_block_offset(block_index:int)->int:
	return floor(_block_size as float * _offset_scalars[block_index] as float) as int
	
func get_block_dimension(block_index:int)->int:
	return floor(_block_size as float * _dimension_scalars[block_index] as float) as int
	
func _calculate_cell_dimension()->int:
	var dimension:int = 0
	for i in _dimension_scalars.size():
		dimension += get_block_dimension(i)
	return dimension
	
