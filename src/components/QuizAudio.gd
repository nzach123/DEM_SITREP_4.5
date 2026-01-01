extends Node
class_name AARAudioManager

@onready var sfx_click: AudioStreamPlayer = $SFX_Click
@onready var sfx_correct: AudioStreamPlayer = $SFX_Correct
@onready var sfx_wrong: AudioStreamPlayer = $SFX_Wrong
@onready var sfx_alarm: AudioStreamPlayer = $SFX_Alarm
@onready var sfx_ambience: AudioStreamPlayer = $SFX_BackgroundMusic
@onready var sfx_typeon: AudioStreamPlayer = $SFX_typeon

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	if not sfx_ambience.playing:
		sfx_ambience.play()

func play_click() -> void:
	_play_sound(sfx_click, true)

func play_correct() -> void:
	_play_sound(sfx_correct, false)

func play_wrong() -> void:
	_play_sound(sfx_wrong, false)

func play_alarm() -> void:
	_play_sound(sfx_alarm, false)

func play_typeon() -> void:
	_play_sound(sfx_typeon, false)

func stop_ambience() -> void:
	sfx_ambience.stop()

func _play_sound(player: AudioStreamPlayer, randomize_pitch: bool = false) -> void:
	if randomize_pitch:
		player.pitch_scale = rng.randf_range(0.9, 1.1)
	else:
		player.pitch_scale = 1.0
	player.play()
