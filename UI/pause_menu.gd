extends Control

@onready var animationPlayer = $AnimationPlayer
@onready var resumeButton = $Resume
@onready var restartButton = $Restart
@onready var quitButton = $Quit
@onready var label = $Label

func resume():
	turn_off_buttons()
	animationPlayer.play("Close")

func pause():
	get_tree().paused = true
	animationPlayer.play("Open")

func restart():
	pass

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

func _on_open_anim_finished():
	turn_on_buttons()

func _on_close_anim_finished():
	get_tree().paused = false
