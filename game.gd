extends Node2D

var floors = [
	preload("res://floors/tutorial_floor.tscn"),
	preload("res://floors/dummy_floor.tscn"),
	preload("res://floors/final_boss_floor.tscn"),
]

var current_floor

func _ready():
	global.connect("logic_update", self, "logic_update")
	load_floor(global.current_floor_number)

func load_floor(floor_index):
	var floor_instance = floors[floor_index].instance()
	current_floor = floor_instance
	add_child(floor_instance)
	global.do_logic_update()

func logic_update():
	if global.is_floor_finished:
		global.is_floor_finished = false
		global.current_floor_number += 1
		if current_floor:
			current_floor.queue_free()
		call_deferred("load_floor", get_floor_scene_index(global.current_floor_number))

func get_floor_scene_index(floor_number):
	if floor_number < 10:
		return 1
	elif floor_number < 11:
		return 2
	else:
		return 3



