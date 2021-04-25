extends Node2D

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		global.title_screen = true
		global.do_logic_update()



