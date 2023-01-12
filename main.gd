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

var _tile_dimensions: int = 32

var _floor_colour: Color
var _wall_colour: Color
var _border_colour: Color
var _tile_border_colour: Color

var _rendered_template: Image
var _rendered_guide: Image

var saving_guide: bool = false


func _ready():
	_size_control = $VBoxContainer/SettingsGrid/SizeSetting as SpinBox
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
	
func _on_HSlider_value_changed(value):
	_tile_dimensions = floor(value) as int

func get_set_2x2()->Array:
	var squares = [
		# Single square in each corner (4)
		[1, 0,
		0, 0],
		
		[0, 1,
		0, 0],
		
		[0, 0,
		1, 0],
		
		[0, 0,
		0, 1],
		
		# edges (4)
		[1, 1,
		0, 0],
		
		[0, 1,
		0, 1],
		
		[0, 0,
		1, 1],
		
		[1, 0,
		1, 0],
		
		# inverted square in each corner (4)
		[0, 1,
		1, 1],
		
		[1, 0,
		1, 1],
		
		[1, 1,
		 0, 1],
		
		[1, 1,
		1, 0],
		
		# full squares (2)
		[0, 0,
		0, 0],
		
		[1, 1,
		1, 1],
		
		# diagonals (2)
		[1, 0,
		0, 1],
		
		[0, 1,
		1, 0],
	]
	return squares

func generate_and_display_2x2()->void:
	_capture_settings()
	var dimensions = get_dimensions_2x2()
	var template_img:Image = Image.new()
	var guide_img: Image = Image.new()
	var display_img: Image = Image.new()
	template_img.create(dimensions.x, dimensions.y, false, Image.FORMAT_RGBA8)
	template_img.fill(_floor_colour)
	guide_img.create(dimensions.x, dimensions.y, false, Image.FORMAT_RGBA8)
	display_img.create(dimensions.x, dimensions.y, false, Image.FORMAT_RGBA8)
	
	
	
	var set: Array = get_set_2x2()
	var num_regions_2x2 := 4
	
	var border_width:int = _border_width_control.value as int
	var dimensions_per_region: int = _tile_dimensions * 2
	
	
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
			var blit_offset_x:int = region_offset_x + (blit_x * (_tile_dimensions))
			var blit_offset_y:int = region_offset_y + (blit_y * (_tile_dimensions))
			var tile_rect:Rect2 = Rect2(blit_offset_x, blit_offset_y, _tile_dimensions, _tile_dimensions)
			template_img.fill_rect(tile_rect, tile_color)
		# Draw guide for region
		var top_rect := Rect2(region_offset_x, region_offset_y, dimensions_per_region, border_width)
		guide_img.fill_rect(top_rect, _border_colour)
		var left_rect := Rect2(region_offset_x, region_offset_y, border_width, dimensions_per_region)
		guide_img.fill_rect(top_rect, _border_colour)
		var right_rect := Rect2(region_offset_x + dimensions_per_region - border_width, region_offset_y, border_width, dimensions_per_region)
		guide_img.fill_rect(right_rect, _border_colour)
		var bottom_rect := Rect2(region_offset_x, region_offset_y + dimensions_per_region - border_width, dimensions_per_region, border_width)
		guide_img.fill_rect(bottom_rect, _border_colour)
	_rendered_template = template_img
	_rendered_guide = guide_img
	
	display_img.blit_rect(template_img, Rect2(0, 0, dimensions.x, dimensions.y), Vector2(0, 0))
	display_img.blend_rect(guide_img, Rect2(0, 0, dimensions.x, dimensions.y), Vector2(0, 0))
	var display_texture = ImageTexture.new()
	display_texture.create_from_image(display_img)
	_final_image_control.texture = display_texture
	
	
func _capture_settings()->void:
	_floor_colour = $VBoxContainer/SettingsGrid/FloorColourPicker.get_picker().color
	_wall_colour = $VBoxContainer/SettingsGrid/WallColourPicker.get_picker().color
	_border_colour = $VBoxContainer/SettingsGrid/BorderColourPicker.get_picker().color


func _get_width_per_tile_set()->int:
	var single_tile_size = _size_control.value
	var width_per_tile: int = single_tile_size * 2
	return width_per_tile


func get_dimensions_2x2()->Vector2:
	var dimensions = Vector2(1,1)
	# Every square will be drawn with a 1 pixel border
	var border_width = _border_width_control.value as int
	var num_sections = 4
	var num_tiles = num_sections * 2
	var num_borders = num_sections
	var total_width = (_tile_dimensions * num_tiles)
	
	return Vector2(total_width, total_width)

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
	_tile_dimensions = value as int
	generate_and_display()
