extends "res://addons/gut/test.gd"

var AARScreenScene = preload("res://src/scenes/AARScreen.tscn")
var _aar_screen = null

func before_each():
	_aar_screen = AARScreenScene.instantiate()
	add_child_autofree(_aar_screen)

func test_buttons_exist():
	assert_not_null(_aar_screen.retry_button, "Retry button should exist")
	assert_not_null(_aar_screen.menu_button, "Menu button should exist")

func test_buttons_layout_flags():
	# Current state: they are likely NOT EXPAND_FILL because of the wrapper logic
	# We want them to be SIZE_EXPAND_FILL (3)
	assert_eq(_aar_screen.retry_button.size_flags_horizontal, Control.SIZE_EXPAND_FILL, "Retry button should have expand fill flags")
	assert_eq(_aar_screen.menu_button.size_flags_horizontal, Control.SIZE_EXPAND_FILL, "Menu button should have expand fill flags")

func test_no_wrappers_at_runtime():
	# This test should FAIL currently because _ready adds wrappers
	# wait a frame for _ready
	await wait_frames(1)
	
	var retry_parent = _aar_screen.retry_button.get_parent()
	var menu_parent = _aar_screen.menu_button.get_parent()
	
	# In the broken state, the parent will be a 'Control' named '*_Wrapper'
	assert_ne(retry_parent.name, "RetryButton_Wrapper", "Retry button should not be inside a wrapper")
	assert_ne(menu_parent.name, "MenuButton_Wrapper", "Menu button should not be inside a wrapper")
	
	# They should both be direct children of the ControlVBox
	var control_vbox = _aar_screen.get_node("MarginContainer/MainVBox/TopRowHBox/ControlPanel/ControlVBox")
	assert_eq(retry_parent, control_vbox, "Retry button parent should be ControlVBox")
	assert_eq(menu_parent, control_vbox, "Menu button parent should be ControlVBox")

func test_buttons_have_animation_component():
	var retry_anim = _aar_screen.retry_button.get_node_or_null("AnimationComponent")
	var menu_anim = _aar_screen.menu_button.get_node_or_null("AnimationComponent")
	
	assert_not_null(retry_anim, "Retry button should have AnimationComponent")
	assert_not_null(menu_anim, "Menu button should have AnimationComponent")
	
	if retry_anim:
		assert_eq(retry_anim.hover_scale, Vector2(1.05, 1.05), "Retry button should have hover scale 1.05")
		assert_not_null(retry_anim.hover_sfx, "Retry button should have hover sfx")
		assert_not_null(retry_anim.click_sfx, "Retry button should have click sfx")
