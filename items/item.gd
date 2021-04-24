extends Node2D

export(String) var item_name

var active = false

func _ready():
	global.connect("logic_update", self, "logic_update")

func logic_update():
	if global.show_items:
		show()
		active = true
	else:
		hide()
		active = false

func _on_area_2d_body_entered(body):
	if active and body == global.player:
		global.set_item_flag(item_name)
		global.do_logic_update()
		queue_free()
