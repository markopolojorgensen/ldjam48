extends Node2D

func _ready():
	$animation_player.play("stab")

func _process(_delta):
	$moving_part/area_2d.position = $moving_part/area_2d.position

func _on_area_2d_body_entered(body):
	if body.has_method("stabbed"):
		body.stabbed(self)
	else:
		print("stabby failed to stab %s" % body.name)

func do_overlaps():
	for body in $moving_part/area_2d.get_overlapping_bodies():
		_on_area_2d_body_entered(body)

func _on_lifetime_timeout():
	queue_free()



