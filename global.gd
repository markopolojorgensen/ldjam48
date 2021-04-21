extends Node

func _unhandled_input(event):
	if event.is_action_pressed("instaquit"):
		get_tree().quit()

