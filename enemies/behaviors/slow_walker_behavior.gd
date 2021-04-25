extends Node2D

# TODO: send to top down movement node???
export(NodePath) var body_path
onready var body : RigidBody2D = get_node(body_path)

var target

var active = true

func integrate_forces(state: Physics2DDirectBodyState):
	if active:
		$top_down_movement.do_movement(state)
	
	if get_intended_direction().length() < 0.1:
		# natural slowdown
		state.apply_central_impulse(state.linear_velocity * -1 * state.step * 15)

func get_intended_direction():
	if active and target:
		return global_position.direction_to(target.global_position)
	else:
		return Vector2()

func _on_aggro_aggro(entity):
	target = entity

func _on_aggro_aggro_lost(_entity):
	target = null
