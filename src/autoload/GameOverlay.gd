extends CanvasLayer
## GameOverlay: Persistent UI layer for global UI elements (PauseMenu, etc.)
## Lives above scene content (layer 99) but below CRT post-process (layer 100).

signal pause_menu_closed

const PAUSE_MENU_SCENE: PackedScene = preload("res://src/scenes/PauseMenu.tscn")

var _pause_menu: PauseMenu = null

func _ready() -> void:
	layer = 99
	process_mode = Node.PROCESS_MODE_ALWAYS
	GameManager.pause_toggled.connect(_on_pause_toggled)

func _on_pause_toggled(is_paused: bool) -> void:
	if is_paused:
		_show_pause_menu()
	else:
		_hide_pause_menu()

func _show_pause_menu() -> void:
	if _pause_menu != null:
		return
	_pause_menu = PAUSE_MENU_SCENE.instantiate()
	_pause_menu.resume_requested.connect(_on_resume_requested)
	_pause_menu.restart_requested.connect(_on_restart_requested)
	_pause_menu.main_menu_requested.connect(_on_main_menu_requested)
	_pause_menu.quit_requested.connect(_on_quit_requested)
	add_child(_pause_menu)
	_pause_menu.open_menu()

func _hide_pause_menu() -> void:
	if _pause_menu:
		_pause_menu.close_menu()
		_pause_menu = null
		pause_menu_closed.emit()

func _on_resume_requested() -> void:
	GameManager.toggle_pause()

func _on_restart_requested() -> void:
	GameManager.restart_level()

func _on_main_menu_requested() -> void:
	GameManager.quit_to_main()

func _on_quit_requested() -> void:
	get_tree().quit()
