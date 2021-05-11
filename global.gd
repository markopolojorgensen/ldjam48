extends Node

signal logic_update

enum FACTIONS{
	NOFACTION,
	PLAYER,
	ENEMIES,
}

var front_half = true

var final_boss_defeated = false
var player_lost = false
var is_floor_finished = false
var show_items = false

var is_dummy_floor_available = true

var tutorial_skip = false
var title_screen = false

var player
var health

var camera : Camera2D

var current_floor_number = 0
var current_level
var current_level_ysort : YSort

var item_flags = []

var music_manager

var easy_mode = false

func do_logic_update():
	emit_signal("logic_update")

func set_item_flag(item_name):
	if not item_flags.has(item_name):
		item_flags.append(item_name)

func get_item_flag(item_name):
	return item_flags.has(item_name)

























# BOILERPLATE

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
	
	if event.is_action_pressed("toggle_easy_mode"):
		easy_mode = not easy_mode
		do_logic_update()
	
	if event.is_action_pressed("slowmo"):
		if Engine.time_scale != 1:
			Engine.time_scale = 1
		else:
			Engine.time_scale = 0.3

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

