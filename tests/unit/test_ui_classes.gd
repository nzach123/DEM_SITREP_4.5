extends GutTest

func test_scripts_have_class_names():
	var settings_script = load("res://src/scripts/SettingsOverlay.gd")
	assert_eq(settings_script.get_global_name(), "SettingsOverlay", "SettingsOverlay.gd should have class_name SettingsOverlay")

	var credits_script = load("res://src/scripts/CreditsOverlay.gd")
	assert_eq(credits_script.get_global_name(), "CreditsOverlay", "CreditsOverlay.gd should have class_name CreditsOverlay")

func test_course_card_has_class_name():
	var card_script = load("res://src/scripts/CourseCard.gd")
	assert_eq(card_script.get_global_name(), "CourseCard", "CourseCard.gd should have class_name CourseCard")
