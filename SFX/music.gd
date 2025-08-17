extends Node

const menu_music = preload("res://SFX/MenuMusic.wav")
const game_music = preload("res://SFX/GameMusic.wav")

@onready var audioPlayer = $Player

@export var music_on = true:
	set(value):
		music_on = value
		if not music_on:
			audioPlayer.stop()
		else:
			audioPlayer.play()

@export var music_playing = "None":
	set(value):
		music_playing = value
		match music_playing:
			"None":
				audioPlayer.stop()
			"Menu":
				audioPlayer.stream = menu_music
				audioPlayer.play()
			"Game":
				audioPlayer.stream = game_music
				audioPlayer.play()
			_:
				audioPlayer.stop()
