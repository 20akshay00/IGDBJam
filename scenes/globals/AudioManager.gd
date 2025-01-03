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

var mouse_click_sfx := preload("res://assets/audio/sfx/mouseclickv2.mp3")

var _stream_tween: Tween = null
var _current_stream_id: int = -1

func _play_music(id: int) -> void:
	if _current_stream_id == id: return
	_current_stream_id = id
	if _stream_tween: _stream_tween.kill()
	
	get_child(id).playing = true
	_stream_tween = create_tween()
	#_stream_tween.set_parallel()
	_stream_tween.tween_method(_set_volume.bind(get_child(1 - id)), db_to_linear(-20.), 0., 1.).set_ease(Tween.EASE_IN)
	_stream_tween.tween_method(_set_volume.bind(get_child(id)), 0., db_to_linear(-20.), 1.)
	_stream_tween.tween_callback(func(): get_child(1 - id).playing = false)
	
func play_music_level(lvl: int):
	if lvl == 0:
		_play_music(0)
	elif lvl < 6:
		_play_music(1)
	else:
		_play_music(0)
		
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
	
func _set_volume(vol: float, player: AudioStreamPlayer) -> void:
	player.volume_db = linear_to_db(vol)
