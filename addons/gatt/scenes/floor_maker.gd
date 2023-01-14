tool
extends VBoxContainer
class_name FloorMaker

signal new_floor_tile(floor_tile_image)

enum FLOOR_TYPE { SOLID, CHECKERBOARD }

export (NodePath) var type_option_button_path: NodePath
export (NodePath) var color_picker_1_path: NodePath
export (NodePath) var color_picker_2_path: NodePath


onready var _type_option_button: OptionButton = get_node(type_option_button_path) as OptionButton
onready var _color_picker_1: ColorPickerButton = get_node(color_picker_1_path) as ColorPickerButton
onready var _color_picker_2: ColorPickerButton = get_node(color_picker_2_path) as ColorPickerButton

var _floor_type: int = FLOOR_TYPE.SOLID
var _block_size: int = 1
var _floor_color_1: Color
var _floor_color_2: Color

var floor_tile_image: Image setget ,get_floor_tile_image

var block_size: int setget set_block_size, get_block_size

func _ready():
	_get_settings_from_controls()
	_type_option_button.connect("item_selected", self, "_on_type_option_selected")
	_color_picker_1.connect("color_changed", self, "_on_color_changed", [1])
	_color_picker_2.connect("color_changed", self, "_on_color_changed", [2])
	_redraw()
	
func get_floor_tile_image()->Image:
	if not floor_tile_image:
		floor_tile_image= _create_floor_tile()
	return floor_tile_image
	
func _get_settings_from_controls()->void:
	_floor_type = _type_option_button.selected
	_floor_color_1 = _color_picker_1.get_picker().color
	_floor_color_2 = _color_picker_2.get_picker().color
	
func _redraw()->void:
	floor_tile_image= _create_floor_tile()
	
	var display_texture = ImageTexture.new()
	display_texture.create_from_image(floor_tile_image)
	$FloorMaker/BlockImage.texture = display_texture
	emit_signal("new_floor_tile", floor_tile_image)
	
func _on_type_option_selected(floor_type: int)->void:
	_floor_type = floor_type
	_redraw()
	
func _on_color_changed(color: Color, picker_id: int)->void:
	if picker_id == 1:
		_floor_color_1 = color
	elif picker_id == 2:
		_floor_color_2 = color
	_redraw()
		
func _on_block_size_changed(new_block_size: int)->void:
	_block_size = new_block_size
	_redraw()
	
func _create_floor_tile()->Image:
	var floor_tile:Image = Image.new()
	floor_tile.create(_block_size, _block_size, false, Image.FORMAT_RGBA8)
	if _floor_type == FLOOR_TYPE.SOLID:
		_fill_solid_block(floor_tile, _floor_color_1)
	elif _floor_type == FLOOR_TYPE.CHECKERBOARD:
		_fill_checkerboard(floor_tile, _floor_color_1, _floor_color_2)
	return floor_tile
	
func _fill_solid_block(block_image: Image, color: Color)->void:
	block_image.fill_rect(Rect2(0, 0, block_image.get_width(), block_image.get_height()), color)
	pass
	
func _fill_checkerboard(block_image: Image, color_1: Color, color_2: Color)->void:
	var check_size:int = _block_size / 8
	var image_width:int = block_image.get_width()
	var image_height:int = block_image.get_height()
	for y in (image_height / check_size) as int:
		var flip: bool = true if posmod(y, 2) == 0 else false
		for x in (image_width / check_size) as int:
			flip = not flip
			var rect := Rect2(x * check_size, y * check_size, check_size, check_size)
			var color = color_1 if flip else color_2
			block_image.fill_rect(rect, color)
	pass
	
func set_block_size(new_size: int)->void:
	_block_size = new_size
	_redraw()

func get_block_size()->int:
	return _block_size
