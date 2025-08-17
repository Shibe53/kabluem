extends Control

const menu_music = preload("res://SFX/MenuMusic.wav")

@onready var audioPlayer = Music.get_node("Player")

func _ready():
	if not audioPlayer.is_playing():
		audioPlayer.stream = menu_music
		audioPlayer.play()

func _process(_delta):
	if Input.is_action_just_pressed("unlock"):
		LevelSelect.latest_level = 15

func _on_texture_button_pressed() -> void:
	LevelSelect.level = LevelSelect.latest_level

func _on_texture_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/level_select_screen.tscn")
