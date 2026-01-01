extends GutTest

var audio_manager: AARAudioManager

func before_each():
	audio_manager = AARAudioManager.new()
	add_child_autofree(audio_manager)

func test_play_victory_music_safely_handles_missing_nodes():
	# No children added, exports are null
	# This should NOT crash, but logically it won't play anything.
	# We want to verify it doesn't throw an error.
	audio_manager.play_victory_music()
	pass_test("Executed without error")

func test_play_fail_music_safely_handles_missing_nodes():
	audio_manager.play_fail_music()
	pass_test("Executed without error")

func test_ambience_is_created_and_plays():
	# _ready is called when added to tree
	assert_not_null(audio_manager.sfx_ambience, "Ambience player should be auto-created")
	if audio_manager.sfx_ambience:
		assert_true(audio_manager.sfx_ambience.playing, "Ambience should be playing")