extends Control

func _ready():
	if not Music.music_playing == "Menu":
		Music.music_playing = "Menu"

func _process(_delta):
	if Input.is_action_just_pressed("unlock"):
		LevelSelect.latest_level = 15

func _on_texture_button_pressed() -> void:
	LevelSelect.level = LevelSelect.latest_level

func _on_texture_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/level_select_screen.tscn")

func _on_texture_button_3_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/settings_menu.tscn")
