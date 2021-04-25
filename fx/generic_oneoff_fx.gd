class_name GenericFX
extends Node2D

func _ready():
	$animated_sprite.play()

func _on_lifetime_timeout():
	queue_free()

