extends Node
class_name AARAudioManager

# --- Configuration ---
@export_group("UI Sounds")
@export var sfx_click: AudioStreamPlayer
@export var sfx_tally: AudioStreamPlayer # For counting up score
@export var sfx_pop: AudioStreamPlayer # For card entry animations
@export var sfx_ambience: AudioStreamPlayer # Background Loop

@export_group("Music")
@export var music_victory: AudioStreamPlayer
@export var music_fail: AudioStreamPlayer

# Preload resources to ensure correct audio
const MUSIC_VICTORY_STREAM = preload("res://assets/audio/music/Loops/Retro Polka.ogg")
const MUSIC_FAIL_STREAM = preload("res://assets/audio/music/Loops/computerNoise_003.ogg")
const AMBIENCE_STREAM = preload("res://assets/audio/sfx/loops/Computers_Lights_Hum_loop.ogg")

func _ready() -> void:
	# Fallback: Find children if exports are not assigned
	if not sfx_click: sfx_click = get_node_or_null("SFX_Click")
	if not sfx_tally: sfx_tally = get_node_or_null("SFX_Result") # Reusing Result/Scroll sound for tally if Tally not present
	if not sfx_pop: sfx_pop = get_node_or_null("SFX_Pop")
	if not sfx_ambience: sfx_ambience = get_node_or_null("SFX_Ambience")
	
	if not music_victory: music_victory = get_node_or_null("SFX_Success")
	if not music_fail: music_fail = get_node_or_null("SFX_Fail")
	
	if not music_victory: 
		push_warning("AARAudioManager: Victory Music node missing")
	else:
		if music_victory.stream != MUSIC_VICTORY_STREAM:
			music_victory.stream = MUSIC_VICTORY_STREAM
			
	if not music_fail: 
		push_warning("AARAudioManager: Fail Music node missing")
	else:
		if music_fail.stream != MUSIC_FAIL_STREAM:
			music_fail.stream = MUSIC_FAIL_STREAM
			
	if sfx_ambience:
		if sfx_ambience.stream != AMBIENCE_STREAM:
			sfx_ambience.stream = AMBIENCE_STREAM
		if not sfx_ambience.playing:
			sfx_ambience.play()
	else:
		# Auto-create if missing (Robustness)
		var amb = AudioStreamPlayer.new()
		amb.name = "SFX_Ambience"
		amb.stream = AMBIENCE_STREAM
		amb.bus = "SFX"
		amb.autoplay = true
		add_child(amb)
		sfx_ambience = amb

func play_click() -> void:
	if sfx_click:
		sfx_click.play()

func play_tally_tick() -> void:
	if sfx_tally:
		sfx_tally.pitch_scale = randf_range(0.9, 1.1)
		sfx_tally.play()

func play_pop() -> void:
	if sfx_pop:
		sfx_pop.pitch_scale = randf_range(0.9, 1.1)
		sfx_pop.play()

func play_victory_music() -> void:
	_crossfade_music(music_victory)

func play_fail_music() -> void:
	_crossfade_music(music_fail)

func _crossfade_music(target: AudioStreamPlayer) -> void:
	# Simple play for now, can add tween fading later
	if music_victory and music_victory != target: music_victory.stop()
	if music_fail and music_fail != target: music_fail.stop()

	if target:
		target.play()
