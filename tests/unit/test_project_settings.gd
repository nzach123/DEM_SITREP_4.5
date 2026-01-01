extends "res://addons/gut/test.gd"

func test_rendering_settings():
	assert_eq(ProjectSettings.get_setting("rendering/renderer/rendering_method"), "gl_compatibility", "Rendering method should be gl_compatibility")
	assert_eq(ProjectSettings.get_setting("rendering/renderer/rendering_method.mobile"), "gl_compatibility", "Mobile rendering method should be gl_compatibility")
	assert_true(ProjectSettings.get_setting("rendering/textures/vram_compression/import_etc2_astc"), "VRAM compression ETC2/ASTC should be enabled")
