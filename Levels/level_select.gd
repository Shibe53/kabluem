extends Node

const game_music = preload("res://SFX/MenuMusic.wav")

signal bloom_changed(value)
signal room_bloomed
signal no_enemies_left

@onready var audioPlayer = Music.get_node("Player")

var bloomed = false
var music_playing = false
var latest_level = 1
var current_level = 1

@export var end = false:
	set(value):
		end = value
		if end:
			level += 1
			latest_level += 1

@onready var level = 1:
	set(value):
		level = value
		current_level = level
		bloomed = false
		end = false
		bloom = 0
		
		match level:
			1:
				call_deferred("change_scene", "res://Levels/level1.tscn")
			2:
				call_deferred("change_scene", "res://Levels/level2.tscn")
			3:
				pass
			4:
				pass
			5:
				pass
			6:
				pass
			7:
				pass
			8:
				pass
			9:
				pass
			10:
				pass
			11:
				pass
			12:
				pass
			13:
				pass
			14:
				pass
			15:
				pass

@onready var bloom_needed = 80:
	set(value):
		bloom_needed = value

@onready var bloom = 0:
	set(value):
		bloom = value
		emit_signal("bloom_changed", bloom)
		if bloom >= bloom_needed:
			emit_signal("room_bloomed")
			bloomed = true

@onready var enemies = 0:
	set(value):
		enemies = value
		if enemies == 0 and bloomed:
			emit_signal("no_enemies_left")

func change_scene(path : String):
	get_tree().change_scene_to_file(path)

func play_game_music():
	audioPlayer.stream = game_music
	audioPlayer.play()
