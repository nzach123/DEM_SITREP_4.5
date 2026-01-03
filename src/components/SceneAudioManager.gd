class_name SceneAudioManager
extends Node
@export var sfx_stream: AudioStream
@export var music_stream: AudioStream
@export var play_music_on_start: bool = true
@export var play_sfx_on_start: bool = true
var _music_player: AudioStreamPlayer
var _sfx_player: AudioStreamPlayer

func _ready() -> void:
	_create_players()
	
	if play_music_on_start and music_stream:
		play_music(music_stream)
	if play_sfx_on_start and sfx_stream:
		play_sfx(sfx_stream)

func _create_players() -> void:
	if not _music_player:
		_music_player = AudioStreamPlayer.new()
		_music_player.name = "MusicPlayer"
		_music_player.bus = "Music"
		add_child(_music_player)
		
	if not _sfx_player:
		_sfx_player = AudioStreamPlayer.new()
		_sfx_player.name = "SFXPlayer"
		_sfx_player.bus = "SFX"
		add_child(_sfx_player)

func play_music(stream: AudioStream) -> void:
	if not _music_player:
		_create_players()
		
	if _music_player.stream == stream and _music_player.playing:
		return
		
	_music_player.stream = stream
	_music_player.volume_db = -12.0
	_music_player.play()

func play_sfx(stream: AudioStream) -> void:
	if not stream: return
	if not _sfx_player:
		_create_players()
	
	_sfx_player.stream = stream
	_sfx_player.play()
