extends Control

@onready var animationPlayer = $AnimationPlayer

func resume():
	get_tree().paused = false
	animationPlayer.play("Close")

func pause():
	get_tree().paused = true
	animationPlayer.play("Open")

func _ready() -> void:
	animationPlayer.play("RESET")

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel") and not get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("ui_cancel") and get_tree().paused:
		resume()
