extends Label

func _ready():
	global.connect("logic_update", self, "logic_update")

func logic_update():
	text = "Current Floor: %d" % global.current_floor_number 


