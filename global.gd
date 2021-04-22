extends Node

var muted = false

func _unhandled_input(event):
	if event.is_action_pressed("instaquit"):
		get_tree().quit()
	
	if event.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = not OS.window_fullscreen
	
	if event.is_action_pressed("toggle_mute"):
		muted = not muted
		update_audio()

func update_audio():
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), muted)

