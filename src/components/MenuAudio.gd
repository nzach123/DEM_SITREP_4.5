extends Node
class_name MenuAudioManager

# --- Configuration ---
@export_group("Audio Players")
@export var mus_background: AudioStreamPlayer
@export var sfx_ambience: AudioStreamPlayer
@export var sfx_click: AudioStreamPlayer
@export var sfx_hover: AudioStreamPlayer # Optional

func _ready() -> void:
	# Fallback: Find children if exports are not assigned
	if not mus_background:
		mus_background = get_node_or_null("SFX_Background_Loop")
	if not sfx_click:
		sfx_click = get_node_or_null("SFX_Click")
		
	if mus_background and not mus_background.playing:
		mus_background.play()

	if sfx_ambience and not sfx_ambience.playing:
		sfx_ambience.play()
		
func play_click() -> void:
	if sfx_click:
		sfx_click.play()

func play_hover() -> void:
	if sfx_hover:
		sfx_hover.play()

func stop_music() -> void:
	if mus_background:
		mus_background.stop()
