extends Node

func _unhandled_input(event):
	if event.is_action_pressed("instaquit"):
		get_tree().quit()
	
	if event.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = not OS.window_fullscreen


