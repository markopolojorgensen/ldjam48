extends PanelContainer

export(bool) var skip = false

func _ready():
	if skip:
		hide()
		queue_free()
	else:
		show()
		$center_container/control/animated_sprite.frame = 0
		yield(get_tree().create_timer(1), "timeout")
		$animation_player.play("show_logo")
		$lifetime.start()

func _on_lifetime_timeout():
	queue_free()
