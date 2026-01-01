extends Node
class_name AARAudioManager

# --- Configuration ---
@export_group("UI Sounds")
@export var sfx_click: AudioStreamPlayer
@export var sfx_tally: AudioStreamPlayer # For counting up score
@export var sfx_pop: AudioStreamPlayer # For card entry animations

@export_group("Music")
@export var music_victory: AudioStreamPlayer
@export var music_fail: AudioStreamPlayer

func _ready() -> void:
	# Fallback: Find children if exports are not assigned
	if not sfx_click: sfx_click = get_node_or_null("SFX_Click")
	if not sfx_tally: sfx_tally = get_node_or_null("SFX_Result") # Reusing Result/Scroll sound for tally if Tally not present
	if not sfx_pop: sfx_pop = get_node_or_null("SFX_Pop")
	if not music_victory: music_victory = get_node_or_null("SFX_Success")
	if not music_fail: music_fail = get_node_or_null("SFX_Fail")

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
