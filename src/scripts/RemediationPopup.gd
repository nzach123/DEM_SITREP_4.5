extends Control

signal acknowledged

@onready var explanation_label: Label = $Panel/VBoxContainer/MarginContainer/ExplanationLabel
@onready var acknowledge_button: Button = $Panel/VBoxContainer/AcknowledgeButton

func _ready() -> void:
	acknowledge_button.pressed.connect(_on_acknowledge_pressed)

func set_explanation(text_content: String) -> void:
	explanation_label.text = text_content

func _on_acknowledge_pressed() -> void:
	acknowledged.emit()
