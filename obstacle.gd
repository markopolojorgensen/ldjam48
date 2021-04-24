extends Node2D

var faction = global.FACTIONS.NOFACTION

func get_faction():
	return faction

func hit_by_horns():
	queue_free()

