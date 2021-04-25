extends RigidBody2D

var direction : Vector2
const speed = 120

func _ready():
	$animated_sprite.play()
	$animated_sprite.rotation = direction.angle()

func _physics_process(_delta):
	linear_velocity = direction * speed

func _on_fireball_body_entered(body):
	if body.has_method("hit_by_fireball"):
		body.hit_by_fireball(self)
	queue_free()
