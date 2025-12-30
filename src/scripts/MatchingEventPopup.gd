extends Control

signal completed(success: bool)

@onready var timer_label: Label = $MarginContainer/VBoxContainer/Header/TimerLabel
@onready var definition_label: Label = $MarginContainer/VBoxContainer/DefinitionContainer/MarginContainer/CurrentDefinitionLabel
@onready var term_grid: GridContainer = $MarginContainer/VBoxContainer/TermGrid
@onready var crt_screen: ColorRect = $CRTScreen

# Resources to style the buttons dynamically
const BUTTON_THEME = preload("res://content/resources/themes/Montserrat_button_theme.tres")

var time_left: float = 60.0
var is_active: bool = false
var definitions_deck: Array = []
var current_target: Dictionary = {}
var terms_list: Array = []

func _ready() -> void:
	hide()
	# Ensure CRT is visible
	if crt_screen:
		crt_screen.visible = true

func _process(delta: float) -> void:
	if is_active:
		time_left -= delta
		timer_label.text = "TIME: " + str(int(ceil(time_left)))

		if time_left <= 0:
			finish_game(false)

func setup() -> void:
	is_active = true
	time_left = 60.0

	# Fetch data
	var raw_data = GameManager.get_matching_round_data()
	if raw_data.size() < 1:
		print("Error: Not enough matching data found.")
		finish_game(false)
		return

	# Setup Decks
	definitions_deck = raw_data.duplicate()
	definitions_deck.shuffle()

	# Terms list should probably contain all answers from the deck to be fair,
	# or we can keep the terms static if we want them all visible at once.
	# The prompt implies "match against the terms" (plural), so a static grid of choices is good.
	terms_list = raw_data.duplicate()
	# We might want to shuffle the grid positions once
	terms_list.shuffle()

	_populate_term_grid()
	_next_round()

	show()

func _populate_term_grid() -> void:
	# Clear existing
	for child in term_grid.get_children():
		child.queue_free()

	for item in terms_list:
		if not item.has("term") or not item.has("id"):
			continue

		var btn = Button.new()
		btn.text = item["term"]
		btn.theme = BUTTON_THEME
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.size_flags_vertical = Control.SIZE_EXPAND_FILL
		btn.custom_minimum_size = Vector2(0, 80)
		btn.set_meta("item_id", item["id"])
		btn.pressed.connect(_on_term_selected.bind(item["id"], btn))
		term_grid.add_child(btn)

func _next_round() -> void:
	if definitions_deck.is_empty():
		finish_game(true)
		return

	current_target = definitions_deck.pop_front()

	if not current_target.has("definition") or not current_target.has("id"):
		# Skip invalid data
		_next_round()
		return

	definition_label.text = current_target["definition"]

	# Reset button states if we want to re-enable them?
	# If we are matching 1-to-1, we should disable the used term button.
	# Let's find the button for the *previously* matched term if any?
	# Actually, easier to just check if the button's ID is in the remaining deck?
	# Or just disable them as we go.

func _on_term_selected(selected_id: String, btn_ref: Button) -> void:
	if not is_active: return

	if selected_id == current_target["id"]:
		# Match!
		# Visual feedback on button? Green flash?
		btn_ref.disabled = true # Disable the used term
		btn_ref.modulate = Color(0, 1, 0) # Green
		_next_round()
	else:
		# Fail!
		# Penalty
		time_left -= 5.0
		timer_label.modulate = Color(1, 0, 0)

		# Shake effect or red flash on button
		var original_mod = btn_ref.modulate
		btn_ref.modulate = Color(1, 0, 0)

		var tween = create_tween()
		tween.tween_property(timer_label, "modulate", Color(1, 1, 1), 0.5)
		tween.parallel().tween_property(btn_ref, "modulate", original_mod, 0.5)

func finish_game(success: bool) -> void:
	is_active = false
	completed.emit(success)
	hide()
