extends MarginContainer


func _ready():
	hide()
	global.connect("logic_update", self, "logic_update")

func logic_update():
	if global.final_boss_defeated:
		show()
	else:
		hide()


