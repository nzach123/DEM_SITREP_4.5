extends GutTest

func test_main_menu_is_in_group():
	var main_menu = load("res://src/scenes/MainMenu.tscn").instantiate()
	add_child_autofree(main_menu)
	assert_true(main_menu.is_in_group("main_menu"), "MainMenu should be in 'main_menu' group")
