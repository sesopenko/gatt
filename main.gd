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
	var num_regions_2x2 := 4
	
	var border_width:int = _border_width_control.value as int
	var dimensions_per_region: int = _block_dimensions * 2
	
	
	for i in set.size():
		var region = set[i]
		var region_x:int = posmod(i, num_regions_2x2)
		var region_y:int = floor(i / num_regions_2x2)
		var region_offset_x:int = region_x * dimensions_per_region
		var region_offset_y:int = region_y * dimensions_per_region
		
		for bi in region.size():
			var tile_color = _floor_colour
			if region[bi]:
				tile_color = _wall_colour
			var blit_x:int = posmod(bi, 2)
			var blit_y:int = floor(bi / 2)
			var blit_offset_x:int = region_offset_x + (blit_x * (_block_dimensions))
			var blit_offset_y:int = region_offset_y + (blit_y * (_block_dimensions))
			var tile_rect:Rect2 = Rect2(blit_offset_x, blit_offset_y, _block_dimensions, _block_dimensions)
			_rendered_template.fill_rect(tile_rect, tile_color)
		# Draw guide for region
		var top_rect := Rect2(region_offset_x, region_offset_y, dimensions_per_region, border_width)
		_rendered_guide.fill_rect(top_rect, _border_colour)
		var left_rect := Rect2(region_offset_x, region_offset_y, border_width, dimensions_per_region)
		_rendered_guide.fill_rect(top_rect, _border_colour)
		var right_rect := Rect2(region_offset_x + dimensions_per_region - border_width, region_offset_y, border_width, dimensions_per_region)
		_rendered_guide.fill_rect(right_rect, _border_colour)
		var bottom_rect := Rect2(region_offset_x, region_offset_y + dimensions_per_region - border_width, dimensions_per_region, border_width)
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
	
	var tiles_per_region_dimension = 3
	var border_width:int = _border_width_control.value as int
	var dimensions_per_region: int = _block_dimensions * tiles_per_region_dimension
	
	var regions_dimensions_x:int = 12
	var regions_dimensions_y:int = 4
	
	for region_y in regions_dimensions_y:
		for region_x in regions_dimensions_x:
			var region_index:int = posmod(region_x, regions_dimensions_x) + region_y * regions_dimensions_x
			var region = set[region_index]
			var region_offset_x:int = region_x * dimensions_per_region
			var region_offset_y:int = region_y * dimensions_per_region
			
			for blit_x in tiles_per_region_dimension:
				for blit_y in tiles_per_region_dimension:
					var ri:int = blit_y * tiles_per_region_dimension + posmod(blit_x, tiles_per_region_dimension)
					var tile_color = _floor_colour
					if region[ri]:
						tile_color = _wall_colour
					var blit_offset_x:int = region_offset_x + (blit_x * (_block_dimensions))
					var blit_offset_y:int = region_offset_y + (blit_y * (_block_dimensions))
					var tile_rect:Rect2 = Rect2(blit_offset_x, blit_offset_y, _block_dimensions, _block_dimensions)
					_rendered_template.fill_rect(tile_rect, tile_color)
			# Draw guide for region
			var top_rect := Rect2(region_offset_x, region_offset_y, dimensions_per_region, border_width)
			_rendered_guide.fill_rect(top_rect, _border_colour)
			var left_rect := Rect2(region_offset_x, region_offset_y, border_width, dimensions_per_region)
			_rendered_guide.fill_rect(top_rect, _border_colour)
			var right_rect := Rect2(region_offset_x + dimensions_per_region - border_width, region_offset_y, border_width, dimensions_per_region)
			_rendered_guide.fill_rect(right_rect, _border_colour)
			var bottom_rect := Rect2(region_offset_x, region_offset_y + dimensions_per_region - border_width, dimensions_per_region, border_width)
			_rendered_guide.fill_rect(bottom_rect, _border_colour)
	
	merge_images_and_display()
	$VBoxContainer/FinalImageContainer/HBoxContainer2/FinalLabel.text = "Subtile size: %d" % (_block_dimensions * 3)

func get_dimensions()->Vector2:
	var border_width = _border_width_control.value as int
	if _current_grid_mode == GRID_MODE.MODE_2X2:
		var num_sections = 4
		var num_tiles = num_sections * 2
		var num_borders = num_sections
		var total_width = (_block_dimensions * num_tiles)
		
		return Vector2(total_width, total_width)
	elif _current_grid_mode == GRID_MODE.MODE_3X3:
		var num_sections_x = 12
		var num_sections_y = 4
		var num_tiles = 3
		return Vector2(num_sections_x * num_tiles * _block_dimensions, num_sections_y * num_tiles * _block_dimensions)
		
	else:
		return Vector2(1,1)

func merge_images_and_display()->void:
	var display_img: Image = Image.new()
	var dimensions = get_dimensions()
	display_img.create(dimensions.x, dimensions.y, false, Image.FORMAT_RGBA8)
	
	display_img.blit_rect(_rendered_template, Rect2(0, 0, dimensions.x, dimensions.y), Vector2(0, 0))
	if _preview_guide_file:
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
