extends Control

const sound_icon = preload("res://Assets/Sprites/sound_icon.png")
const sound_icon_pressed = preload("res://Assets/Sprites/sound_icon_pressed.png")
const muted_icon = preload("res://Assets/Sprites/sound_icon_muted.png")
const muted_icon_pressed = preload("res://Assets/Sprites/sound_icon_muted_pressed.png")

@onready var audioButton = $CenterContainer2/TextureButton

func _ready():
	update_textures()

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		go_back()

func _on_back_button_pressed() -> void:
	go_back()

func go_back():
	get_tree().change_scene_to_file("res://UI/main_menu.tscn")

func _on_texture_button_pressed() -> void:
	if Music.music_on:
		Music.music_on = false
		update_textures()
	else:
		Music.music_on = true
		update_textures()

func update_textures():
	if not Music.music_on:
		audioButton.texture_normal = muted_icon
		audioButton.texture_pressed = muted_icon_pressed
		audioButton.texture_hover = muted_icon_pressed
	else:
		audioButton.texture_normal = sound_icon
		audioButton.texture_pressed = sound_icon_pressed
		audioButton.texture_hover = sound_icon_pressed
