extends PanelContainer


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
var _current_grid_mode = DataDb.TileTemplate.GRID_MODE.MODE_2X2

var _preview_guide_file: bool = true

var _floor_colour: Color
var _wall_colour: Color
var _border_colour: Color
var _side_wall_colour: Color
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
	_side_wall_colour = $VBoxContainer/SettingsGrid/SideWallColourPicker.get_picker().color
	_current_grid_mode = $VBoxContainer/SettingsGrid/TemplateTypeOptionButton.selected
	
	
func generate_and_display()->void:
	_generate_and_display_with_db(_current_grid_mode)
		
func _generate_and_display_with_db(grid_mode: int)->void:
	_capture_settings()
	var border_width:int = _border_width_control.value as int
	var tile_template: DataDb.TileTemplate = DataDb.build({
		DataDb.BUILD_SPEC.BLOCK_SIZE: _block_dimensions,
		DataDb.BUILD_SPEC.GRID_MODE: grid_mode,
	})
	_prep_images_for_template(tile_template)
	for subtile_y in (tile_template.template_subtile_qty.y) as int:
		for subtile_x in (tile_template.template_subtile_qty.x) as int:
			var subtile_offset: Vector2 = tile_template.get_subtile_offset(subtile_x, subtile_y)
			# TODO: refactor this into a call, not direct property
			for block_y in tile_template.num_blocks_per_subtile:
				for block_x in tile_template.num_blocks_per_subtile:
					var block = tile_template.get_block(subtile_x, subtile_y, block_x, block_y)
					if block > 0:
						var top_block_offset: Vector2 = tile_template.get_block_offset(block_x, block_y)
						var top_block_dimension: Vector2 = tile_template.get_block_dimension(block_x, block_y)
						# need to add tile offset
						var top_block_rect: Rect2 = Rect2(
							top_block_offset + subtile_offset,
							top_block_dimension
						)
						_rendered_template.fill_rect(top_block_rect, _wall_colour)
						var wall_offset := tile_template.get_wall_offset(block_x, block_y)
						if wall_offset != DataDb.NO_WALL:
							var wall_dimension := tile_template.get_wall_dimension(block_x, block_y)
							var wall_rect := Rect2(
								subtile_offset + wall_offset,
								wall_dimension
							)
							_rendered_template.fill_rect(wall_rect, _side_wall_colour)
			# Draw guide for subtile
			var top_rect := Rect2(subtile_offset.x, subtile_offset.y, tile_template.subtile_dimension, border_width)
			_rendered_guide.fill_rect(top_rect, _border_colour)
			var left_rect := Rect2(subtile_offset.x, subtile_offset.y, border_width, tile_template.subtile_dimension)
			_rendered_guide.fill_rect(top_rect, _border_colour)
			var right_rect := Rect2(subtile_offset.x + tile_template.subtile_dimension - border_width, subtile_offset.y, border_width, tile_template.subtile_dimension)
			_rendered_guide.fill_rect(right_rect, _border_colour)
			var bottom_rect := Rect2(subtile_offset.x, subtile_offset.y + tile_template.subtile_dimension - border_width, tile_template.subtile_dimension, border_width)
			_rendered_guide.fill_rect(bottom_rect, _border_colour)
	merge_images_and_display(tile_template)
	_update_subtile_helper(_block_dimensions * 2)		
	
func _prep_images_for_template(tile_template: DataDb.TileTemplate)->void:
	var dimensions = tile_template.get_image_dimensions()
	_rendered_template.create(dimensions.x, dimensions.y, false, Image.FORMAT_RGBA8)
	_rendered_template.fill(_floor_colour)
	_rendered_guide.create(dimensions.x, dimensions.y, false, Image.FORMAT_RGBA8)
					
func _update_subtile_helper(subtile_size: int)->void:
	$VBoxContainer/FinalImageContainer/HBoxContainer2/FinalLabel.text = "Subtile size: %d" % subtile_size


func merge_images_and_display(tile_template: DataDb.TileTemplate)->void:
	var display_img: Image = Image.new()
	var dimensions = tile_template.get_image_dimensions()
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

func _on_SizeSetting_value_changed(value):
	_block_dimensions = value as int
	generate_and_display()

func _on_PreviewBorderCheckbox_pressed():
	generate_and_display()

func _on_PreviewBorderCheckbox_toggled(button_pressed):
	_preview_guide_file = button_pressed
	generate_and_display()

func _on_License_pressed():
	OS.shell_open("https://raw.githubusercontent.com/sesopenko/gatt/main/COPYING.txt")
	
func _on_github_pressed():
	OS.shell_open("https://github.com/sesopenko/gatt")


func _on_TemplateTypeOptionButton_item_selected(index):
	_current_grid_mode = index
	generate_and_display()
