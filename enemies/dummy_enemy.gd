extends Enemy

func _physics_process(_delta):
	if is_tied_up:
		linear_velocity = Vector2()
