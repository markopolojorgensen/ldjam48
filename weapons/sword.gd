class_name Sword
extends Node2D

var swing
# friendly faction
var faction = global.FACTIONS.NOFACTION

func _physics_process(_delta):
	global_position = swing.global_position
	$offset.rotation = swing.position.angle()

func _on_area_2d_body_entered(body):
	if body.has_method("get_faction"):
		if body.get_faction() != faction:
			if body.has_method("hit_by_sword"):
				body.hit_by_sword()
			else:
				print("sword hit a body that doesn't react: %s" % body.name)
	else:
		print("sword hit a body with no faction: %s" % body.name)
	

