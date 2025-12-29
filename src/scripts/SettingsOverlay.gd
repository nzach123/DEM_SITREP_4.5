extends Control

"""
SettingsOverlay.gd
Handles the UI interactions for the settings menu.
"""

@export var master_slider: HSlider
@export var music_slider: HSlider
@export var sfx_slider: HSlider
@export var fullscreen_toggle: CheckButton
@export var back_button: Button

@onready var sfx_player: AudioStreamPlayer = $SFX_Player

func _ready() -> void:
	# Initialize UI with current settings
	master_slider.value = SettingsManager.get_volume("Master")
	music_slider.value = SettingsManager.get_volume("Music")
	sfx_slider.value = SettingsManager.get_volume("SFX")
	
	fullscreen_toggle.button_pressed = SettingsManager.get_window_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	
	# Connect signals
	master_slider.value_changed.connect(_on_master_volume_changed)
	music_slider.value_changed.connect(_on_music_volume_changed)
	sfx_slider.value_changed.connect(_on_sfx_volume_changed)
	
	fullscreen_toggle.toggled.connect(_on_fullscreen_toggled)
	back_button.pressed.connect(_on_back_pressed)
	
	# Initial state
	hide()

func open_menu() -> void:
	show()
	if back_button:
		back_button.grab_focus()

func close_menu() -> void:
	SettingsManager.save_settings()
	hide()

func _on_master_volume_changed(value: float) -> void:
	SettingsManager.set_volume("Master", value)
	_play_feedback_sfx()

func _on_music_volume_changed(value: float) -> void:
	SettingsManager.set_volume("Music", value)

func _on_sfx_volume_changed(value: float) -> void:
	SettingsManager.set_volume("SFX", value)
	_play_feedback_sfx()

func _on_fullscreen_toggled(is_pressed: bool) -> void:
	var mode = DisplayServer.WINDOW_MODE_FULLSCREEN if is_pressed else DisplayServer.WINDOW_MODE_WINDOWED
	SettingsManager.set_window_mode(mode)
	if sfx_player: sfx_player.play()

func _on_back_pressed() -> void:
	if sfx_player: sfx_player.play()
	close_menu()

func _play_feedback_sfx() -> void:
	# Avoid spamming SFX when moving slider quickly
	if not sfx_player.playing:
		sfx_player.play()
