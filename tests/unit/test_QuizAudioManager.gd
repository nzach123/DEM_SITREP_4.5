extends GutTest

var QuizAudioManagerScript = load("res://src/components/QuizAudio.gd")
var _audio_manager

class MockPlayer:
	extends AudioStreamPlayer
	var play_called = false
	# Override native play
	func play(from_position: float = 0.0) -> void:
		play_called = true

func before_each():
	_audio_manager = QuizAudioManagerScript.new()
	add_child_autofree(_audio_manager)

func test_play_typewriter_exists_and_replaces_old_method():
	assert_has_method(_audio_manager, "play_typewriter", "QuizAudioManager should have play_typewriter method")

func test_exports_exist():
	assert_true("sfx_typeon01" in _audio_manager, "Should have sfx_typeon01 export")
	assert_true("sfx_typeon02" in _audio_manager, "Should have sfx_typeon02 export")
	assert_true("sfx_typeon03" in _audio_manager, "Should have sfx_typeon03 export")

func test_play_typewriter_logic():
	# Setup mocks
	var p1 = MockPlayer.new()
	var p2 = MockPlayer.new()
	var p3 = MockPlayer.new()
	add_child_autofree(p1)
	add_child_autofree(p2)
	add_child_autofree(p3)
	
	# These assignments will fail if properties don't exist
	if "sfx_typeon01" in _audio_manager: _audio_manager.sfx_typeon01 = p1
	if "sfx_typeon02" in _audio_manager: _audio_manager.sfx_typeon02 = p2
	if "sfx_typeon03" in _audio_manager: _audio_manager.sfx_typeon03 = p3
	
	# Trigger internal list population since _ready might have already run or needs to run
	# Since we just assigned them, the _typewriter_sounds array in the script is likely empty because _ready ran on init.
	# We need to manually populate or re-run logic.
	# Since _ready is called when added to tree, and we added it in before_each, it ran with nulls.
	# We should manually populate the array for the test or create a method to refresh.
	# Or, since it's a test, just access the private array if possible or re-add to tree.
	
	_audio_manager._typewriter_sounds.clear()
	_audio_manager._typewriter_sounds.append(p1)
	_audio_manager._typewriter_sounds.append(p2)
	_audio_manager._typewriter_sounds.append(p3)

	var last_played_index = -1
	
	for i in range(50):
		# Reset mocks
		p1.play_called = false
		p2.play_called = false
		p3.play_called = false
		
		_audio_manager.play_typewriter()
		
		var played_count = 0
		var current_index = -1
		
		if p1.play_called: 
			played_count += 1
			current_index = 0
		if p2.play_called: 
			played_count += 1
			current_index = 1
		if p3.play_called: 
			played_count += 1
			current_index = 2
			
		assert_eq(played_count, 1, "Exactly one sound should play")
		assert_ne(current_index, last_played_index, "Should not play the same sound twice in a row")
		
		last_played_index = current_index