extends Enemy

var original_y

func _ready():
	original_y = $animated_sprite.position.y

func _integrate_forces(state):
	$hop_behavior._integrate_forces(state)

func _process(_delta):
	if $hop_behavior.is_hopping:
		$animated_sprite.position.y = lerp(original_y, original_y - 100, $hop_behavior.get_hop_weight())
	else:
		$animated_sprite.position.y = original_y

