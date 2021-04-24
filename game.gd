extends Node2D

var current_floor

func _ready():
	global.connect("logic_update", self, "logic_update")
	load_floor()

func load_floor():
	var floor_instance = get_floor_scene(global.current_floor_number).instance()
	current_floor = floor_instance
	add_child(floor_instance)
	global.do_logic_update()

func logic_update():
	if global.is_floor_finished:
		global.is_floor_finished = false
		if global.current_floor_number == 0 and global.tutorial_skip:
			global.current_floor_number = 3
		else:
			global.current_floor_number += 1
		if current_floor:
			current_floor.queue_free()
		call_deferred("load_floor")

func get_floor_scene(floor_number):
	match floor_number:
		0:
			return preload("res://floors/tutorial_floor.tscn")
		1:
			return preload("res://floors/tutorial_floor_enemies.tscn")
		2:
			return preload("res://floors/tutorial_floor_shortcuts.tscn")
		3:
			return preload("res://floors/dummy_floor.tscn")
		4:
			return preload("res://floors/final_boss_floor.tscn")
		5:
			return preload("res://floors/treasure_floor.tscn")


