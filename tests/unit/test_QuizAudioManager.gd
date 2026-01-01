extends GutTest

var QuizAudioManagerScript = load("res://src/components/QuizAudio.gd")
var _audio_manager

func before_each():
	_audio_manager = QuizAudioManagerScript.new()
	add_child_autofree(_audio_manager)

func test_play_typewriter_exists_and_replaces_old_method():
	assert_has_method(_audio_manager, "play_typewriter", "QuizAudioManager should have play_typewriter method")
