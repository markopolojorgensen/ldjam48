extends Enemy

func _ready():
	._ready()
	$horns.faction = global.FACTIONS.ENEMIES

func hit_by_sword():
	.hit_by_sword()
	if not is_alive():
		global.final_boss_defeated = true
		global.do_logic_update()

