extends Node

const game_music = preload("res://SFX/MenuMusic.wav")
const level1 = preload("res://Levels/level1.tscn")
const level2 = preload("res://Levels/level2.tscn")
const level3 = preload("res://Levels/level3.tscn")
const level4 = preload("res://Levels/level4.tscn")
const level5 = preload("res://Levels/level5.tscn")
const level6 = preload("res://Levels/level6.tscn")
const level7 = preload("res://Levels/level7.tscn")
const level8 = preload("res://Levels/level8.tscn")
const level9 = preload("res://Levels/level9.tscn")
const level10 = preload("res://Levels/level10.tscn")
const level11 = preload("res://Levels/level11.tscn")
const level12 = preload("res://Levels/level12.tscn")
const level13 = preload("res://Levels/level13.tscn")
const level14 = preload("res://Levels/level14.tscn")
const level15 = preload("res://Levels/level15.tscn")

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
		enemies = 0
		
		match level:
			1:
				call_deferred("change_scene", level1)
			2:
				call_deferred("change_scene", level2)
			3:
				call_deferred("change_scene", level3)
			4:
				call_deferred("change_scene", level4)
			5:
				call_deferred("change_scene", level5)
			6:
				call_deferred("change_scene", level6)
			7:
				call_deferred("change_scene", level7)
			8:
				call_deferred("change_scene", level8)
			9:
				call_deferred("change_scene", level9)
			10:
				call_deferred("change_scene", level10)
			11:
				call_deferred("change_scene", level11)
			12:
				call_deferred("change_scene", level12)
			13:
				call_deferred("change_scene", level13)
			14:
				call_deferred("change_scene", level14)
			15:
				call_deferred("change_scene", level15)
			_:
				call_deferred("change_scene", level1)

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

func change_scene(scene : PackedScene):
	get_tree().change_scene_to_packed(scene)

func play_game_music():
	audioPlayer.stream = game_music
	audioPlayer.play()
