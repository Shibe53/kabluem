extends Control

const sound_icon = preload("res://Assets/Sprites/sound_icon.png")
const sound_icon_pressed = preload("res://Assets/Sprites/sound_icon_pressed.png")
const muted_icon = preload("res://Assets/Sprites/sound_icon_muted.png")
const muted_icon_pressed = preload("res://Assets/Sprites/sound_icon_muted_pressed.png")

@onready var audioButton = $CenterContainer2/VBoxContainer/HBoxContainer/TextureButton
@onready var unlockButton = $CenterContainer2/VBoxContainer/HBoxContainer2/CheckButton
@onready var easyButton = $CenterContainer2/VBoxContainer/HBoxContainer3/CheckButton
@onready var volumeSlider = $CenterContainer2/VBoxContainer/HBoxContainer/CenterContainer/HSlider

var save_latest_level = 1
var pressed = false
var old_value = 0.0

func _ready():
	update_textures()
	unlockButton.button_pressed = LevelSelect.latest_level == LevelSelect.max_level
	easyButton.button_pressed = PlayerStats.max_health != 3

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		go_back()

func _on_back_button_pressed() -> void:
	go_back()

func go_back():
	get_tree().change_scene_to_file("res://UI/main_menu.tscn")

func _on_texture_button_pressed() -> void:
	if old_value == 0.0:
		old_value = volumeSlider.value
		volumeSlider.value = 0.0
	else:
		volumeSlider.value = old_value
		old_value = 0.0

func update_textures():
	if Music.volume == 0.0:
		audioButton.texture_normal = muted_icon
		audioButton.texture_pressed = muted_icon_pressed
		audioButton.texture_hover = muted_icon_pressed
	else:
		audioButton.texture_normal = sound_icon
		audioButton.texture_pressed = sound_icon_pressed
		audioButton.texture_hover = sound_icon_pressed

func _on_check_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		save_latest_level = LevelSelect.latest_level
		LevelSelect.latest_level = LevelSelect.max_level
	else:
		LevelSelect.latest_level = save_latest_level

func _on_h_slider_value_changed(value: float) -> void:
	Music.volume = value
	update_textures()

func _on_easy_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		PlayerStats.max_health = 6
	else:
		PlayerStats.max_health = 3
