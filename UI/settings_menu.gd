extends Control

func _ready():
	pass

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		go_back()

func _on_back_button_pressed() -> void:
	go_back()

func go_back():
	get_tree().change_scene_to_file("res://UI/main_menu.tscn")
