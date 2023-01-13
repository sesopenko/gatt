extends GdUnitTestSuite
class_name TileTemplateTest


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func test_get_image_dimensions(input_blocksize: int, input_gridmode: int, expected_dimensions: Vector2, test_parameters := [
	[16, DataDb.TileTemplate.GRID_MODE.MODE_2X2, Vector2(128, 128)],
	[32, DataDb.TileTemplate.GRID_MODE.MODE_2X2, Vector2(256, 256)],
	[16, DataDb.TileTemplate.GRID_MODE.MODE_3X3_MINIMAL, Vector2(576, 192)],
	[16, DataDb.TileTemplate.GRID_MODE.MODE_3X3_TOP_FLOOR, Vector2(768, 256)]
])->void:
	
	var sut = TileTemplateBuilder.build(input_gridmode, input_blocksize)
	var image_dimensions_result = sut.get_image_dimensions()
	assert_vector2(image_dimensions_result).is_equal(expected_dimensions)
	
	
