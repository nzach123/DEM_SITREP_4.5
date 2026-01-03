extends GutTest

var QuizAudioControllerScript = load("res://src/scripts/QuizAudioController.gd")
var _controller

func before_each():
	_controller = QuizAudioControllerScript.new()
	add_child_autofree(_controller)

func test_intensity_thresholds_high():
	# High Intensity: Trust < 35
	_controller.update_intensity(34)
	assert_eq(_controller.current_intensity, _controller.Intensity.HIGH, "Trust 34 should be HIGH intensity")
	
	_controller.update_intensity(0)
	assert_eq(_controller.current_intensity, _controller.Intensity.HIGH, "Trust 0 should be HIGH intensity")

func test_intensity_thresholds_medium():
	# Medium Intensity: 35 - 74
	_controller.update_intensity(35)
	assert_eq(_controller.current_intensity, _controller.Intensity.MEDIUM, "Trust 35 should be MEDIUM intensity")
	
	_controller.update_intensity(50)
	assert_eq(_controller.current_intensity, _controller.Intensity.MEDIUM, "Trust 50 should be MEDIUM intensity")
	
	_controller.update_intensity(74)
	assert_eq(_controller.current_intensity, _controller.Intensity.MEDIUM, "Trust 74 should be MEDIUM intensity")

func test_intensity_thresholds_low():
	# Low Intensity: >= 75
	_controller.update_intensity(75)
	assert_eq(_controller.current_intensity, _controller.Intensity.LOW, "Trust 75 should be LOW intensity")
	
	_controller.update_intensity(100)
	assert_eq(_controller.current_intensity, _controller.Intensity.LOW, "Trust 100 should be LOW intensity")
