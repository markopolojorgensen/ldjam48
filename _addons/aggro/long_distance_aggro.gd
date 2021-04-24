extends Node2D

# a more performant aggro that doesn't rely on area2D

# FIXME: more generic way to get global aggro target
# FIXME: export raycast collision layers

# also see http://kidscancode.org/blog/2018/03/godot3_visibility_raycasts/

# to use:
#   you need autoload script called global with a field called player
#   make sure the raycast collision layers are configured properly

# don't forget to set up collision layers appropriately
#   raycast needs to collide with scenery layer and aggroing things layer
#   I think you can have scenery and the aggroing thing on the same layer, but I've not tested it

signal aggro(entity)
signal aggro_lost(entity)

var aggro_active = false

# 300 is about barely offscreen diagonally
export(float) var max_range = 350

# interval between updates, for performance
export(float) var min_interval = 0.3
export(float) var max_interval = 1

func _ready():
	# start interval loop
	_on_update_interval_timeout()

func update_target():
	if global.player:
		var target_in_sight = can_see(global.player)
		if not aggro_active and target_in_sight:
			emit_signal("aggro", global.player)
			aggro_active = true
		elif aggro_active and not target_in_sight:
			emit_signal("aggro_lost", global.player)
			aggro_active = false

func can_see(thing):
	global_rotation = 0
	var aggro_point = thing.global_position
	if thing.has_node("aggro_point"):
		aggro_point = thing.get_node("aggro_point").global_position
	
	$ray_cast_2d.cast_to = (aggro_point - global_position).clamped(max_range)
	$ray_cast_2d.force_raycast_update()
	
	return $ray_cast_2d.is_colliding() and $ray_cast_2d.get_collider() == thing

func _on_update_interval_timeout():
	update_target()
	$update_interval.wait_time = rand_range(min_interval, max_interval)
	$update_interval.start()

# boolean for if there's a target we can see
func is_active():
	return aggro_active



