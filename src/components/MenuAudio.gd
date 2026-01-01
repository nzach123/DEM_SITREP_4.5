extends Node
class_name MenuAudioManager

# --- Configuration ---
@export_group("Audio Players")
@export var music_player: AudioStreamPlayer
@export var sfx_click: AudioStreamPlayer
@export var sfx_hover: AudioStreamPlayer # Optional

func _ready() -> void:
	# Fallback: Find children if exports are not assigned
	if not music_player:
		music_player = get_node_or_null("SFX_Background_Loop")
	if not sfx_click:
		sfx_click = get_node_or_null("SFX_Click")

	if music_player and not music_player.playing:
		music_player.play()

func play_click() -> void:
	if sfx_click:
		sfx_click.play()

func play_hover() -> void:
	if sfx_hover:
		sfx_hover.play()

func stop_music() -> void:
	if music_player:
		music_player.stop()
