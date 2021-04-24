extends Node2D

export(NodePath) var body_path
onready var body : RigidBody2D = get_node(body_path)

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
		$cooldown.start()
		from_position = global_position
		to_position = target.global_position
		hop_time = 0
		
		# disable collision

func _integrate_forces(state : Physics2DDirectBodyState):
	if is_hopping:
		hop_time += state.step
		var frame_dest = from_position.linear_interpolate(to_position, get_hop_weight())
		# state.linear_velocity = frame_dest - global_position
		body.global_position = frame_dest
		print((to_position - global_position).length())
		
		if hop_time >= total_hop_time:
			is_hopping = false
	else:
		state.linear_velocity = Vector2()

func get_hop_weight():
	return clamp(hop_time / total_hop_time, 0, 1)

func _on_aggro_aggro(entity):
	target = entity

func _on_aggro_aggro_lost(_entity):
	target = null
