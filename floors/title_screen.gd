extends Node2D

func ready():
	global.title_screen = true

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		global.title_screen = true
		global.do_logic_update()



