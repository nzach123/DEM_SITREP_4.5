extends Node

"""
SettingsManager.gd
Manages game settings persistence and application (Audio, Display).
"""

const SETTINGS_PATH = "user://settings.cfg"

var _config := ConfigFile.new()

# Default Settings
var _settings = {
	"audio": {
		"Master": 1.0,
		"Music": 1.0,
		"SFX": 1.0
	},
	"display": {
		"window_mode": DisplayServer.WINDOW_MODE_WINDOWED
	}
}

func _ready() -> void:
	load_settings()
	_apply_all_settings()

func save_settings() -> void:
	for section in _settings.keys():
		for key in _settings[section].keys():
			_config.set_value(section, key, _settings[section][key])
	
	var err = _config.save(SETTINGS_PATH)
	if err != OK:
		push_error("Failed to save settings to %s. Error: %d" % [SETTINGS_PATH, err])

func load_settings() -> void:
	var err = _config.load(SETTINGS_PATH)
	if err != OK:
		# If file doesn't exist or is invalid, we use defaults
		return
	
	for section in _settings.keys():
		for key in _settings[section].keys():
			if _config.has_section_key(section, key):
				_settings[section][key] = _config.get_value(section, key)
	
	_apply_all_settings()

func set_volume(bus_name: String, volume_linear: float) -> void:
	if _settings["audio"].has(bus_name):
		_settings["audio"][bus_name] = clamp(volume_linear, 0.0, 1.0)
		_apply_audio_setting(bus_name)

func get_volume(bus_name: String) -> float:
	return _settings["audio"].get(bus_name, 1.0)

func set_window_mode(mode: DisplayServer.WindowMode) -> void:
	_settings["display"]["window_mode"] = mode
	_apply_display_settings()

func get_window_mode() -> DisplayServer.WindowMode:
	return _settings["display"]["window_mode"]

func _apply_all_settings() -> void:
	for bus in _settings["audio"].keys():
		_apply_audio_setting(bus)
	_apply_display_settings()

func _apply_audio_setting(bus_name: String) -> void:
	var bus_index = AudioServer.get_bus_index(bus_name)
	if bus_index != -1:
		# Convert linear volume (0.0 to 1.0) to decibels
		var db = linear_to_db(_settings["audio"][bus_name])
		AudioServer.set_bus_volume_db(bus_index, db)
		AudioServer.set_bus_mute(bus_index, _settings["audio"][bus_name] <= 0.001)

func _apply_display_settings() -> void:
	DisplayServer.window_set_mode(_settings["display"]["window_mode"])

func reset_to_defaults() -> void:
	_settings = {
		"audio": {
			"Master": 1.0,
			"Music": 1.0,
			"SFX": 1.0
		},
		"display": {
			"window_mode": DisplayServer.WINDOW_MODE_WINDOWED
		}
	}
	_apply_all_settings()
