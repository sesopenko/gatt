tool
extends EditorPlugin

var gatt_ui: Control
var control_button: ToolButton

func _enter_tree():
	gatt_ui = load("res://addons/gatt/main.tscn").instance()
	control_button = add_control_to_bottom_panel(gatt_ui, "GATT")
	control_button.show()

func _exit_tree():
	if is_instance_valid(gatt_ui):
		remove_control_from_bottom_panel(gatt_ui)
		gatt_ui.free()
