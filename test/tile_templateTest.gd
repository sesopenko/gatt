extends GdUnitTestSuite
class_name TileTemplateTest


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func test_get_image_dimensions(input_buildspec: Dictionary, expected_dimensions: Vector2, test_parameters := [
	[{
		DataDb.BUILD_SPEC.BLOCK_SIZE: 16,
		DataDb.BUILD_SPEC.GRID_MODE: DataDb.TileTemplate.GRID_MODE.MODE_2X2,
		},
		Vector2(128, 128)],
	[ {
		DataDb.BUILD_SPEC.BLOCK_SIZE: 32,
		DataDb.BUILD_SPEC.GRID_MODE: DataDb.TileTemplate.GRID_MODE.MODE_2X2,
	}, Vector2(256, 256)],
	[ {
		DataDb.BUILD_SPEC.BLOCK_SIZE: 16,
		DataDb.BUILD_SPEC.GRID_MODE: DataDb.TileTemplate.GRID_MODE.MODE_3X3_MINIMAL,
	}, Vector2(576, 192)],
	[ {
		DataDb.BUILD_SPEC.BLOCK_SIZE: 16,
		DataDb.BUILD_SPEC.GRID_MODE: DataDb.TileTemplate.GRID_MODE.MODE_3X3_TOP_FLOOR,
	}, Vector2(768, 256)],
])->void:
	
	var sut = DataDb.build(input_buildspec)
	var image_dimensions_result = sut.get_image_dimensions()
	assert_vector2(image_dimensions_result).is_equal(expected_dimensions)
	
func test_get_subtile(input_build_spec: Dictionary, input_x: int, input_y: int, expected_array: Array, test_parameters := [
	[
		{
			DataDb.BUILD_SPEC.BLOCK_SIZE: 16,
			DataDb.BUILD_SPEC.GRID_MODE: DataDb.TileTemplate.GRID_MODE.MODE_2X2,
		},
		0,
		0,
		[0, 0, 1, 0],
	],
	[
		{
			DataDb.BUILD_SPEC.BLOCK_SIZE: 16,
			DataDb.BUILD_SPEC.GRID_MODE: DataDb.TileTemplate.GRID_MODE.MODE_2X2,
		},
		2,
		0,
		[1, 0, 1, 1],
	],
	[
		{
			DataDb.BUILD_SPEC.BLOCK_SIZE: 16,
			DataDb.BUILD_SPEC.GRID_MODE: DataDb.TileTemplate.GRID_MODE.MODE_3X3_MINIMAL,
		},
		2,
		1,
		[0, 1,0, 1, 1, 1, 0, 1, 0],
	],
	[
		{
			DataDb.BUILD_SPEC.BLOCK_SIZE: 16,
			DataDb.BUILD_SPEC.GRID_MODE: DataDb.TileTemplate.GRID_MODE.MODE_3X3_TOP_FLOOR,
		},
		2,
		1,
		[1,0,1,0,0,0,1,0,1],
	],
	
])->void:
	# Arrange
	var sut: DataDb.TileTemplate = DataDb.build(input_build_spec)
	
	# Act
	var result: Array = sut.get_subtile(input_x, input_y)
	# Assert
	assert_array(result).has_size(expected_array.size())
	assert_array(result).is_equal(expected_array)
	
