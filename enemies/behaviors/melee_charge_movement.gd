extends Node2D

var is_charging = false
var charge_direction := Vector2()
const charge_speed = 400

var walk_direction := Vector2()

export(NodePath) var body_path
onready var body : RigidBody2D = get_node(body_path)

export(int) var charge_acceleration = 2000
export(int) var walk_speed = 100

func _ready():
	body.connect("body_entered", self, "collision")
	_on_duration_timeout()

func _process(_delta):
	$charge_state.text = str(is_charging)

func _physics_process(delta):
	if body.is_tied_up:
		return
	
	if is_charging and body.linear_velocity.length() < charge_speed:
		var impulse = charge_direction.normalized() * charge_acceleration
		body.apply_central_impulse(impulse * delta)
	
	if not is_charging:
		body.linear_velocity = walk_direction.normalized() * walk_speed

func collision(other_body):
	if is_charging and "wall" in other_body.name or "obstacle" in other_body.name:
		call_deferred("_on_duration_timeout")
	elif not is_charging and "wall" in other_body.name:
		walk_direction = walk_direction * -1

func _on_interval_timeout():
	if not is_charging:
		is_charging = true
		charge_direction = body.global_position.direction_to(global.player.global_position)
		$duration.start()

func _on_duration_timeout():
	$duration.stop()
	is_charging = false
	walk_direction = Vector2(1, 0).rotated(rand_range(-PI, PI))
	$interval.start()


