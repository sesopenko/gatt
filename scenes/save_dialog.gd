extends FileDialog


func _ready():
	current_dir = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS, true)
