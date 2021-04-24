extends Node2D

var active = false
export(bool) var tutorial_skip = false

func _ready():
	global.connect("logic_update", self, "logic_update")
	fancy_hide()

func fancy_show():
	active = true
	$closed_sprite.hide()
	$open_sprite.show()

func fancy_hide():
	$closed_sprite.show()
	$open_sprite.hide()
	active = false

func logic_update():
	if global.current_level.is_clear():
		fancy_show()
	else:
		fancy_hide()

func _on_area_2d_body_entered(body):
	if active and body == global.player:
		if tutorial_skip:
			global.tutorial_skip = true
		global.is_floor_finished = true
		global.do_logic_update()
