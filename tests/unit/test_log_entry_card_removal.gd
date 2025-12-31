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