func test_get_block(input_build_spec: Dictionary, subtile_x: int, subtile_y: int, block_x: int, block_y: int, expected_block: int, test_parameters := [
		[
			{
				DataDb.BUILD_SPEC.BLOCK_SIZE: 16,
				DataDb.BUILD_SPEC.GRID_MODE: DataDb.TileTemplate.GRID_MODE.MODE_2X2,
			},
			0, 0,
			0, 0,
			0,
		],
		[
			{
				DataDb.BUILD_SPEC.BLOCK_SIZE: 16,
				DataDb.BUILD_SPEC.GRID_MODE: DataDb.TileTemplate.GRID_MODE.MODE_2X2,
			},
			1, 1,
			1, 1,
			1,
		],
		[
			{
				DataDb.BUILD_SPEC.BLOCK_SIZE: 16,
				DataDb.BUILD_SPEC.GRID_MODE: DataDb.TileTemplate.GRID_MODE.MODE_2X2,
			},
			2, 2,
			0, 1,
			0,
		],
		[
			{
				DataDb.BUILD_SPEC.BLOCK_SIZE: 16,
				DataDb.BUILD_SPEC.GRID_MODE: DataDb.TileTemplate.GRID_MODE.MODE_3X3_MINIMAL,
			},
			7, 3,
			0, 1,
			1,
		],
		[
			{
				DataDb.BUILD_SPEC.BLOCK_SIZE: 16,
				DataDb.BUILD_SPEC.GRID_MODE: DataDb.TileTemplate.GRID_MODE.MODE_3X3_MINIMAL,
			},
			7, 3,
			0, 0,
			0,
		],
		[
			{
				DataDb.BUILD_SPEC.BLOCK_SIZE: 16,
				DataDb.BUILD_SPEC.GRID_MODE: DataDb.TileTemplate.GRID_MODE.MODE_3X3_MINIMAL,
			},
			10, 2,
			0, 0,
			1,
		],
		[
			{
				DataDb.BUILD_SPEC.BLOCK_SIZE: 16,
				DataDb.BUILD_SPEC.GRID_MODE: DataDb.TileTemplate.GRID_MODE.MODE_3X3_MINIMAL,
			},
			10, 2,
			1, 0,
			1,
		],
		[
			{
				DataDb.BUILD_SPEC.BLOCK_SIZE: 16,
				DataDb.BUILD_SPEC.GRID_MODE: DataDb.TileTemplate.GRID_MODE.MODE_3X3_MINIMAL,
			},
			10, 2,
			2, 0,
			0,
		],
		[
			{
				DataDb.BUILD_SPEC.BLOCK_SIZE: 16,
				DataDb.BUILD_SPEC.GRID_MODE: DataDb.TileTemplate.GRID_MODE.MODE_3X3_MINIMAL,
			},
			10, 2,
			0, 1,
			1,
		],
		[
			{
				DataDb.BUILD_SPEC.BLOCK_SIZE: 16,
				DataDb.BUILD_SPEC.GRID_MODE: DataDb.TileTemplate.GRID_MODE.MODE_3X3_MINIMAL,
			},
			10, 2,
			1, 1,
			1,
		],
		[
			{
				DataDb.BUILD_SPEC.BLOCK_SIZE: 16,
				DataDb.BUILD_SPEC.GRID_MODE: DataDb.TileTemplate.GRID_MODE.MODE_3X3_MINIMAL,
			},
			10, 2,
			2, 1,
			1,
		],
		[
			{
				DataDb.BUILD_SPEC.BLOCK_SIZE: 16,
				DataDb.BUILD_SPEC.GRID_MODE: DataDb.TileTemplate.GRID_MODE.MODE_3X3_MINIMAL,
			},
			10, 2,
			0, 2,
			0,
		],
		[
			{
				DataDb.BUILD_SPEC.BLOCK_SIZE: 16,
				DataDb.BUILD_SPEC.GRID_MODE: DataDb.TileTemplate.GRID_MODE.MODE_3X3_MINIMAL,
			},
			10, 2,
			1, 2,
			1,
		],
		[
			{
				DataDb.BUILD_SPEC.BLOCK_SIZE: 16,
				DataDb.BUILD_SPEC.GRID_MODE: DataDb.TileTemplate.GRID_MODE.MODE_3X3_MINIMAL,
			},
			10, 2,
			2, 2,
			1,
		],
])->void:
	pass
	# Arrange
	var sut: DataDb.TileTemplate = DataDb.build(input_build_spec)
	# Act
	var block: int = sut.get_block(subtile_x, subtile_y, block_x, block_y)
	# Assert
	assert_int(block).is_equal(expected_block)

