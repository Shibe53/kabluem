extends Control

@onready var audioPlayer = Music.get_node("Player")
@onready var animationPlayer = $AnimationPlayer
@onready var resumeButton = $CenterContainer/HBoxContainer/Resume
@onready var restartButton = $CenterContainer/HBoxContainer/Restart
@onready var quitButton = $CenterContainer/HBoxContainer/Quit
@onready var label = $Label

func resume():
	turn_off_buttons()
	animationPlayer.play("Close")

func pause():
	get_tree().paused = true
	animationPlayer.play("Open")

func restart():
	get_tree().paused = false
	LevelSelect.level = LevelSelect.current_level

func turn_on_buttons():
	restartButton.disabled = false
	resumeButton.disabled = false
	quitButton.disabled = false
	restartButton.visible = true
	resumeButton.visible = true
	quitButton.visible = true
	label.visible = true

func turn_off_buttons():
	label.visible = false
	restartButton.visible = false
	resumeButton.visible = false
	quitButton.visible = false
	restartButton.disabled = true
	resumeButton.disabled = true
	quitButton.disabled = true

func _ready() -> void:
	turn_off_buttons()
	animationPlayer.play("RESET")

func _process(_delta):
	if Input.is_action_just_pressed("pause") and not get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("pause") and get_tree().paused:
		resume()

func _on_resume_pressed() -> void:
	resume()

func _on_restart_pressed() -> void:
	restart()

func _on_quit_pressed() -> void:
	audioPlayer.stop()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://UI/main_menu.tscn")

func _on_open_anim_finished():
	turn_on_buttons()

func _on_close_anim_finished():
	get_tree().paused = false
