extends PanelContainer

enum GRID_MODE {MODE_2X2, MODE_3X3}

export (NodePath) var final_image_display_path: NodePath

onready var _size_control: SpinBox = $VBoxContainer/SettingsGrid/SizeSetting as SpinBox
onready var _final_image_control: TextureRect = get_node(final_image_display_path) as TextureRect
onready var _border_width_control: SpinBox = $VBoxContainer/SettingsGrid/BorderSpinbox as SpinBox
onready var _preview_guide_control: CheckButton = $VBoxContainer/SettingsGrid/PreviewBorderCheckbox as CheckButton

# These are where the rendered images are stored so they can be written to files when needed
onready var _rendered_template: Image = Image.new()
onready var _rendered_guide: Image = Image.new()

# Using the same save dialog but keeping track of which file's being saved.
var saving_guide: bool = false

var _block_dimensions: int = 16
var _current_grid_mode = GRID_MODE.MODE_2X2

var _preview_guide_file: bool = true

var _floor_colour: Color
var _wall_colour: Color
var _border_colour: Color
var _tile_border_colour: Color

func _ready():
	_reset_defaults_for_controls()
	_capture_settings()
	generate_and_display()
	
func _reset_defaults_for_controls()->void:
	_size_control.value = _block_dimensions
	$VBoxContainer/SettingsGrid/TemplateTypeOptionButton.selected = _current_grid_mode
	
func _capture_settings()->void:
	_floor_colour = $VBoxContainer/SettingsGrid/FloorColourPicker.get_picker().color
	_wall_colour = $VBoxContainer/SettingsGrid/WallColourPicker.get_picker().color
	_border_colour = $VBoxContainer/SettingsGrid/BorderColourPicker.get_picker().color
	_current_grid_mode = $VBoxContainer/SettingsGrid/TemplateTypeOptionButton.selected
	
func generate_and_display()->void:
	_capture_settings()
	if _current_grid_mode == GRID_MODE.MODE_2X2:
		generate_and_display_2x2()
	elif _current_grid_mode == GRID_MODE.MODE_3X3:
		generate_and_display_3x3()
		
func generate_and_display_2x2()->void:
	_capture_settings()
	var dimensions = get_dimensions()
	
	_rendered_template.create(dimensions.x, dimensions.y, false, Image.FORMAT_RGBA8)
	_rendered_template.fill(_floor_colour)
	_rendered_guide.create(dimensions.x, dimensions.y, false, Image.FORMAT_RGBA8)
	
	var set: Array = TileTemplate.get_2x2()
	var num_subtiles := 4
	
	var border_width:int = _border_width_control.value as int
	var dimensions_per_subtile: int = _block_dimensions * 2
	
	
	for i in set.size():
		var subtile = set[i]
		var subtile_x:int = posmod(i, num_subtiles)
		var subtile_y:int = floor(i / num_subtiles)
		var subtile_offset_x:int = subtile_x * dimensions_per_subtile
		var subtile_offset_y:int = subtile_y * dimensions_per_subtile
		
		for bi in subtile.size():
			var block_colour = _floor_colour
			if subtile[bi]:
				block_colour = _wall_colour
			var block_x:int = posmod(bi, 2)
			var block_y:int = floor(bi / 2)
			var block_offset_x:int = subtile_offset_x + (block_x * (_block_dimensions))
			var block_offset_y:int = subtile_offset_y + (block_y * (_block_dimensions))
			var block_rect:Rect2 = Rect2(block_offset_x, block_offset_y, _block_dimensions, _block_dimensions)
			_rendered_template.fill_rect(block_rect, block_colour)
		# Draw guide for subtile
		var top_rect := Rect2(subtile_offset_x, subtile_offset_y, dimensions_per_subtile, border_width)
		_rendered_guide.fill_rect(top_rect, _border_colour)
		var left_rect := Rect2(subtile_offset_x, subtile_offset_y, border_width, dimensions_per_subtile)
		_rendered_guide.fill_rect(top_rect, _border_colour)
		var right_rect := Rect2(subtile_offset_x + dimensions_per_subtile - border_width, subtile_offset_y, border_width, dimensions_per_subtile)
		_rendered_guide.fill_rect(right_rect, _border_colour)
		var bottom_rect := Rect2(subtile_offset_x, subtile_offset_y + dimensions_per_subtile - border_width, dimensions_per_subtile, border_width)
		_rendered_guide.fill_rect(bottom_rect, _border_colour)
	
	merge_images_and_display()
	
	$VBoxContainer/FinalImageContainer/HBoxContainer2/FinalLabel.text = "Subtile size: %d" % (_block_dimensions * 2)
	
