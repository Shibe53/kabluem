extends Node

const menu_music = preload("res://SFX/MenuMusic.wav")
const game_music = preload("res://SFX/GameMusic.wav")
const win_jingle = preload("res://SFX/WinJingle.wav")
const lose_jingle = preload("res://SFX/LoseJingle.wav")

@onready var musicPlayer = $Player
@onready var jinglePlayer = $Jingle

func _ready():
	jinglePlayer.finished.connect(_on_jingle_finished)

@export var volume = 0.8:
	set(value):
		volume = value
		for player in get_children():
			player.volume_db = linear_to_db(volume)

@export var jingle = "None":
	set(value):
		jingle = value
		match jingle:
			"None":
				jinglePlayer.stop()
			"Win":
				musicPlayer.volume_db -= 5.0
				jinglePlayer.stream = win_jingle
				jinglePlayer.play()
			"Lose":
				musicPlayer.volume_db -= 5.0
				jinglePlayer.stream = lose_jingle
				jinglePlayer.play()
			_:
				jinglePlayer.stop()

func _on_jingle_finished():
	musicPlayer.volume_db += 5.0

@export var music_playing = "None":
	set(value):
		music_playing = value
		match music_playing:
			"None":
				musicPlayer.stop()
			"Menu":
				musicPlayer.volume_db = -5.0
				musicPlayer.stream = menu_music
				musicPlayer.play()
			"Game":
				musicPlayer.volume_db = -10.0
				musicPlayer.stream = game_music
				musicPlayer.play()
			_:
				musicPlayer.stop()

func play_sfx(stream: AudioStream, position: Vector2 = Vector2.ZERO):
	var player = AudioStreamPlayer2D.new()
	add_child(player)
	player.volume_db = linear_to_db(volume) - 2.0
	player.stream = stream
	player.position = position
	player.play()
	player.finished.connect(func():
		player.queue_free())
