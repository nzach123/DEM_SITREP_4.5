extends Control

signal completed(success: bool)

@onready var terms_container: VBoxContainer = $MarginContainer/Panel/HBoxContainer/LeftCol/TermsContainer
@onready var definitions_container: VBoxContainer = $MarginContainer/Panel/HBoxContainer/RightCol/DefinitionsContainer
@onready var timer_label: Label = $MarginContainer/Panel/MarginContainer/Header/TimerLabel
@onready var submit_button: Button = $MarginContainer/Panel/Footer/SubmitButton

const TERM_ROW_SCENE: PackedScene = preload("res://src/scenes/TermRow.tscn")
const DEFINITION_ROW_SCENE: PackedScene = preload("res://src/scenes/DefinitionRow.tscn")

var time_left: float = 60.0 # Default time
var is_active: bool = false
var current_data: Array = []

func _ready() -> void:
	submit_button.pressed.connect(_on_submit_pressed)
	hide()

func _process(delta: float) -> void:
	if is_active:
		time_left -= delta
		timer_label.text = "TIME: " + str(int(ceil(time_left)))

		if time_left <= 0:
			finish_game(false)

func setup() -> void:
	is_active = true
	time_left = 60.0 # Give them 60 seconds
	current_data = GameManager.get_matching_round_data()

	if current_data.size() < 5:
		print("Error: Not enough matching data found.")
		finish_game(false)
		return

	# Clear containers
	for child in terms_container.get_children():
		child.queue_free()
	for child in definitions_container.get_children():
		child.queue_free()

	# Prepare Definitions (Right Column) - Shuffled
	var definitions = current_data.duplicate()
	definitions.shuffle()

	# Prepare Terms (Left Column) - Shuffled
	var terms = current_data.duplicate()
	terms.shuffle()

	# Populate Definitions
	for i in range(definitions.size()):
		var item = definitions[i]
		var display_id = i + 1

		var row = DEFINITION_ROW_SCENE.instantiate()
		row.get_node("NumberLabel").text = str(display_id) + "."
		row.get_node("DefinitionLabel").text = item["definition"]
		row.set_meta("item_id", item["id"])
		definitions_container.add_child(row)

	# Populate Terms
	for i in range(terms.size()):
		var item = terms[i]
		var row = TERM_ROW_SCENE.instantiate()
		row.get_node("Label").text = item["term"]
		row.set_meta("item_id", item["id"])
		terms_container.add_child(row)

	show()

func _on_submit_pressed() -> void:
	if not is_active: return

	if check_matches():
		finish_game(true)
	else:
		# Visual feedback (shake or flash) could be added here
		timer_label.modulate = Color(1, 0, 0)
		await get_tree().create_timer(0.5).timeout
		timer_label.modulate = Color(1, 1, 1)

func check_matches() -> bool:
	var def_rows = definitions_container.get_children()
	var term_rows = terms_container.get_children()

	# Map Display ID (1-5) -> Item ID
	var display_id_to_item_id = {}
	for i in range(def_rows.size()):
		var row = def_rows[i]
		var item_id = row.get_meta("item_id")
		display_id_to_item_id[i + 1] = item_id

	for term_row in term_rows:
		var term_item_id = term_row.get_meta("item_id")
		var selected_idx = term_row.get_node("OptionButton").selected
		var selected_val = term_row.get_node("OptionButton").get_item_id(selected_idx)

		if selected_val == 0: return false # Incomplete

		# Check if selected Display ID maps to the Term's Item ID
		if display_id_to_item_id.get(selected_val) != term_item_id:
			return false

	return true

func finish_game(success: bool) -> void:
	is_active = false
	completed.emit(success)
	hide()