func test_get_block_offset(build_spec: Dictionary, block_x: int, block_y: int, expected_offset: Vector2, test_parameters := [
	[
		{
				DataDb.BUILD_SPEC.BLOCK_SIZE: 16,
				DataDb.BUILD_SPEC.GRID_MODE: DataDb.TileTemplate.GRID_MODE.MODE_2X2,
			},
		0, 0,
		Vector2(0, 0)
	],
	[
		{
				DataDb.BUILD_SPEC.BLOCK_SIZE: 16,
				DataDb.BUILD_SPEC.GRID_MODE: DataDb.TileTemplate.GRID_MODE.MODE_2X2,
			},
		1, 0,
		Vector2(16, 0)
	],
	[
		{
				DataDb.BUILD_SPEC.BLOCK_SIZE: 16,
				DataDb.BUILD_SPEC.GRID_MODE: DataDb.TileTemplate.GRID_MODE.MODE_3X3_MINIMAL,
			},
		2, 0,
		Vector2(32, 0)
	],
	[
		{
				DataDb.BUILD_SPEC.BLOCK_SIZE: 16,
				DataDb.BUILD_SPEC.GRID_MODE: DataDb.TileTemplate.GRID_MODE.MODE_3X3_TOP_FLOOR,
			},
		2, 0,
		Vector2(48, 0)
	],
	[
		{
				DataDb.BUILD_SPEC.BLOCK_SIZE: 16,
				DataDb.BUILD_SPEC.GRID_MODE: DataDb.TileTemplate.GRID_MODE.MODE_3X3_TOP_FLOOR,
			},
		2, 2,
		Vector2(48, 48)
	],
	[
		{
				DataDb.BUILD_SPEC.BLOCK_SIZE: 16,
				DataDb.BUILD_SPEC.GRID_MODE: DataDb.TileTemplate.GRID_MODE.MODE_3X3_TOP_FLOOR,
			},
		1, 1,
		Vector2(16, 16)
	],
	[
		{
				DataDb.BUILD_SPEC.BLOCK_SIZE: 16,
				DataDb.BUILD_SPEC.GRID_MODE: DataDb.TileTemplate.GRID_MODE.MODE_3X3_TOP_FLOOR,
			},
		0, 0,
		Vector2(0, 0)
	],
])->void:
	pass
	# Arrange
	var sut: DataDb.TileTemplate = DataDb.build(build_spec)
	
	# Act
	var offset: Vector2 = sut.get_block_offset(block_x, block_y)
	
	# Assert
	assert_vector2(offset).is_equal(expected_offset)
	
func test_get_block_dimension(build_spec: Dictionary, block_x: int, block_y: int, expected_dimension: Vector2, test_parameters := [
	[
		{
				DataDb.BUILD_SPEC.BLOCK_SIZE: 16,
				DataDb.BUILD_SPEC.GRID_MODE: DataDb.TileTemplate.GRID_MODE.MODE_2X2,
			},
		0, 0,
		Vector2(16, 16)
	],
	[
		{
				DataDb.BUILD_SPEC.BLOCK_SIZE: 16,
				DataDb.BUILD_SPEC.GRID_MODE: DataDb.TileTemplate.GRID_MODE.MODE_3X3_MINIMAL,
			},
		2, 2,
		Vector2(16, 16)
	],
	[
		{
				DataDb.BUILD_SPEC.BLOCK_SIZE: 16,
				DataDb.BUILD_SPEC.GRID_MODE: DataDb.TileTemplate.GRID_MODE.MODE_3X3_TOP_FLOOR,
			},
		1, 0,
		Vector2(32, 16)
	],
	[
		{
				DataDb.BUILD_SPEC.BLOCK_SIZE: 16,
				DataDb.BUILD_SPEC.GRID_MODE: DataDb.TileTemplate.GRID_MODE.MODE_3X3_TOP_FLOOR,
			},
		2, 1,
		Vector2(16, 32)
	],
])->void:
	pass
	# arrange
	var sut: DataDb.TileTemplate = DataDb.build(build_spec)
	
	# act
	var result: Vector2 = sut.get_block_dimension(block_x, block_y)
	
	# assert
	assert_vector2(result).is_equal(expected_dimension)
