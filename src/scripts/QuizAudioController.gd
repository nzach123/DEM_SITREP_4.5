class_name QuizAudioController
extends Node

"""
QuizAudioController.gd
Manages adaptive music intensity based on the Public Trust metric.
Uses Horizontal Resequencing (track swapping).
"""

enum Intensity { LOW, MEDIUM, HIGH }

@export_group("Music Tracks")
@export var stream_low: AudioStream
@export var stream_med: AudioStream
@export var stream_high: AudioStream

var current_intensity: Intensity = Intensity.LOW

var _player: AudioStreamPlayer

func _ready() -> void:
	_create_player()
	
	if GameManager.has_signal("trust_changed"):
		GameManager.trust_changed.connect(_on_trust_changed)
	
	# Initialize based on current trust
	update_intensity(int(GameManager.current_trust))
	_play_current_track()

func _create_player() -> void:
	if not _player:
		_player = AudioStreamPlayer.new()
		_player.name = "MusicPlayer"
		_player.bus = "Music"
		add_child(_player)

func _on_trust_changed(new_trust: float) -> void:
	var old_intensity = current_intensity
	update_intensity(int(new_trust))
	
	if old_intensity != current_intensity:
		_play_current_track()

func update_intensity(trust: int) -> void:
	if trust < 35:
		current_intensity = Intensity.HIGH
	elif trust < 75:
		current_intensity = Intensity.MEDIUM
	else:
		current_intensity = Intensity.LOW

func _play_current_track() -> void:
	if not _player:
		_create_player()
		
	var target_stream: AudioStream = null
	match current_intensity:
		Intensity.LOW: target_stream = stream_low
		Intensity.MEDIUM: target_stream = stream_med
		Intensity.HIGH: target_stream = stream_high
		
	if not target_stream:
		return
		
	if _player.stream == target_stream and _player.playing:
		return
		
	# Quick swap
	_player.stream = target_stream
	_player.play()
