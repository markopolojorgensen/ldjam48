extends Node2D

var faction = global.FACTIONS.NOFACTION

export(NodePath) var charge_path
onready var charge = get_node(charge_path)

export(NodePath) var body_path
onready var body : RigidBody2D = get_node(body_path)

func _ready():
	body.connect("body_entered", self, "collision")

func collision(other_body):
	if not charge.is_charging:
		return
	
	print(other_body.name)
	
	if other_body.has_method("get_faction"):
		if other_body.get_faction() != faction:
			if other_body.has_method("hit_by_horns"):
				other_body.hit_by_horns()
			else:
				print("horns hit a body that doesn't react: %s" % other_body.name)
		else:
			print("same faction????")
	else:
		print("horns hit a body with no faction: %s" % other_body.name)


