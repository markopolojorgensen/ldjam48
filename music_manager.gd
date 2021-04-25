extends Node

func _ready():
	global.music_manager = self

func play_music_one():
	play_stream($one)

func play_stream(stream:AudioStreamPlayer):
	for child in get_children():
		if child is AudioStreamPlayer and child != stream:
			child.stop()
	if not stream.playing:
		stream.play()

func play_music_one_b():
	play_stream($one_b)

func play_music_two():
	pass


func _on_logo_delay_timeout():
	play_music_one()
