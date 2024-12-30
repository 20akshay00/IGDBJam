extends AudioStreamPlayer2D

var valid_placement_sfx := preload("res://assets/audio/sfx/lockcorrect.mp3")
var invalid_placement_sfx := preload("res://assets/audio/sfx/lockwrong.mp3")
var block_move_sfx := preload("res://assets/audio/sfx/cratemove.mp3")

var virus_sfx := preload("res://assets/audio/sfx/virusfillv5.mp3")
var bg_music := preload("res://assets/audio/music/maintheme.wav")

func _play_music(music: AudioStream, volume = -7):
	if stream == music:
		return

	stream = music
	volume_db = volume
	play()

func play_music_level():
	_play_music(bg_music, -30)

func play_effect(aud_stream: AudioStream, volume = 0.0, loops = false):
	var fx_player = AudioStreamPlayer2D.new()
	fx_player.stream = aud_stream
	fx_player.name = "FX_PLAYER"
	fx_player.volume_db = volume
	add_child(fx_player)
	fx_player.play()
	if not loops: 
		fx_player.finished.connect(fx_player.queue_free)
	else:
		return fx_player
	