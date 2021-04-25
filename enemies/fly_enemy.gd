extends Enemy

func _ready():
	$animated_sprite.play()
	$animated_sprite.frame = randi() % 4
	$slow_walker_behavior.active = false
	$off.wait_time = rand_range(0, 2)
	$off.start()


func _integrate_forces(state):
	$slow_walker_behavior.integrate_forces(state)

func _on_enemy_body_entered(body):
	._on_enemy_body_entered(body)
	if body.has_method("hit_by_fly"):
		body.hit_by_fly(self)
	else:
		pass
		# print("fly hit something that doesn't react: %s" % body.name)

func _on_off_timeout():
	$slow_walker_behavior.active = true
	$on.wait_time = rand_range(0.8, 1.2)
	$on.start()

func _on_on_timeout():
	$slow_walker_behavior.active = false
	$off.wait_time = rand_range(0.8, 1.2)
	$off.start()
