class_name FloorLevel
extends Node2D

func _ready():
	global.connect("logic_update", self, "logic_update")
	
	global.current_level_ysort = $y_sort
	global.current_level = self
	
	(global.camera as Camera2D).limit_top = $limit_top_left.global_position.y
	(global.camera as Camera2D).limit_left = $limit_top_left.global_position.x
	(global.camera as Camera2D).limit_bottom = $limit_bottom_right.global_position.y
	(global.camera as Camera2D).limit_right = $limit_bottom_right.global_position.x
	
	logic_update()

func get_enemy_count():
	var count = 0
	for child in $y_sort.get_children():
		if (child as Node).is_in_group("enemies") and child.is_alive():
			count += 1
	if $y_sort.has_node("enemy_ysort"):
		for child in $y_sort.get_node("enemy_ysort").get_children():
			if (child as Node).is_in_group("enemies") and child.is_alive():
				count += 1
	return count

func is_clear():
	return get_enemy_count() == 0

func logic_update():
	if is_clear():
		global.show_items = true
		$ladder_down.fancy_show()
	else:
		global.show_items = false
		$ladder_down.fancy_hide()

