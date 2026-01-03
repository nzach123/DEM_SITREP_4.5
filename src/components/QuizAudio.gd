extends Node
class_name QuizAudioManager

enum Intensity { LOW, MEDIUM, HIGH }

# --- Configuration ---
@export_group("Room Tone (Diegetic)")
@export var sfx_room_tone: AudioStreamPlayer

@export_group("Adaptive Music")
@export var stream_low: AudioStream
@export var stream_med: AudioStream
@export var stream_high: AudioStream

@export_group("Triage Events")
@export var sfx_incoming_alert: AudioStreamPlayer
@export var sfx_typewriter_pool: Array[AudioStreamPlayer]

@export_group("Feedback")
@export var sfx_correct: AudioStreamPlayer
@export var sfx_wrong: AudioStreamPlayer
@export var sfx_click: AudioStreamPlayer
@export var sfx_alarm: AudioStreamPlayer

var _last_played_index: int = -1
var current_intensity: Intensity = Intensity.LOW
var _music_player: AudioStreamPlayer

func _ready() -> void:
	_create_music_player()
	# GameSession calls setup()

func _create_music_player() -> void:
	if not _music_player:
		_music_player = AudioStreamPlayer.new()
		_music_player.name = "MusicPlayer"
		_music_player.bus = "Music"
		add_child(_music_player)

func setup(trust_sys: Node) -> void:
	if trust_sys:
		if not trust_sys.trust_changed.is_connected(_on_trust_changed):
			trust_sys.trust_changed.connect(_on_trust_changed)
		update_intensity(int(trust_sys.current_trust))
	
	start_shift()

func start_shift() -> void:
	if sfx_room_tone and not sfx_room_tone.playing:
		sfx_room_tone.play()

	_play_current_intensity()

func _on_trust_changed(new_trust: float) -> void:
	var old_intensity = current_intensity
	update_intensity(int(new_trust))
	
	if old_intensity != current_intensity:
		_play_current_intensity()

func update_intensity(trust: int) -> void:
	if trust < 35:
		current_intensity = Intensity.HIGH
	elif trust < 75:
		current_intensity = Intensity.MEDIUM
	else:
		current_intensity = Intensity.LOW

func _play_current_intensity() -> void:
	var target_stream: AudioStream = null
	match current_intensity:
		Intensity.LOW: target_stream = stream_low
		Intensity.MEDIUM: target_stream = stream_med
		Intensity.HIGH: target_stream = stream_high
		
	if not target_stream:
		return
		
	if _music_player.stream == target_stream and _music_player.playing:
		return
		
	_music_player.stream = target_stream
	_music_player.play()

func stop_music() -> void:
	if _music_player:
		_music_player.stop()

# --- SFX Methods ---
func play_incoming_alert() -> void: _play_if_valid(sfx_incoming_alert)

func play_typewriter() -> void:
	if sfx_typewriter_pool.is_empty(): return
	var index = randi() % sfx_typewriter_pool.size()
	while index == _last_played_index and sfx_typewriter_pool.size() > 1:
		index = randi() % sfx_typewriter_pool.size()
	_last_played_index = index
	var sound = sfx_typewriter_pool[index]
	if sound:
		sound.pitch_scale = randf_range(0.95, 1.05)
		sound.play()

func play_correct() -> void: _play_if_valid(sfx_correct)
func play_wrong() -> void: _play_if_valid(sfx_wrong)
func play_click() -> void: _play_if_valid(sfx_click)
func play_alarm() -> void: if sfx_alarm and not sfx_alarm.playing: sfx_alarm.play()
func stop_alarm() -> void: if sfx_alarm: sfx_alarm.stop()

func stop_ambience() -> void: stop_music()

func _play_if_valid(player: AudioStreamPlayer) -> void:
	if player: player.play()
