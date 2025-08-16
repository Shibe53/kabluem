extends Control

var buttons : Array = []

func _ready():
	buttons = get_tree().get_nodes_in_group("level_buttons")
	for button in buttons:
		var index = buttons.find(button)
		button.mouse_entered.connect(_on_button_mouse_entered.bind(button))
		button.mouse_exited.connect(_on_button_mouse_exited.bind(button))
		button.pressed.connect(_on_button_pressed.bind(index))
		if index + 1 <= LevelSelect.latest_level:
			button.get_node("CenterContainer").get_node("Label").text = str(index + 1)
		else:
			button.get_node("CenterContainer").get_node("Label").text = "X"

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		go_back()

func _on_button_pressed(index):
	if index + 1 <= LevelSelect.latest_level:
		LevelSelect.level = index + 1

func _on_button_mouse_entered(button):
	button.get_node("CenterContainer/Label").label_settings.font_color = Color(0.678, 0.765, 0.91, 1.0)

func _on_button_mouse_exited(button):
	button.get_node("CenterContainer/Label").label_settings.font_color = Color(0.055, 0.118, 0.369, 1.0)

func _on_back_button_pressed() -> void:
	go_back()

func go_back():
	get_tree().change_scene_to_file("res://UI/main_menu.tscn")
