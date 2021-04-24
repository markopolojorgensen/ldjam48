extends Node2D

var active = false

func _ready():
	fancy_hide()

func fancy_show():
	active = true
	modulate = Color.white

func fancy_hide():
	active = false
	modulate = Color.black

func _on_area_2d_body_entered(body):
	if active and body == global.player:
		global.is_floor_finished = true
		global.do_logic_update()
