extends Node

const main_menu = preload("res://UI/main_menu.tscn")
const level1 = preload("res://Levels/Bloom_tutorial.tscn")
const level2 = preload("res://Levels/Enemy_tutorial.tscn")
const level3 = preload("res://Levels/Dodge_tutorial.tscn")
const level4 = preload("res://Levels/Easy_level1.tscn")
const level5 = preload("res://Levels/Easy_level2.tscn")
const level6 = preload("res://Levels/Bounce_practice.tscn")
const level7 = preload("res://Levels/Easy_level3.tscn")
const level8 = preload("res://Levels/Greater_vegan_intro.tscn")
const level9 = preload("res://Levels/Mid_level1.tscn")
const level10 = preload("res://Levels/Bullet_hell.tscn")
const level11 = preload("res://Levels/Mid_level2.tscn")
const level12 = preload("res://Levels/Mid_level3.tscn")
const level13 = preload("res://Levels/Minibossfight.tscn")
const level14 = preload("res://Levels/BigRoom.tscn")
const level15 = preload("res://Levels/Bossfight.tscn")

signal bloom_changed(value)
signal room_bloomed
signal no_enemies_left

@onready var audioPlayer = Music.get_node("Player")

var bloomed = false
var music_playing = false
var latest_level = 1
var current_level = 1
var max_level = 12

@export var end = false:
	set(value):
		end = value
		if end:
			if level == latest_level and latest_level < max_level:
				latest_level += 1
			level += 1

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
			_:
				call_deferred("change_scene", main_menu)

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
			if enemies == 0:
				emit_signal("no_enemies_left")

@onready var enemies = 0:
	set(value):
		enemies = value
		if enemies == 0 and bloomed:
			emit_signal("no_enemies_left")

func change_scene(scene : PackedScene):
	get_tree().change_scene_to_packed(scene)
	if not Music.music_playing == "Game":
		Music.music_playing = "Game"

func _process(_delta):
	if Input.is_action_just_pressed("skip_level"):
		end = true
