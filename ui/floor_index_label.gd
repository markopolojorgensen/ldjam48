extends Label

func _ready():
	global.connect("logic_update", self, "logic_update")

func logic_update():
	text = "Current Floor: %d" % max(global.current_floor_number - 3, 0)


