extends Node2D

var current_floor

var is_restarting = false

export(int) var level_to_start_on = 0

var random_floors = [
	preload("res://floors/LD48_floor.tscn"),
	preload("res://floors/big_plus_floor.tscn"),
	preload("res://floors/crossroads_floor.tscn"),
	preload("res://floors/diagonal_floor.tscn"),
	preload("res://floors/flies_floor.tscn"),
	preload("res://floors/frogger_floor.tscn"),
	preload("res://floors/labyrinth_floor.tscn"),
	preload("res://floors/one_normal_frog_floor.tscn"),
	preload("res://floors/reverse_laby_floor.tscn"),
	preload("res://floors/ring_around_the_rosie_floor.tscn"),
	preload("res://floors/sneaky_gallery_floor.tscn"),
	preload("res://floors/dummy_floor.tscn"),
]

func _ready():
	randomize()
	global.connect("logic_update", self, "logic_update")
	global.current_floor_number = level_to_start_on
	load_floor()

func load_floor():
	if current_floor:
		current_floor.queue_free()
	
	var floor_instance = get_floor_scene(global.current_floor_number).instance()
	current_floor = floor_instance
	add_child(floor_instance)
	global.do_logic_update()
	
	if global.player and global.health:
		global.player.set_health(global.health)

func logic_update():
	if global.is_floor_finished:
		global.health = global.player.get_health()
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
			$music_manager.play_music_one()
			global.is_dummy_floor_available = true
			return preload("res://floors/title_screen.tscn")
		1:
			return preload("res://floors/tutorial_floor.tscn")
		2:
			return preload("res://floors/tutorial_floor_enemies.tscn")
		3:
			return preload("res://floors/tutorial_floor_shortcuts.tscn")
		4,5,6,7:
			global.front_half = true
			
			var roll = randi() % random_floors.size()
			while not global.is_dummy_floor_available and roll == 11:
				print("reroll to avoid dummies")
				roll = randi() % random_floors.size()
			if roll == 11:
				global.is_dummy_floor_available = false
			
			return random_floors[roll]
		
		8:
			return preload("res://floors/frogotten_floor.tscn")
		
		9,10,11,12:
			global.front_half = false
			$music_manager.fade_back_half()
			
			var roll = randi() % random_floors.size()
			while not global.is_dummy_floor_available and roll == 11:
				print("reroll to avoid dummies")
				roll = randi() % random_floors.size()
			if roll == 11:
				global.is_dummy_floor_available = false
			
			return random_floors[roll]
		13:
			$music_manager.fade_music_two()
			return preload("res://floors/final_boss_floor.tscn")
		14:
			return preload("res://floors/treasure_floor.tscn")


func _on_moment_of_silence_timeout():
	$hud/wipe_animation.frame = 0
	$hud/wipe_animation.play()
	$wipe_sound.play()
	$hud/wipe_animation/middle.start()

func _on_middle_timeout():
	if global.title_screen:
		global.current_floor_number = 1
	else:
		global.current_floor_number = 0
	load_floor()
	global.player_lost = false
	global.title_screen = false
	is_restarting = false
