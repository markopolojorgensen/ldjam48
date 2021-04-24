extends VBoxContainer


func _ready():
	global.connect("logic_update", self, "logic_update")

func logic_update():
	for child in get_children():
		child.queue_free()
	
	for item_name in global.item_flags:
		var l = Label.new()
		l.text = item_name
		add_child(l)


