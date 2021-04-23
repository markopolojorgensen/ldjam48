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
	
	if event.is_action_pressed("screenshot"):
		screenshot()

func update_audio():
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), muted)

func screenshot():
	# get screen capture
	var capture = get_viewport().get_texture().get_data()
	capture.flip_y()
	
	# get unused screenshot number
	var file_checker = File.new()
	var i = 0
	var file_name = "user://screenshot_%03d.png" % i
	# only supports 1000 screenshots?
	while file_checker.file_exists(file_name):
		i += 1
		file_name = "user://screenshot_%03d.png" % i
	
	# save to a file
	capture.save_png(file_name)
	
	print("screenshot saved in %s  (%s)" % [str(OS.get_user_data_dir()), file_name])

