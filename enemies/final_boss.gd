extends Enemy

func _ready():
	._ready()
	$horns_behavior.faction = global.FACTIONS.ENEMIES

func _process(_delta):
	$animated_sprite.rotation = 0
	if $melee_charge_movement.is_charging:
		$animated_sprite.rotation = linear_velocity.angle() + (PI/2)
		$animated_sprite.play("charge")
	elif not $ouch_duration.is_stopped():
		$animated_sprite.play("ouch")
	elif linear_velocity.length() > 0.1:
		$animated_sprite.play("walk")
		if linear_velocity.x < 0:
			$animated_sprite.flip_h = true
		else: 
			$animated_sprite.flip_h = false
	else:
		$animated_sprite.play("idle")

func hit_by_sword():
	.hit_by_sword()
	if not is_alive():
		global.final_boss_defeated = true
		global.do_logic_update()
	
	$animated_sprite.play("ouch")
	$ouch_duration.start()

func perish():
	.perish()
	
	$summoner_behavior.num_summons = 0
	get_tree().call_group("enemies", "perish")

