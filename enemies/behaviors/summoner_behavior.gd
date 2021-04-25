extends Node2D

export(PackedScene) var enemy_scene

var num_summons = 0

func _ready():
	hide()
	$cooldown.start()

func _on_cooldown_timeout():
	show()
	$animated_sprite.play()
	$duration.start()
	num_summons = 3 + (randi() % 3)

func _on_duration_timeout():
	call_deferred("do_summon")
	num_summons -= 1
	if num_summons <= 0:
		hide()
		$cooldown.start()
		$duration.stop()

func do_summon():
	var inst = enemy_scene.instance()
	get_parent().get_parent().add_child(inst)
	# inst.global_position = global_position + Vector2(20, 0).rotated(rand_range(-PI, PI))
	inst.global_position = $animated_sprite.global_position



