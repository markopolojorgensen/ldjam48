class_name IntendedDirection
extends Node2D

# TO USE
# configure InputMap actions appropriately and go to town

var last_intended_direction := Vector2()


# always returns a normalized vector
# but remember that (0,0) normalizes to (0,0)
func get_intended_direction() -> Vector2:
	var direction = Vector2()
	
	if Input.is_action_pressed("ui_right"):
		direction.x = 1
	elif Input.is_action_pressed("ui_left"):
		direction.x = -1
	
	if Input.is_action_pressed("ui_up"):
		direction.y = -1
	elif Input.is_action_pressed("ui_down"):
		direction.y = 1
	
	if direction.length() > 0.01:
		last_intended_direction = direction.normalized()
	
	return direction.normalized()

func get_last_intended_direction():
	return last_intended_direction

# since horizontal and vertical both range from 0 to 1, there's
# some weirdness related to the clamping. I don't remember exactly what, sorry.
func get_joystick_intended_direction():
	var horizontal = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var vertical = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	var intended_direction = Vector2(horizontal, vertical).clamped(1)
	return intended_direction



