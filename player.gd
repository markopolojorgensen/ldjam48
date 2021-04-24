class_name Player
extends RigidBody2D

func _ready():
	global.player = self
	global.camera = $camera_2d

func _integrate_forces(state):
	$movement.do_movement(state)
	
	# natural slowdown
	if $intended_direction.get_intended_direction().length() < 0.1:
		$slowdown.text = "slowing down"
		var impulse = state.linear_velocity * -1 * 10
		state.apply_central_impulse(impulse * state.step)
	else:
		$slowdown.text = ""

func get_swing():
	return $swing

func get_faction():
	return global.FACTIONS.PLAYER

func hit_by_horns():
	$canvas_layer/margin_container/health_bar.modify_health(-5)
	if $canvas_layer/margin_container/health_bar.current_health <= 0:
		queue_free()
		global.player_lost = true
		global.do_logic_update()
