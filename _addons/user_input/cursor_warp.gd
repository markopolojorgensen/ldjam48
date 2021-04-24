extends Node2D

# control mouse cursor using controller

# TO USE:
# add 'joystick_right' and others to your input map, or change their names, w/e
# Set cursor speed to whatever works for you
# use 'active' to enable/disable


# TODO: clamp mouse values to window!

export(bool) var active = true
# Since this value is multiplied by delta, it's smoother as a multiple of 60
const cursor_speed = 120

var previous_position := Vector2()
# This keeps track of decimal values, since the viewport's mouse position does not.
# It prevents framerate issues where if your framerate is too high the mouse never travels
# far enough in a single frame to make it to the next pixel, so it appears to be locked in place.
var float_position := Vector2()

func _ready():
	previous_position = get_viewport().get_mouse_position()
	float_position = get_viewport().get_mouse_position()

func _process(delta):
	if active:
		var id : Vector2 = get_intended_direction()
		if id.length() > 0.01:
			var movement = id.normalized() * cursor_speed * delta
			float_position += movement
			get_viewport().warp_mouse(float_position)
	
	previous_position = get_viewport().get_mouse_position()

func get_intended_direction():
	var horizontal = Input.get_action_strength("joystick_right") - Input.get_action_strength("joystick_left")
	var vertical = Input.get_action_strength("joystick_down") - Input.get_action_strength("joystick_up")
	var intended_direction = Vector2(horizontal, vertical).clamped(1)
	return intended_direction

