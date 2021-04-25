extends Node

onready var next_stream = $audio_stream_player

func _on_intro_delay_timeout():
	if randf() < 0.5:
		next_stream = $audio_stream_player
	else:
		next_stream = $audio_stream_player2
	
	next_stream.play()

func _on_audio_stream_player_finished():
	next_stream = $audio_stream_player2
	$interval.start()

func _on_audio_stream_player2_finished():
	next_stream = $audio_stream_player
	$interval.start()

func _on_interval_timeout():
	next_stream.play()