func generate_and_display_3x3()->void:
	_capture_settings()
	var dimensions = get_dimensions()
	_rendered_template.create(dimensions.x, dimensions.y, false, Image.FORMAT_RGBA8)
	_rendered_template.fill(_floor_colour)
	_rendered_guide.create(dimensions.x, dimensions.y, false, Image.FORMAT_RGBA8)
	
	var set: Array = TileTemplate.get_3x3()
	
	var blocks_per_subtile_dimension = 3
	var border_width:int = _border_width_control.value as int
	var dimensions_per_subtile: int = _block_dimensions * blocks_per_subtile_dimension
	
	var subtiles_dimensions_x:int = 12
	var subtiles_dimensions_y:int = 4
	
	for subtile_y in subtiles_dimensions_y:
		for subtile_x in subtiles_dimensions_x:
			var subtile_index:int = posmod(subtile_x, subtiles_dimensions_x) + subtile_y * subtiles_dimensions_x
			var subtile = set[subtile_index]
			var subtile_offset_x:int = subtile_x * dimensions_per_subtile
			var subtile_offset_y:int = subtile_y * dimensions_per_subtile
			
			for block_x in blocks_per_subtile_dimension:
				for block_y in blocks_per_subtile_dimension:
					var ri:int = block_y * blocks_per_subtile_dimension + posmod(block_x, blocks_per_subtile_dimension)
					var block_colour = _floor_colour
					if subtile[ri]:
						block_colour = _wall_colour
					var block_offset_x:int = subtile_offset_x + (block_x * (_block_dimensions))
					var block_offset_y:int = subtile_offset_y + (block_y * (_block_dimensions))
					var block_rect:Rect2 = Rect2(block_offset_x, block_offset_y, _block_dimensions, _block_dimensions)
					_rendered_template.fill_rect(block_rect, block_colour)
			# Draw guide for subtile
			var top_rect := Rect2(subtile_offset_x, subtile_offset_y, dimensions_per_subtile, border_width)
			_rendered_guide.fill_rect(top_rect, _border_colour)
			var left_rect := Rect2(subtile_offset_x, subtile_offset_y, border_width, dimensions_per_subtile)
			_rendered_guide.fill_rect(top_rect, _border_colour)
			var right_rect := Rect2(subtile_offset_x + dimensions_per_subtile - border_width, subtile_offset_y, border_width, dimensions_per_subtile)
			_rendered_guide.fill_rect(right_rect, _border_colour)
			var bottom_rect := Rect2(subtile_offset_x, subtile_offset_y + dimensions_per_subtile - border_width, dimensions_per_subtile, border_width)
			_rendered_guide.fill_rect(bottom_rect, _border_colour)
	
	merge_images_and_display()
	$VBoxContainer/FinalImageContainer/HBoxContainer2/FinalLabel.text = "Subtile size: %d" % (_block_dimensions * 3)

func get_dimensions()->Vector2:
	var border_width = _border_width_control.value as int
	var num_sections_x = 1
	var num_sections_y = 1
	var tiles_per_section = 1
	if _current_grid_mode == GRID_MODE.MODE_2X2:
		num_sections_x = 4
		num_sections_y = 4
		tiles_per_section = 2
	elif _current_grid_mode == GRID_MODE.MODE_3X3:
		num_sections_x = 12
		num_sections_y = 4
		tiles_per_section = 3
	var final_x = num_sections_x * tiles_per_section * _block_dimensions
	var final_y = num_sections_y * tiles_per_section * _block_dimensions
	return Vector2(final_x, final_y)

func merge_images_and_display()->void:
	var display_img: Image = Image.new()
	var dimensions = get_dimensions()
	display_img.create(dimensions.x, dimensions.y, false, Image.FORMAT_RGBA8)
	
	# this can be simply blit'd since we don't need to preserve anything underneath.  More
	# performant this way.
	display_img.blit_rect(_rendered_template, Rect2(0, 0, dimensions.x, dimensions.y), Vector2(0, 0))
	if _preview_guide_file:
		# blend this on top to preview the sub cells.
		display_img.blend_rect(_rendered_guide, Rect2(0, 0, dimensions.x, dimensions.y), Vector2(0, 0))
	var display_texture = ImageTexture.new()
	display_texture.create_from_image(display_img)
	_final_image_control.texture = display_texture

func _get_width_per_tile_set()->int:
	var single_tile_size = _size_control.value
	var width_per_tile: int = single_tile_size * 2
	return width_per_tile

func _on_ErrorPopupCloseButton_pressed():
	$ErrorPopup.hide()

func _on_SaveButton_pressed():
	$SaveDialog.current_file = "template.png"
	saving_guide = false
	$SaveDialog.popup_centered_clamped()
	
func _on_SaveGuideButton_pressed():
	$SaveDialog.current_file = "guide.png"
	saving_guide = true
	$SaveDialog.popup_centered_clamped()


func _on_SaveDialog_file_selected(path):
	var img_to_save:Image = _rendered_guide if saving_guide else _rendered_template
	var err := img_to_save.save_png(path)
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
	OS.shell_open("https://raw.githubusercontent.com/sesopenko/gatt/main/COPYING.txt")

func _on_SizeSetting_value_changed(value):
	_block_dimensions = value as int
	generate_and_display()


func _on_PreviewBorderCheckbox_pressed():
	generate_and_display()


func _on_PreviewBorderCheckbox_toggled(button_pressed):
	_preview_guide_file = button_pressed
	generate_and_display()


func _on_github_pressed():
	OS.shell_open("https://github.com/sesopenko/gatt")
