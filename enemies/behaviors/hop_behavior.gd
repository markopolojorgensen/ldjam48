extends Node2D

export(NodePath) var body_path
onready var body : RigidBody2D = get_node(body_path)

export(NodePath) var shape_path
onready var shape : CollisionShape2D = get_node(shape_path)

const slam_scene = preload("res://fx/hoplite_slam.tscn")

var target
var from_position : Vector2
var to_position : Vector2
var is_hopping = false
var hop_time = 0
const total_hop_time = 0.5

var max_height = 50
func _process(_delta):
	if target and $cooldown.is_stopped() and not is_hopping:
		is_hopping = true
		$cooldown.wait_time = rand_range(2.5, 3.5)
		$cooldown.start()
		from_position = global_position
		to_position = target.global_position
		hop_time = 0
		
		# disable collision
		(shape as CollisionShape2D).set_deferred("disabled", true)

func _integrate_forces(state : Physics2DDirectBodyState):
	if is_hopping:
		hop_time += state.step
		
		if get_hop_weight() < 0.7 and target:
			to_position = target.global_position
		
		var frame_dest = from_position.linear_interpolate(to_position, get_hop_weight())
		state.linear_velocity = (frame_dest - global_position) / state.step
		
		if hop_time >= total_hop_time:
			is_hopping = false
			$suspend_duration.start()
	else:
		# natural slowdown
		state.apply_central_impulse(state.linear_velocity * -1 * state.step * 30)

func create_slam():
	var slam = slam_scene.instance()
	get_parent().add_child(slam)
	slam.global_position = global_position

func get_hop_weight():
	return clamp(hop_time / total_hop_time, 0, 1)

func is_suspended():
	return not $suspend_duration.is_stopped()

func _on_aggro_aggro(entity):
	target = entity

func _on_aggro_aggro_lost(_entity):
	target = null

func _on_suspend_duration_timeout():
	(shape as CollisionShape2D).set_deferred("disabled", false)
	call_deferred("create_slam")

