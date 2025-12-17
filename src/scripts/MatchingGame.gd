extends Control

@onready var round_label: Label = $MarginContainer/VBoxContainer/Header/RoundLabel
@onready var timer_label: Label = $MarginContainer/VBoxContainer/Header/TimerLabel
@onready var lives_label: Label = $MarginContainer/VBoxContainer/Header/LivesLabel

@onready var terms_container: VBoxContainer = $MarginContainer/VBoxContainer/Content/LeftCol/TermsContainer
@onready var definitions_container: VBoxContainer = $MarginContainer/VBoxContainer/Content/RightCol/DefinitionsContainer

@onready var quit_button: Button = $MarginContainer/VBoxContainer/Footer/QuitButton
@onready var submit_button: Button = $MarginContainer/VBoxContainer/Footer/SubmitButton

@onready var feedback_layer: Control = $FeedbackLayer
@onready var x_layer: Control = $XLayer
@onready var buzzer_player: AudioStreamPlayer = $BuzzerPlayer
@onready var correct_player: AudioStreamPlayer = $CorrectPlayer

const TERM_ROW_SCENE: PackedScene = preload("res://src/scenes/TermRow.tscn")
const DEFINITION_ROW_SCENE: PackedScene = preload("res://src/scenes/DefinitionRow.tscn")

var current_round: int = 1
var total_rounds: int = 3
var lives: int = 3
var time_left: float = 60.0

var current_data: Array = []
var game_active: bool = false

func _ready() -> void:
	total_rounds = GameManager.matching_rounds_count
	current_round = 1
	lives = 3

	quit_button.pressed.connect(_on_quit_pressed)
	submit_button.pressed.connect(_on_submit_pressed)

	start_round()

func _process(delta: float) -> void:
	if game_active:
		time_left -= delta
		update_timer_ui()
		if time_left <= 0:
			handle_timeout()

func start_round() -> void:
	# Clear previous UI
	for child in terms_container.get_children():
		child.queue_free()
	for child in definitions_container.get_children():
		child.queue_free()

	if current_round > total_rounds:
		game_complete()
		return

	game_active = true

	# Calculate Time Limit based on Difficulty
	var settings = GameManager.get_current_settings()
	var time_per_q = settings.get("time_per_question", 12.0)
	time_left = time_per_q * 5.0

	update_ui_state()

	# Fetch Data
	var raw_items = GameManager.get_matching_round_data()
	if raw_items.size() < 5:
		print("Not enough items for matching round!")
		GameManager.quit_to_main()
		return

	current_data = raw_items

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

func _on_submit_pressed() -> void:
	if not game_active: return

	if check_matches():
		# Success
		game_active = false
		correct_player.play()
		feedback_layer.get_node("FeedbackLabel").text = "CORRECT!"
		feedback_layer.show()
		await get_tree().create_timer(2.0).timeout
		feedback_layer.hide()
		current_round += 1
		start_round()
	else:
		# Fail
		fail_attempt()

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

func update_ui_state() -> void:
	round_label.text = "ROUND %d/%d" % [current_round, total_rounds]
	lives_label.text = "LIVES: %d" % lives
	update_timer_ui()

func update_timer_ui() -> void:
	timer_label.text = str(ceil(time_left))

func handle_timeout() -> void:
	fail_attempt(true)

func _on_quit_pressed() -> void:
	GameManager.quit_to_main()

func fail_attempt(is_timeout: bool = false) -> void:
	game_active = false
	lives -= 1
	lives_label.text = "LIVES: %d" % lives

	buzzer_player.play()
	x_layer.show()

	await get_tree().create_timer(2.0).timeout
	x_layer.hide()

	if lives <= 0:
		game_over()
	else:
		if is_timeout:
			# If time ran out, restart round with new questions
			start_round()
		else:
			# If just wrong guess, resume timer and let them try again?
			# User said: "After three incorrect attempts, the game ends."
			# Usually this means 3 strikes.
			# If I don't restart the round, they can just spam guess?
			# No, they have finite lives.
			# I will let them continue the same round if time permits.
			game_active = true

func game_over() -> void:
	# Show Game Over then Quit
	feedback_layer.get_node("FeedbackLabel").text = "GAME OVER"
	feedback_layer.show()
	await get_tree().create_timer(3.0).timeout
	GameManager.quit_to_main()

func game_complete() -> void:
	feedback_layer.get_node("FeedbackLabel").text = "COURSE COMPLETE!"
	feedback_layer.show()
	correct_player.play()
	await get_tree().create_timer(3.0).timeout
	GameManager.quit_to_main()
