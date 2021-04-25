class_name Player
extends RigidBody2D

var dead = false

export(PackedScene) var perish_fx_scene

func _ready():
	global.player = self
	global.camera = $camera_2d

func _process(_delta):
	if global.player_lost:
		return
	
	if $ouch_duration.is_stopped():
		if $intended_direction.get_intended_direction().length() > 0.02:
			$sprite.play("walk")
		else:
			$sprite.play("idle")

func _integrate_forces(state):
	if global.player_lost:
		state.linear_velocity = Vector2()
		return
	
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
	$canvas_layer/margin_container/health_bar.modify_health(-10)
	if $canvas_layer/margin_container/health_bar.current_health <= 0:
		call_deferred("perish")
	
	$sprite.play("ouch")
	$ouch_duration.start()

func hit_by_hoplite_slam(_slam):
	$canvas_layer/margin_container/health_bar.modify_health(-2)
	if $canvas_layer/margin_container/health_bar.current_health <= 0:
		call_deferred("perish")
	$sprite.play("ouch")
	$ouch_duration.start()

func perish():
	if global.player_lost:
		return
	
	hide()
	global.player_lost = true
	global.do_logic_update()
	
	if perish_fx_scene:
		var inst = perish_fx_scene.instance()
		get_parent().add_child(inst)
		inst.global_position = global_position

func triggers_aggro():
	return true
