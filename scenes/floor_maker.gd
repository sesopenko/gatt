extends ScrollContainer
class_name FloorMaker

signal new_floor_tile(floor_tile_image)

enum FLOOR_TYPE { SOLID, CHECKERBOARD }

export (NodePath) var type_option_button_path: NodePath
export (NodePath) var color_picker_1_path: NodePath
export (NodePath) var color_picker_2_path: NodePath

export (NodePath) var block_size_path: NodePath

onready var _type_option_button: OptionButton = get_node(type_option_button_path) as OptionButton
onready var _color_picker_1: ColorPickerButton = get_node(color_picker_1_path) as ColorPickerButton
onready var _color_picker_2: ColorPickerButton = get_node(color_picker_2_path) as ColorPickerButton
onready var _block_size_control: SpinBox = get_node(block_size_path) as SpinBox

var _floor_type: int = FLOOR_TYPE.SOLID
var _block_size: int = 1
var _floor_color_1: Color
var _floor_color_2: Color

var _floor_tile_image: Image

func _ready():
	_get_settings_from_controls()
	_type_option_button.connect("item_selected", self, "_on_type_option_selected")
	_color_picker_1.connect("color_changed", self, "_on_color_changed", [1])
	_color_picker_2.connect("color_changed", self, "_on_color_changed", [2])
	_block_size_control.connect("value_changed", self, "_on_block_size_changed")
	_redraw()
	
func get_floor_tile_image()->Image:
	if not _floor_tile_image:
		_floor_tile_image= _create_floor_tile()
	return _floor_tile_image
	
func _get_settings_from_controls()->void:
	_floor_type = _type_option_button.selected
	_block_size = _block_size_control.value
	_floor_color_1 = _color_picker_1.get_picker().color
	_floor_color_2 = _color_picker_2.get_picker().color
	
func _redraw()->void:
	_floor_tile_image= _create_floor_tile()
	
	var display_texture = ImageTexture.new()
	display_texture.create_from_image(_floor_tile_image)
	$BlockImage.texture = display_texture
	emit_signal("new_floor_tile", _floor_tile_image)
	
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
		pass
	return floor_tile
	
func _fill_solid_block(block_image: Image, color: Color)->void:
	block_image.fill_rect(Rect2(0, 0, block_image.get_width(), block_image.get_height()), color)
	pass
