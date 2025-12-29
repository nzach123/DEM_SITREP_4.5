class_name AnimationComponent extends Node

@export var from_center : bool = true
@export var hover_scale : Vector2 = Vector2(1,1)
@export var time : float = 0.1
@export var transition_type : Tween.TransitionType = Tween.TRANS_SINE

@export_group("Audio")
@export var hover_sfx : AudioStream
@export var click_sfx : AudioStream

var target : Control
var default_scale : Vector2
var _audio_player : AudioStreamPlayer

func _ready() -> void:
	target = get_parent()
	
	_audio_player = AudioStreamPlayer.new()
	_audio_player.bus = &"SFX"
	add_child(_audio_player)
	
	connect_signals()
	call_deferred("setup")
	
func connect_signals() -> void:
	target.mouse_entered.connect(on_hover)
	target.mouse_exited.connect(off_hover)
	if target is Button:
		target.pressed.connect(on_pressed)

func setup() -> void:
	if from_center:
		target.pivot_offset = target.size /2
	default_scale = target.scale


func on_hover() -> void:
	add_tween("scale", hover_scale, time)
	if hover_sfx:
		_audio_player.stream = hover_sfx
		_audio_player.play()
	
func  off_hover() -> void:
	add_tween("scale", default_scale, time)

func on_pressed() -> void:
	if click_sfx:
		_audio_player.stream = click_sfx
		_audio_player.play()
	
func add_tween(property: String, value, seconds: float) -> void:
	if not is_instance_valid(target):
		push_warning("AnimationComponent: Target is null/invalid")
		return
	var tween = target.create_tween()
	tween.tween_property(target, property, value, seconds).set_trans(transition_type)
