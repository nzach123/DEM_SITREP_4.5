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

func test_play_typewriter_exists():
	assert_has_method(_audio_manager, "play_typewriter", "QuizAudioManager should have play_typewriter method")

func test_play_typewriter_logic():
	# Setup mocks
	var p1 = MockPlayer.new()
	var p2 = MockPlayer.new()
	var p3 = MockPlayer.new()
	add_child_autofree(p1)
	add_child_autofree(p2)
	add_child_autofree(p3)
	
	var pool: Array[AudioStreamPlayer] = [p1, p2, p3]
	_audio_manager.sfx_typewriter_pool = pool

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
		if last_played_index != -1:
			assert_ne(current_index, last_played_index, "Should not play the same sound twice in a row")
		
		last_played_index = current_index
