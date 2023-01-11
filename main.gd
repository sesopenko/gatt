extends PanelContainer

export (NodePath) var final_image_display_path: NodePath

var final_image_control: TextureRect

var _size_label: Label
var _size_control: SpinBox
var _final_image_control: TextureRect
var _border_width_control: SpinBox

var floor_colour: Color
var wall_colour: Color
var border_colour: Color

const SIZE_TEMPLATE = "Tile Dimensions: %03d"

var _tile_dimensions: int = 64

var _floor_colour: Color
var _wall_colour: Color
var _border_colour: Color

var _rendered_template: Image


func _ready():
	_size_control = $VBoxContainer/SettingsGrid/SizeSetting as SpinBox
	_final_image_control = $VBoxContainer/FinalImage as TextureRect
	_border_width_control = $VBoxContainer/SettingsGrid/BorderSpinbox as SpinBox
	_final_image_control = get_node(final_image_display_path) as TextureRect
	_reset_defaults_for_controls()
	_capture_settings()
	generate_and_display()
	
	var d = OS.get_date()
	$VBoxContainer/Copyright.text = "Copyright © Sean Esopenko %s" % d["year"]
	
func _reset_defaults_for_controls()->void:
	_size_control.value = _tile_dimensions
	
func generate_and_display()->void:
	_capture_settings()
	generate_and_display_2x2()

func generate_and_display_2x2()->void:
	
	var image: Image = generate_image_2x2()
	var display_texture = ImageTexture.new()
	_rendered_template = image
	display_texture.create_from_image(image)
	_final_image_control.texture = display_texture
	
func _on_HSlider_value_changed(value):
	_tile_dimensions = floor(value) as int

func generate_image_2x2()->Image:
	_capture_settings()
	var dimensions = get_dimensions_2x2()
	var generated = Image.new()
	generated.create(dimensions.x, dimensions.y, false, Image.FORMAT_RGBA8)
	
	var squares = [
		# Single square in each corner (4)
		[1, 0, 0, 0],
		[0, 1, 0, 0],
		[0, 0, 1, 0],
		[0, 0, 0, 1],
		# edges (4)
		[1, 1, 0, 0],
		[0, 1, 0, 1],
		[0, 0, 1, 1],
		[1, 0, 1, 0],
		# inverted square in each corner (4)
		[0, 1, 1, 1],
		[1, 0, 1, 1],
		[1, 1, 0, 1],
		[1, 1, 1, 0],
		# full squares (2)
		[0, 0, 0, 0],
		[1, 1, 1, 1],
		# diagonals (2)
		[1, 0, 0, 1],
		[0, 1, 1, 0],
	]
	assert(squares.size() == 16, "Should have 16 sets in 2x2")
	var width_per_tile_set = _get_width_per_tile_set()
	for set_x in range(4):
		for set_y in range(4):
			var square: Array = squares[set_y * 4 + set_x]
			var tile = generate_tile_image(square)
			var src_rect: Rect2 = Rect2(0, 0, tile.get_width(), tile.get_height())
			generated.blit_rect(tile, src_rect,  Vector2(set_x * width_per_tile_set, set_y * width_per_tile_set))
	return generated
	
func _capture_settings()->void:
	_floor_colour = $VBoxContainer/SettingsGrid/FloorColourPicker.get_picker().color
	_wall_colour = $VBoxContainer/SettingsGrid/WallColourPicker.get_picker().color
	_border_colour = $VBoxContainer/SettingsGrid/BorderColourPicker.get_picker().color


func _get_width_per_tile_set()->int:
	var single_tile_size = _size_control.value
	var border_width = _border_width_control.value
	var border_width_per_tile: int = border_width * 2
	var width_per_tile: int = single_tile_size * 2 + border_width_per_tile
	return width_per_tile

## Generates an image based on the given tile grid. Receives an array of booleans
## of the following order: [top_left, top_right, bottom_left, bottom_right]
func generate_tile_image(grid: Array)->Image:
	var single_tile_size = _size_control.value
	var border_width = _border_width_control.value
	var tile: Image = Image.new()
	var border_width_per_tile: int = border_width * 2
	var width_per_tile: int = _get_width_per_tile_set()
	tile.create(width_per_tile, width_per_tile, false, Image.FORMAT_RGBA8)
	tile.fill(_border_colour)
	# draw the floors underneath
	tile.fill_rect(Rect2(Vector2(border_width, border_width), Vector2(single_tile_size * 2, single_tile_size * 2)), _floor_colour)
	if grid[0]:
		tile.fill_rect(Rect2(Vector2(border_width, border_width), Vector2(single_tile_size, single_tile_size)), _wall_colour)
	if grid[1]:
		tile.fill_rect(Rect2(Vector2(border_width + single_tile_size, border_width), Vector2(single_tile_size, single_tile_size)), _wall_colour)
	if grid[2]:
		tile.fill_rect(Rect2(Vector2(border_width, border_width + single_tile_size), Vector2(single_tile_size, single_tile_size)), _wall_colour)
	if grid[3]:
		tile.fill_rect(Rect2(Vector2(border_width + single_tile_size, border_width + single_tile_size), Vector2(single_tile_size, single_tile_size)), _wall_colour)
	return tile

func get_dimensions_2x2()->Vector2:
	var dimensions = Vector2(1,1)
	# Every square will be drawn with a 1 pixel border
	var border_width_per_tile: int = _border_width_control.value * 2
	var width_per_tile: int = _size_control.value * 2 + border_width_per_tile
	var total_width = width_per_tile * 4
	
	return Vector2(total_width, total_width)

func _on_ErrorPopupCloseButton_pressed():
	$ErrorPopup.hide()

func _on_SaveButton_pressed():
	$SaveDialog.popup_centered_clamped()


func _on_SaveDialog_file_selected(path):
	var err := _rendered_template.save_png(path)
	var dialog := AcceptDialog.new()
	dialog.connect("modal_closed", dialog, "queue_free")
	if err != OK:
		dialog.window_title = "Error saving file"
		dialog.dialog_text = "Error saving file"
	else:
		dialog.window_title = "Saved File"
		dialog.dialog_text = "File Saved Successfully"
	add_child(dialog)
	dialog.popup_centered()
	

func _on_value_changed(value):
	generate_and_display()


func _on_License_pressed():
	$LicenseDialog.popup_centered_clamped()
