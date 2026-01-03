extends GutTest

var SceneAudioManagerScript = load("res://src/components/SceneAudioManager.gd")
var _manager

func test_creates_audio_players():
	_manager = SceneAudioManagerScript.new()
	add_child_autofree(_manager)
	assert_not_null(_manager.get_node_or_null("MusicPlayer"), "Should create MusicPlayer")
	assert_not_null(_manager.get_node_or_null("SFXPlayer"), "Should create SFXPlayer")

func test_bus_routing():
	_manager = SceneAudioManagerScript.new()
	add_child_autofree(_manager)
	
	var music = _manager.get_node_or_null("MusicPlayer")
	var sfx = _manager.get_node_or_null("SFXPlayer")
	
	if music: assert_eq(music.bus, "Music", "MusicPlayer should be on Music bus")
	if sfx: assert_eq(sfx.bus, "SFX", "SFXPlayer should be on SFX bus")

func test_plays_music_on_start():
	var stream = load("res://assets/audio/music/Loops/background_music_med_loop.ogg")
	_manager = SceneAudioManagerScript.new()
	_manager.music_stream = stream
	add_child_autofree(_manager)
	
	var music = _manager.get_node_or_null("MusicPlayer")
	if music:
		assert_true(music.playing, "Music should be playing")
		assert_eq(music.stream, stream, "Stream should match")
