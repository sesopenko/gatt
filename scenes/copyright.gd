extends Label


func _ready():
	var d = OS.get_date()
	text = "Copyright © Sean Esopenko %s" % d["year"]
