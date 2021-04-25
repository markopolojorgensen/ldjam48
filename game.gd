extends Node2D

var current_floor

var is_restarting = false

export(bool) var skip_to_first_level = false

func _ready():
	global.connect("logic_update", self, "logic_update")
	if skip_to_first_level:
		global.current_floor_number = 4
	load_floor()

func load_floor():
	if current_floor:
		current_floor.queue_free()
	
	var floor_instance = get_floor_scene(global.current_floor_number).instance()
	current_floor = floor_instance
	add_child(floor_instance)
	global.do_logic_update()

func logic_update():
	if global.is_floor_finished:
		global.is_floor_finished = false
		if global.current_floor_number == 1 and global.tutorial_skip:
			global.current_floor_number = 4
		else:
			global.current_floor_number += 1
		call_deferred("load_floor")
	
	if global.player_lost and not is_restarting:
		is_restarting = true
		$moment_of_silence.start()
	
	if global.title_screen and not is_restarting:
		is_restarting = true
		_on_moment_of_silence_timeout()

func get_floor_scene(floor_number):
	match floor_number:
		0:
			return preload("res://floors/title_screen.tscn")
		1:
			return preload("res://floors/tutorial_floor.tscn")
		2:
			return preload("res://floors/tutorial_floor_enemies.tscn")
		3:
			return preload("res://floors/tutorial_floor_shortcuts.tscn")
		4:
			return preload("res://floors/dummy_floor.tscn")
		5:
			return preload("res://floors/big_plus_floor.tscn")
		6:
			return preload("res://floors/crossroads_floor.tscn")
		7:
			return preload("res://floors/final_boss_floor.tscn")
		8:
			return preload("res://floors/treasure_floor.tscn")


func _on_moment_of_silence_timeout():
	$hud/wipe_animation.play()
	$hud/wipe_animation/middle.start()

func _on_middle_timeout():
	if global.title_screen:
		global.current_floor_number = 1
	else:
		global.current_floor_number = 0
	load_floor()
	global.player_lost = false
	global.title_screen = false
