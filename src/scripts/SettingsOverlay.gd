class_name SettingsOverlay
extends Panel

signal close_requested

@export var master_slider: HSlider
@export var music_slider: HSlider
@export var sfx_slider: HSlider

@export var resolution_option: OptionButton
@export var window_mode_option: OptionButton
@export var apply_button: Button
@export var back_button: Button

# Standard 16:9 Resolutions
const RESOLUTIONS: Array[Vector2i] = [
	Vector2i(1280, 720),
	Vector2i(1366, 768),
	Vector2i(1600, 900),
	Vector2i(1920, 1080),
	Vector2i(2560, 1440),
	Vector2i(3840, 2160)
]

# Map dropdown index to WindowMode
var _window_modes: Array[Dictionary] = [
	{ "name": "Windowed", "value": DisplayServer.WINDOW_MODE_WINDOWED },
	{ "name": "Borderless Fullscreen", "value": DisplayServer.WINDOW_MODE_FULLSCREEN },
	{ "name": "Exclusive Fullscreen", "value": DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN }
]

var _pending_resolution: Vector2i
var _pending_mode: DisplayServer.WindowMode = DisplayServer.WINDOW_MODE_WINDOWED

func _ready() -> void:
	if back_button:
		back_button.pressed.connect(_on_back_pressed)
	
	if apply_button:
		apply_button.pressed.connect(_on_apply_pressed)

	if master_slider:
		master_slider.value_changed.connect(func(v): _on_volume_changed("Master", v))
	if music_slider:
		music_slider.value_changed.connect(func(v): _on_volume_changed("Music", v))
	if sfx_slider:
		sfx_slider.value_changed.connect(func(v): _on_volume_changed("SFX", v))
	
	_populate_resolutions()
	_populate_window_modes()
	
	if resolution_option:
		resolution_option.item_selected.connect(_on_resolution_selected)
	if window_mode_option:
		window_mode_option.item_selected.connect(_on_window_mode_selected)

	hide() # Start hidden

func open_menu() -> void:
	show()
	_refresh_ui()
	if back_button:
		back_button.grab_focus()

func _refresh_ui() -> void:
	# Audio (Instant)
	if master_slider: master_slider.value = SettingsManager.get_volume("Master")
	if music_slider: music_slider.value = SettingsManager.get_volume("Music")
	if sfx_slider: sfx_slider.value = SettingsManager.get_volume("SFX")
	
	# Display (Staged)
	var current_res = SettingsManager.get_resolution()
	var current_mode = SettingsManager.get_window_mode()
	
	_pending_resolution = current_res
	_pending_mode = current_mode
	
	_select_resolution_option(current_res)
	_select_window_mode_option(current_mode)
	
	# Handle unsupported environments (e.g., Editor)
	if resolution_option:
		var supported = SettingsManager.is_resolution_supported()
		resolution_option.disabled = not supported
		if not supported:
			resolution_option.tooltip_text = "Resolution locked in this mode/environment."
		else:
			resolution_option.tooltip_text = ""

func _populate_resolutions() -> void:
	if not resolution_option: return
	resolution_option.clear()
	for i in range(RESOLUTIONS.size()):
		var res = RESOLUTIONS[i]
		resolution_option.add_item("%dx%d" % [res.x, res.y], i)

func _populate_window_modes() -> void:
	if not window_mode_option: return
	window_mode_option.clear()
	for i in range(_window_modes.size()):
		window_mode_option.add_item(_window_modes[i]["name"], i)

func _select_resolution_option(res: Vector2i) -> void:
	if not resolution_option: return
	var idx = RESOLUTIONS.find(res)
	if idx != -1:
		resolution_option.selected = idx
	else:
		# If custom resolution not in list, maybe add it momentarily or select closest?
		# For now, default to 0 (1280x720) if not found
		resolution_option.selected = 0
		_pending_resolution = RESOLUTIONS[0]

func _select_window_mode_option(mode: DisplayServer.WindowMode) -> void:
	if not window_mode_option: return
	for i in range(_window_modes.size()):
		if _window_modes[i]["value"] == mode:
			window_mode_option.selected = i
			return
	# Default to Windowed if unknown
	window_mode_option.selected = 0
	_pending_mode = DisplayServer.WINDOW_MODE_WINDOWED

func _on_resolution_selected(index: int) -> void:
	if index >= 0 and index < RESOLUTIONS.size():
		_pending_resolution = RESOLUTIONS[index]

func _on_window_mode_selected(index: int) -> void:
	if index >= 0 and index < _window_modes.size():
		_pending_mode = _window_modes[index]["value"]

func _on_volume_changed(bus: String, value: float) -> void:
	SettingsManager.set_volume(bus, value)

func _on_apply_pressed() -> void:
	SettingsManager.set_resolution(_pending_resolution)
	SettingsManager.set_window_mode(_pending_mode)
	SettingsManager.apply_display_settings()
	SettingsManager.save_settings()

func _on_back_pressed() -> void:
	hide()
	close_requested.emit()