extends GutTest

const CARD_SCENE_PATH = "res://src/scenes/LogEntryCard.tscn"

func test_evidence_image_is_removed():
	var card = load(CARD_SCENE_PATH).instantiate()
	add_child_autofree(card)
	
	var evidence_image = card.find_child("EvidenceImage", true, false)
	assert_null(evidence_image, "EvidenceImage node should NOT exist")
	
	assert_false("evidence_image" in card, "evidence_image property should NOT exist in script")

func test_vertical_size_flags():
	var card = load(CARD_SCENE_PATH).instantiate()
	add_child_autofree(card)
	
	# SIZE_FILL = 1, SIZE_EXPAND = 2
	assert_eq(card.size_flags_vertical & Control.SIZE_FILL, Control.SIZE_FILL, "Vertical size flags should include FILL")
	assert_eq(card.size_flags_vertical & Control.SIZE_EXPAND, 0, "Vertical size flags should NOT include EXPAND")

func test_vertical_expansion_with_long_text():
	var card = load(CARD_SCENE_PATH).instantiate()
	card.custom_minimum_size = Vector2(400, 0)
	card.size = Vector2(400, 50)
	add_child_autofree(card)
	
	# Get initial height
	await wait_frames(2)
	var initial_height = card.size.y
	
	# Inject long text
	var question_label = card.find_child("QuestionLabel", true, false)
	question_label.text = "This is a very long text. ".repeat(50)
	
	await wait_frames(2)
	var expanded_height = card.size.y
	
	assert_gt(expanded_height, initial_height, "Card should expand vertically with long text")