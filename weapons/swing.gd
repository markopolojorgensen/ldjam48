extends Node2D

export(int) var swing_radius = 10

var is_swinging = false
var from_angle
var to_angle
var swing_time = 0
export(float) var total_swing_time = 0.2

export(NodePath) var direction_path
onready var intended_direction : IntendedDirection = get_node(direction_path)

var sword_scene = preload("res://weapons/sword.tscn")
var sword

func _process(delta):
	if is_swinging:
		swing_time += delta
		
		var swing_weight = swing_time / total_swing_time
		
		position = Vector2(swing_radius, 0).rotated(lerp(from_angle, to_angle, swing_weight))
		
		if swing_time > total_swing_time:
			# stop swinging
			hide()
			is_swinging = false
			sword.queue_free()

func _unhandled_input(event):
	if event.is_action_pressed("swing") and not is_swinging and not global.player_lost:
		show()
		is_swinging = true
		var swing_direction = (intended_direction as IntendedDirection).get_last_intended_direction()
		from_angle = swing_direction.angle() + (PI/2.0)
		to_angle = swing_direction.angle() - (PI/2.0)
		swing_time = 0
		
		sword = sword_scene.instance()
		sword.swing = self
		sword.faction = global.FACTIONS.PLAYER
		global.current_level_ysort.add_child(sword)
		_process(0)
		



