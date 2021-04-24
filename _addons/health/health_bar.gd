extends HBoxContainer

export(float) var max_health = 10 setget set_max_health
export(float) var current_health = 10 setget set_health

func _ready():
	set_max_health(max_health)
	set_health(current_health)

func set_max_health(new_max):
	max_health = new_max
	$texture_progress.max_value = max_health
	$texture_progress.step = max_health / 100.0

func set_health(new_health):
	current_health = new_health
	$texture_progress.value = current_health

# adds to current health
func modify_health(modification):
	set_health(current_health + modification)

