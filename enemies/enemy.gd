class_name Enemy
extends RigidBody2D

var is_tied_up = false
export(bool) var flip_perish = false

export(PackedScene) var perish_fx_scene

func _ready():
	$health_bar.hide()
	$tied_up_sprite.hide()

func _on_enemy_body_entered(body):
	if global.get_item_flag("clew_of_theseus") and body == global.player and not is_tied_up:
		print("eep, tied up")
		is_tied_up = true
		$tied_up_timer.start()
		$tied_up_sprite.show()

func get_faction():
	return global.FACTIONS.ENEMIES

func is_alive():
	return $health_bar.current_health > 0

func hit_by_sword():
	$ouch_duration.start()
	$health_bar.show()
	$health_bar.modify_health(-5)
	if $health_bar.current_health <= 0:
		call_deferred("perish")


func perish():
	if perish_fx_scene:
		var inst = perish_fx_scene.instance()
		get_parent().add_child(inst)
		inst.global_position = global_position
		if flip_perish and linear_velocity.x < 0:
			(inst as Node2D).scale.x = -1
	
	queue_free()
	global.call_deferred("do_logic_update")

func _on_tied_up_timer_timeout():
	is_tied_up = false
	$tied_up_sprite.hide()
