extends Node
class_name QuizAudioManager


@onready var sfx_click: AudioStreamPlayer = $AudioManager/SFX_Click
@onready var sfx_success: AudioStreamPlayer = $AudioManager/SFX_Success
@onready var sfx_fail: AudioStreamPlayer = $AudioManager/SFX_Fail
@onready var sfx_result: AudioStreamPlayer = $AudioManager/SFX_Result
@onready var sfx_pop: AudioStreamPlayer = $AudioManager/SFX_Pop





var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	pass
func play_click() -> void:
	_play_sound(sfx_click, true)

func play_success() -> void:
	_play_sound(sfx_success, false)

func play_fail() -> void:
	_play_sound(sfx_fail, false)

func play_result() -> void:
	_play_sound(sfx_result, false)

func play_pop() -> void:
	_play_sound(sfx_pop, false)

func _play_sound(player: AudioStreamPlayer, randomize_pitch: bool = false) -> void:
	if randomize_pitch:
		player.pitch_scale = rng.randf_range(0.9, 1.1)
	else:
		player.pitch_scale = 1.0
	player.play()
