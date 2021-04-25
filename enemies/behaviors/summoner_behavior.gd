extends Node2D

export(PackedScene) var enemy_scene

var num_summons = 0

func _ready():
	hide()
	$cooldown.start()
	
	$animated_sprite.modulate = Color(1,1,1,0)
	$audio_stream_player_2d.volume_db = -80

func _on_cooldown_timeout():
	show()
	$tween.interpolate_property($animated_sprite, "modulate", Color(1,1,1,0), Color.white, 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$tween.interpolate_property($audio_stream_player_2d, "volume_db", -80, 0, 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$tween.start()
	$animated_sprite.play()
	$audio_stream_player_2d.play()
	$duration.start()
	num_summons = 3 + (randi() % 3)

func _on_duration_timeout():
	call_deferred("do_summon")
	num_summons -= 1
	if num_summons <= 0:
		hide()
		$animated_sprite.modulate = Color(1,1,1,0)
		$cooldown.start()
		$duration.stop()
		$audio_stream_player_2d.stop()

func do_summon():
	var inst = enemy_scene.instance()
	get_parent().get_parent().add_child(inst)
	# inst.global_position = global_position + Vector2(20, 0).rotated(rand_range(-PI, PI))
	inst.global_position = $animated_sprite.global_position



