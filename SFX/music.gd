extends Node

const menu_music = preload("res://SFX/MenuMusic.wav")
const game_music = preload("res://SFX/GameMusic.wav")
const win_jingle = preload("res://SFX/WinJingle.wav")
const lose_jingle = preload("res://SFX/LoseJingle.wav")

@onready var musicPlayer = $Player
@onready var jinglePlayer = $Jingle

func _ready():
	jinglePlayer.finished.connect(_on_jingle_finished)

@export var jingle = "None":
	set(value):
		jingle = value
		match jingle:
			"None":
				jinglePlayer.stop()
			"Win":
				musicPlayer.stream_paused = true
				jinglePlayer.stream = win_jingle
				jinglePlayer.play()
			"Lose":
				musicPlayer.stream_paused = true
				jinglePlayer.stream = lose_jingle
				jinglePlayer.play()
			_:
				jinglePlayer.stop()

func _on_jingle_finished():
	musicPlayer.stream_paused = false

@export var music_on = true:
	set(value):
		music_on = value
		if not music_on:
			musicPlayer.stop()
		else:
			musicPlayer.play()

@export var music_playing = "None":
	set(value):
		music_playing = value
		match music_playing:
			"None":
				musicPlayer.stop()
			"Menu":
				musicPlayer.stream = menu_music
				musicPlayer.play()
			"Game":
				musicPlayer.stream = game_music
				musicPlayer.play()
			_:
				musicPlayer.stop()
