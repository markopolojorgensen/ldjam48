extends Node

var latch = false

func _ready():
	global.music_manager = self
	global.connect("logic_update", self, "logic_update")

func logic_update():
	if global.player_lost:
		latch = false

func play_music_one():
	play_stream($one)

func play_stream(stream:AudioStreamPlayer):
	for child in get_children():
		if child is AudioStreamPlayer and child != stream:
			child.stop()
	if not stream.playing:
		stream.play()
	
	stream.volume_db = 0

func play_music_one_b():
	play_stream($one_b)

func play_music_two():
	play_stream($two_a)

func fade_back_half():
	if not $two_a.playing:
		$one.stop()
		$two_b.stop()
		fade($one_b, $two_a, false)

func fade_music_two():
	if not latch:
		latch = true
		fade($two_a, $two_b, true)

func fade(from:AudioStreamPlayer, to:AudioStreamPlayer, match_position):
	if match_position:
		to.play(from.get_playback_position())
	else:
		to.play()
	$tween.interpolate_property(from, "volume_db", -6, -80, 2.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$tween.interpolate_property(to, "volume_db", -6, 0, 0.3, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$tween.start()


func _on_logo_delay_timeout():
	play_music_one()
