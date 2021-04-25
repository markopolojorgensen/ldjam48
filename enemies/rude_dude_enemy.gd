extends Enemy

var fireball_scene = preload("res://weapons/fireball.tscn")

func _ready():
	$collision_shape_2d.disabled = true
	$extra_hide.wait_time = rand_range(0, 5)
	$extra_hide.start()

func _process(_delta):
	if global_position.direction_to(global.player.global_position).x < 0:
		$animated_sprite.flip_h = true
	else:
		$animated_sprite.flip_h = false
	
	if not $ouch_duration.is_stopped():
		$animated_sprite.play("ouch")
	elif not $hide_duration.is_stopped():
		$animated_sprite.play("hide")
	elif not $prep_duration.is_stopped():
		$animated_sprite.play("prep")
	elif not $shoot_duration.is_stopped():
		$animated_sprite.play("fire")

func _on_hide_duration_timeout():
	$collision_shape_2d.disabled = false
	$prep_duration.start()

func _on_prep_timeout():
	$shoot_duration.start()
	var fireball = fireball_scene.instance()
	fireball.direction = global_position.direction_to(global.player.global_position)
	get_parent().add_child(fireball)
	fireball.global_position = $fireball_spawn.global_position
	if $animated_sprite.flip_h:
		fireball.global_position.x -= 2 * $fireball_spawn.position.x

func _on_shoot_duration_timeout():
	$hide_duration.start()
	$collision_shape_2d.disabled = true

func _on_extra_hide_timeout():
	$hide_duration.start()
