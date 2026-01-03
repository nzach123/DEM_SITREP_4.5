extends GutTest

var QuizAudioScript = load("res://src/components/QuizAudio.gd")
var _controller
var _mock_trust_system

class MockTrustSystem:
	extends Node
	signal trust_changed(new_val)
	var current_trust = 100.0

func before_each():
	_controller = QuizAudioScript.new()
	add_child_autofree(_controller)
	_mock_trust_system = MockTrustSystem.new()
	add_child_autofree(_mock_trust_system)
	_controller.setup(_mock_trust_system)

func test_intensity_thresholds_high():
	# High Intensity: Trust < 35
	_mock_trust_system.current_trust = 34
	_mock_trust_system.emit_signal("trust_changed", 34)
	assert_eq(_controller.current_intensity, _controller.Intensity.HIGH, "Trust 34 should be HIGH intensity")
	
	_mock_trust_system.current_trust = 0
	_mock_trust_system.emit_signal("trust_changed", 0)
	assert_eq(_controller.current_intensity, _controller.Intensity.HIGH, "Trust 0 should be HIGH intensity")

func test_intensity_thresholds_medium():
	# Medium Intensity: 35 - 74
	_mock_trust_system.current_trust = 35
	_mock_trust_system.emit_signal("trust_changed", 35)
	assert_eq(_controller.current_intensity, _controller.Intensity.MEDIUM, "Trust 35 should be MEDIUM intensity")
	
	_mock_trust_system.current_trust = 50
	_mock_trust_system.emit_signal("trust_changed", 50)
	assert_eq(_controller.current_intensity, _controller.Intensity.MEDIUM, "Trust 50 should be MEDIUM intensity")
	
	_mock_trust_system.current_trust = 74
	_mock_trust_system.emit_signal("trust_changed", 74)
	assert_eq(_controller.current_intensity, _controller.Intensity.MEDIUM, "Trust 74 should be MEDIUM intensity")

func test_intensity_thresholds_low():
	# Low Intensity: >= 75
	_mock_trust_system.current_trust = 75
	_mock_trust_system.emit_signal("trust_changed", 75)
	assert_eq(_controller.current_intensity, _controller.Intensity.LOW, "Trust 75 should be LOW intensity")
	
	_mock_trust_system.current_trust = 100
	_mock_trust_system.emit_signal("trust_changed", 100)
	assert_eq(_controller.current_intensity, _controller.Intensity.LOW, "Trust 100 should be LOW intensity")

func test_track_swapping():

	var low = load("res://assets/audio/music/Loops/background_music_low_loop.ogg")

	var med = load("res://assets/audio/music/Loops/background_music_med_loop.ogg")

	var high = load("res://assets/audio/music/Loops/background_music_max_loop.ogg")

	

	_controller.stream_low = low

	_controller.stream_med = med

	_controller.stream_high = high

	

	# Force play for LOW

	_controller.update_intensity(100)

	_controller._play_current_intensity()

	assert_eq(_controller._music_player.stream, low, "Should play LOW stream")

	

	_mock_trust_system.current_trust = 50

	_mock_trust_system.emit_signal("trust_changed", 50)

	assert_eq(_controller._music_player.stream, med, "Should swap to MEDIUM stream")

	

	_mock_trust_system.current_trust = 10

	_mock_trust_system.emit_signal("trust_changed", 10)

	assert_eq(_controller._music_player.stream, high, "Should swap to HIGH stream")
