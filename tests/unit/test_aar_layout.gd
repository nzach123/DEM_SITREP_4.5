extends GutTest

const CARD_SCENE_PATH = "res://src/scenes/LogEntryCard.tscn"
const MAX_WIDTH = 400.0

func test_card_width_constraint_with_long_text():
	# 1. Setup Parent Container with fixed width
	var container = PanelContainer.new()
	container.custom_minimum_size = Vector2(MAX_WIDTH, 100)
	container.size = Vector2(MAX_WIDTH, 100)
	add_child_autofree(container)
	
	# 2. Instantiate Card
	var card = load(CARD_SCENE_PATH).instantiate()
	container.add_child(card)
	
	# 3. Inject Oversized Content (Long Text)
	# Target QuestionLabel which has autowrap enabled
	var question_label = card.find_child("QuestionLabel", true, false)
	if question_label:
		question_label.text = "This is a very long text that should absolutely wrap and not stretch the container width beyond the limits set by the parent control. If this text does not wrap, the test should fail because the container width will exceed the maximum allowed width. We are repeating this to ensure it is very long. " + "Repeat. ".repeat(100)
	
	# Force layout update
	await wait_frames(2)
	
	# 4. Assert
	# Check Card Width
	assert_lt(card.size.x, MAX_WIDTH + 10.0, "Card width should be constrained by parent width (Text)")
	
	# Check Content Width (internal)
	var content = card.find_child("MarginContainer", true, false)
	if content:
		assert_lt(content.size.x, MAX_WIDTH + 10.0, "Internal content width should also be constrained (Text)")


func test_card_width_constraint_with_large_image():
	# 1. Setup Parent Container
	var container = PanelContainer.new()
	container.custom_minimum_size = Vector2(MAX_WIDTH, 100)
	container.size = Vector2(MAX_WIDTH, 100)
	add_child_autofree(container)
	
	# 2. Instantiate Card
	var card = load(CARD_SCENE_PATH).instantiate()
	container.add_child(card)
	
	# 3. Inject Oversized Content (Large Image)
	var evidence_image = card.find_child("EvidenceImage", true, false)
	if evidence_image:
		# Create a large dummy texture (2000x2000)
		var img = Image.create(2000, 2000, false, Image.FORMAT_RGBA8)
		var tex = ImageTexture.create_from_image(img)
		evidence_image.texture = tex
		evidence_image.show()
	
	# Force layout update
	await wait_frames(2)
	
	# 4. Assert
	assert_lt(card.size.x, MAX_WIDTH + 10.0, "Card width should be constrained even with large image")
	
	var content = card.find_child("MarginContainer", true, false)
	if content:
		assert_lt(content.size.x, MAX_WIDTH + 10.0, "Internal content width should be constrained (Image)")

func _get_all_children_recursive(node: Node, type: Variant) -> Array:
	var nodes = []
	for child in node.get_children():
		if is_instance_of(child, type):
			nodes.append(child)
		nodes.append_array(_get_all_children_recursive(child, type))
	return nodes
