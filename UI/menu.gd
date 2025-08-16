extends Control

const menu_music = preload("res://SFX/MenuMusic.wav")

@onready var audioPlayer = Music.get_node("Player")

func _ready():
	if not audioPlayer.is_playing():
		audioPlayer.stream = menu_music
		audioPlayer.play()

func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/level1.tscn")
