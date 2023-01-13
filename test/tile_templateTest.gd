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
	
])->void:
	# Arrange
	var sut: DataDb.TileTemplate = DataDb.build(input_build_spec)
	
	# Act
	var result: Array = sut.get_subtile(input_x, input_y)
	# Assert
	assert_array(result).has_size(expected_array.size())
	assert_array(result).is_equal(expected_array)
