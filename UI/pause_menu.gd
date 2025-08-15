extends Control

@onready var animationPlayer = $AnimationPlayer
@onready var resumeButton = $Resume
@onready var restartButton = $Restart
@onready var quitButton = $Quit

func resume():
	get_tree().paused = false
	animationPlayer.play("Close")

func pause():
	get_tree().paused = true
	animationPlayer.play("Open")

func restart():
	pass

func _ready() -> void:
	animationPlayer.play("RESET")

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel") and not get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("ui_cancel") and get_tree().paused:
		resume()

func _on_resume_pressed() -> void:
	resume()

func _on_restart_pressed() -> void:
	restart()

func _on_quit_pressed() -> void:
	get_tree().quit()
