extends GutTest

const CARD_SCENE_PATH = "res://src/scenes/LogEntryCard.tscn"

func test_evidence_image_is_removed():
	var card = load(CARD_SCENE_PATH).instantiate()
	add_child_autofree(card)
	
	var evidence_image = card.find_child("EvidenceImage", true, false)
	assert_null(evidence_image, "EvidenceImage node should NOT exist")
	
	assert_false("evidence_image" in card, "evidence_image property should NOT exist in script")