extends Enemy

var stabby_scene = preload("res://weapons/stabby.tscn")
var is_stabbing = false

func _integrate_forces(state):
	$slow_walker_behavior.integrate_forces(state)

func _process(_delta):
	if linear_velocity.x < 0:
		$animated_sprite.flip_h = true
		$animated_sprite.offset.x = 18
		$sprite.flip_h = true
		$sprite.offset.x = 18
	else:
		$animated_sprite.flip_h = false
		$animated_sprite.offset.x = -18
		$sprite.flip_h = false
		$sprite.offset.x = -18
	
	if not $ouch_duration.is_stopped():
		$animated_sprite.play("ouch")
		$sprite.hide()
	else:
		$animated_sprite.play("idle")
		$sprite.show()
	
	
	if global.player and global.player.global_position.distance_to(global_position) < 50 and not is_stabbing and $stab_cooldown.is_stopped():
		$slow_walker_behavior.active = false
		is_stabbing = true
		call_deferred("stab")

func stab():
	var stab = stabby_scene.instance()
	add_child(stab)
	stab.rotation = global.player.global_position.angle_to_point(global_position)
	$stab_cooldown.start()
	$stab_done.start()

func _on_stab_cooldown_timeout():
	is_stabbing = false

func _on_stab_done_timeout():
	$slow_walker_behavior.active = true

