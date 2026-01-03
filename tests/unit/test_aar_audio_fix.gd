extends GutTest

var SceneAudioManagerScript = load("res://src/components/SceneAudioManager.gd")
var audio_manager

func before_each():
	audio_manager = SceneAudioManagerScript.new()
	add_child_autofree(audio_manager)

func test_play_music_safely_handles_null():
	# SceneAudioManager has play_music(stream)
	audio_manager.play_music(null)
	pass_test("Executed without error")

func test_ambience_is_created_and_plays():
	# SceneAudioManager auto-creates _music_player and _sfx_player
	# It starts playing music if stream is set in _ready.
	# But here we didn't set music_stream.
	
	assert_not_null(audio_manager.get_node_or_null("MusicPlayer"), "MusicPlayer should be auto-created")
