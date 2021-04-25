extends Node2D

var active = true

func _ready():
	$animated_sprite.play()
	$audio_stream_player_2d.play()

func _on_lifetime_timeout():
	queue_free()

func _on_area_2d_body_entered(body):
	if not active:
		return
	
	if body.has_method("hit_by_hoplite_slam"):
		body.hit_by_hoplite_slam(self)
	else:
		print("hoplite slam hit a body but can't slam: %s" % body.name)

func _on_slam_duration_timeout():
	active = false
