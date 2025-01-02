extends AudioStreamPlayer2D

var valid_placement_sfx := preload("res://assets/audio/sfx/lockcorrect.mp3")
var invalid_placement_sfx := preload("res://assets/audio/sfx/lockwrong.mp3")
var light_block_move_sfx := preload("res://assets/audio/sfx/lightboxmove.mp3")
var heavy_block_move_sfx := preload("res://assets/audio/sfx/heavyboxmove.mp3")
var key_move_sfx := preload("res://assets/audio/sfx/keymove3.mp3")

var hash_press_sfx := preload("res://assets/audio/sfx/hashbuttonpress.mp3")
var stealth_sfx := preload("res://assets/audio/sfx/stealthdecrease.mp3")

var virus_sfx := preload("res://assets/audio/sfx/virusfillv7.mp3")
var virus_fail_sfx := preload("res://assets/audio/sfx/virusfillFAIL.mp3")

var bg_music := preload("res://assets/audio/music/del.maintheme2mp3.mp3")
var bg_music_adv := preload("res://assets/audio/music/del.secondthemev2.mp3")

var mouse_click_sfx := preload("res://assets/audio/sfx/mouseclickv2.mp3")

func _play_music(music: AudioStream, volume = -7):
	if stream == music:
		return

	stream = music
	volume_db = volume
	play()

func play_music_level(lvl: int):
	if lvl < 6:
		_play_music(bg_music, -20)
	else:
		_play_music(bg_music_adv, -20)
		
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
	
