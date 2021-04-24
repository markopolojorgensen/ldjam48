extends Enemy

func _physics_process(_delta):
	if is_tied_up:
		linear_velocity = Vector2()

func _process(_delta):
	if $ouch_duration.is_stopped():
		$animated_sprite.play("idle")

func hit_by_sword():
	.hit_by_sword()
	if $animated_sprite.frames and $animated_sprite.frames.has_animation("ouch"):
		$animated_sprite.play("ouch")
		$ouch_duration.start()

