extends Control

"""
CreditsOverlay.gd
Handles the display and navigation for the credits overlay.
"""

signal close_requested

@export var back_button: Button

func _ready() -> void:
	if back_button:
		back_button.pressed.connect(_on_back_pressed)
	hide()

func open_menu() -> void:
	show()
	if back_button:
		back_button.grab_focus()

func close_menu() -> void:
	hide()
	close_requested.emit()

func _on_back_pressed() -> void:
	close_menu()
