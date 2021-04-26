class_name Player
extends RigidBody2D

var dead = false

export(PackedScene) var perish_fx_scene

var og_margin_pos

func _ready():
	global.player = self
	global.camera = $camera_2d
	
	og_margin_pos = $canvas_layer/margin_container.rect_global_position

func _process(_delta):
	if global.player_lost:
		return
	
	if $ouch_duration.is_stopped():
		if $intended_direction.get_intended_direction().length() > 0.02:
			$sprite.play("walk")
		else:
			$sprite.play("idle")
	
	if $canvas_layer/margin_container/health_bar.current_health <= 6:
		$canvas_layer/margin_container.rect_global_position = og_margin_pos + Vector2((randi() % 5) - 2, (randi() % 5) - 2)
	# elif $canvas_layer/margin_container/health_bar.current_health < 9:
	# 	$canvas_layer/margin_container.rect_global_position = og_margin_pos + Vector2((randi() % 3) - 1, (randi() % 3) - 1)

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
	if $invuln_cooldown.is_stopped():
		$canvas_layer/margin_container/health_bar.modify_health(-5)
		ouch()

func hit_by_hoplite_slam(_slam):
	if $invuln_cooldown.is_stopped():
		$canvas_layer/margin_container/health_bar.modify_health(-2)
		ouch()

func hit_by_fly(_fly):
	if $invuln_cooldown.is_stopped():
		$canvas_layer/margin_container/health_bar.modify_health(-1)
		ouch()

func stabbed(_stabby):
	if $invuln_cooldown.is_stopped():
		$canvas_layer/margin_container/health_bar.modify_health(-4)
		ouch()

func hit_by_fireball(_fireball):
	if $invuln_cooldown.is_stopped():
		$canvas_layer/margin_container/health_bar.modify_health(-3)
		ouch()

func ouch():
	if global.player_lost:
		return
	
	$ouch_sound.stop()
	$ouch_sound.play()
	if $canvas_layer/margin_container/health_bar.current_health <= 0:
		call_deferred("perish")
	$invuln_cooldown.start()
	$sprite.play("ouch")
	$ouch_duration.start()
	$ouch_time.interpolate_property(Engine, "time_scale", 0.1, 1, 1, Tween.TRANS_QUART, Tween.EASE_OUT)
	$ouch_time.start()

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

func _on_sprite_frame_changed():
	if $sprite.animation == "walk":
		$footstep.pitch_scale = rand_range(0.9, 1.1)
		$footstep.play()

func get_health():
	return $canvas_layer/margin_container/health_bar.current_health

func set_health(health):
	$canvas_layer/margin_container/health_bar.current_health = health



