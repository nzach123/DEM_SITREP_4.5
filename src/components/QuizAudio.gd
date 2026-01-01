extends Node
class_name QuizAudioManager

# --- Configuration ---
@export_group("Room Tone (Diegetic)")
@export var sfx_room_tone: AudioStreamPlayer
@export var sfx_ambience: AudioStreamPlayer

@export_group("Triage Events")
@export var sfx_incoming_alert: AudioStreamPlayer
@export var sfx_typewriter_pool: Array[AudioStreamPlayer]

@export_group("Feedback")
@export var sfx_correct: AudioStreamPlayer
@export var sfx_wrong: AudioStreamPlayer
@export var sfx_click: AudioStreamPlayer
@export var sfx_alarm: AudioStreamPlayer

var _last_played_index: int = -1

func _ready() -> void:
	start_shift()

func start_shift() -> void:
	# The room tone is the reality anchor. It always runs.
	if sfx_room_tone and not sfx_room_tone.playing:
		sfx_room_tone.play()

	# Music is the mood layer.
	if sfx_ambience and not sfx_ambience.playing:
		sfx_ambience.play()

func play_incoming_alert() -> void:
	_play_if_valid(sfx_incoming_alert)

func play_typewriter() -> void:
	if sfx_typewriter_pool.is_empty():
		return

	var index = 0
	if sfx_typewriter_pool.size() > 1:
		# Simple non-repeating random
		index = randi() % sfx_typewriter_pool.size()
		while index == _last_played_index:
			index = randi() % sfx_typewriter_pool.size()
	
	_last_played_index = index
	var sound = sfx_typewriter_pool[index]
	
	# Slight pitch variance makes it feel like processing data
	if sound:
		sound.pitch_scale = randf_range(0.95, 1.05)
		sound.play()

func play_correct() -> void: _play_if_valid(sfx_correct)
func play_wrong() -> void: _play_if_valid(sfx_wrong)
func play_click() -> void: _play_if_valid(sfx_click)

func play_alarm() -> void:
	if sfx_alarm and not sfx_alarm.playing: sfx_alarm.play()

func stop_alarm() -> void:
	if sfx_alarm: sfx_alarm.stop()

func stop_ambience() -> void:
	if sfx_ambience: sfx_ambience.stop()
	# Note: We usually DO NOT stop room tone, as the room still exists.

func _play_if_valid(player: AudioStreamPlayer) -> void:
	if player: player.play()
