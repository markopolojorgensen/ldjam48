extends Label

func _ready():
	global.connect("logic_update", self, "logic_update")

func logic_update():
	if global.easy_mode:
		get_parent().get_parent().show()
	else:
		get_parent().get_parent().hide()


