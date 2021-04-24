extends Label

func _ready():
	global.connect("logic_update", self, "logic_update")

func logic_update():
	text = str(global.enemy_count)



