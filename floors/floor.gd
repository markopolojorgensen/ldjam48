class_name FloorLevel
extends Node2D

var front_scenes = {
	0.1 : {
		"name" : "dummy",
		"scene" : preload("res://enemies/dummy_enemy.tscn"),
		},
	0.55 : {
		"name" : "fly",
		"scene" : preload("res://enemies/fly_enemy.tscn"),
		},
	1.0 : {
		"name" : "hoplite",
		"scene" : preload("res://enemies/hoplite_enemy.tscn"),
		},
}

var back_scenes = {
	0.33 : {
		"name" : "fly",
		"scene" : preload("res://enemies/fly_enemy.tscn"),
		},
	0.66 : {
		"name" : "hoplite",
		"scene" : preload("res://enemies/hoplite_enemy.tscn"),
		},
	1.0 : {
		"name" : "rude_dude",
		"scene" : preload("res://enemies/rude_dude_enemy.tscn"),
		},
}


export(String) var title_card_text = ""

func _ready():
	global.connect("logic_update", self, "logic_update")
	
	global.current_level_ysort = $y_sort
	global.current_level = self
	
	(global.camera as Camera2D).limit_top = $limit_top_left.global_position.y
	(global.camera as Camera2D).limit_left = $limit_top_left.global_position.x
	(global.camera as Camera2D).limit_bottom = $limit_bottom_right.global_position.y
	(global.camera as Camera2D).limit_right = $limit_bottom_right.global_position.x
	
	
	if $spawn_points.get_child_count() > 0:
		spawn_enemies()
	
	logic_update()
	
	if title_card_text != "":
		$title_card_layer/margin_container/panel_container/margin_container/title_card.text = title_card_text
		$tween.interpolate_property($title_card_layer/margin_container, "modulate", Color(1,1,1,0), Color.white, 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		$tween.interpolate_property($title_card_layer/margin_container, "modulate", Color(1,1,1,1), Color(1,1,1,0), 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 3.0)
		$tween.start()

func spawn_enemies():
	var spawn_count = 4
	if global.front_half:
		pass
	else:
		spawn_count = $spawn_points.get_child_count()
	
	for i in range(spawn_count):
		# pick a random enemy type to spawn here
		var roll_result = get_roll_result()
		while global.front_half and roll_result["name"] == "rude_dude":
			# print("rerolling rude dude")
			roll_result = get_roll_result()
		
		print("picked a scene: %s" % str(roll_result["name"]))
		
		var spawn_position = $spawn_points.get_child(i).global_position
		match roll_result["name"]:
			"dummy":
				spawn_thing(roll_result["scene"], spawn_position)
			"fly":
				spawn_thing(roll_result["scene"], spawn_position + Vector2(10, 10))
				spawn_thing(roll_result["scene"], spawn_position)
				spawn_thing(roll_result["scene"], spawn_position + Vector2(-10, -3))
				if randf() < 0.5:
					spawn_thing(roll_result["scene"], spawn_position + Vector2(8, -3))
				if randf() < 0.5:
					spawn_thing(roll_result["scene"], spawn_position + Vector2(-7, 4))
			"hoplite":
				spawn_thing(roll_result["scene"], spawn_position + Vector2(-10, 0))
				spawn_thing(roll_result["scene"], spawn_position + Vector2(10, 0))
				if randf() < 0.5:
					spawn_thing(roll_result["scene"], spawn_position + Vector2(0, 10))
			"rude_dude":
				spawn_thing(roll_result["scene"], spawn_position)


func spawn_thing(scene, spawn_position):
	var inst = scene.instance()
	$y_sort.add_child(inst)
	inst.global_position = spawn_position

func get_roll_result():
	var enemy_scenes
	if global.front_half:
		enemy_scenes = front_scenes
	else:
		enemy_scenes = back_scenes
	var roll = randf()
	for key in enemy_scenes.keys():
		if roll < key:
			return enemy_scenes[key]

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

