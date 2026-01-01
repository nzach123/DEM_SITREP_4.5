extends Node
class_name QuizAudioManager

# --- Configuration ---
@export_group("Feedback Sounds")
@export var sfx_correct: AudioStreamPlayer
@export var sfx_wrong: AudioStreamPlayer
@export var sfx_click: AudioStreamPlayer

@export_group("Atmosphere")
@export var sfx_alarm: AudioStreamPlayer
@export var sfx_ambience: AudioStreamPlayer

@export_group("Typewriter Variations")
@export var sfx_typeon01: AudioStreamPlayer
@export var sfx_typeon02: AudioStreamPlayer
@export var sfx_typeon03: AudioStreamPlayer

var _typewriter_sounds: Array[AudioStreamPlayer] = []
var _last_played_index: int = -1

func _ready() -> void:
	# Fallback: Find children if exports are not assigned (Backwards compatibility with existing scene)
	if not sfx_correct: sfx_correct = get_node_or_null("SFX_Correct")
	if not sfx_wrong: sfx_wrong = get_node_or_null("SFX_Wrong")
	if not sfx_click: sfx_click = get_node_or_null("SFX_Click")
	if not sfx_alarm: sfx_alarm = get_node_or_null("SFX_Alarm")
	if not sfx_ambience: sfx_ambience = get_node_or_null("SFX_BackgroundMusic")
	
	if not sfx_typeon01: sfx_typeon01 = get_node_or_null("SFX_typeon01")
	if not sfx_typeon02: sfx_typeon02 = get_node_or_null("SFX_typeon02")
	if not sfx_typeon03: sfx_typeon03 = get_node_or_null("SFX_typeon03")

	# Populate pool
	if sfx_typeon01: _typewriter_sounds.append(sfx_typeon01)
	if sfx_typeon02: _typewriter_sounds.append(sfx_typeon02)
	if sfx_typeon03: _typewriter_sounds.append(sfx_typeon03)

	if sfx_ambience and not sfx_ambience.playing:
		sfx_ambience.play()

func play_correct() -> void:
	_play_if_valid(sfx_correct)

func play_wrong() -> void:
	_play_if_valid(sfx_wrong)

func play_click() -> void:
	_play_if_valid(sfx_click)

func play_alarm() -> void:
	if sfx_alarm and not sfx_alarm.playing:
		sfx_alarm.play()

func stop_alarm() -> void:
	if sfx_alarm:
		sfx_alarm.stop()

func play_typewriter() -> void:
	if _typewriter_sounds.is_empty():
		return

	var index = 0
	if _typewriter_sounds.size() > 1:
		index = randi() % _typewriter_sounds.size()
		while index == _last_played_index:
			index = randi() % _typewriter_sounds.size()
	
	_last_played_index = index
	var sound = _typewriter_sounds[index]
	
	# Randomize pitch slightly for mechanical feel
	sound.pitch_scale = randf_range(0.95, 1.05)
	sound.play()

func stop_ambience() -> void:
	if sfx_ambience:
		sfx_ambience.stop()

# Helper to prevent crashes if a node isn't assigned
func _play_if_valid(player: AudioStreamPlayer) -> void:
	if player:
		player.play()