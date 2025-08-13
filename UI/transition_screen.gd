extends Control

@export var load_scene : PackedScene

var wait_input = false

func _ready() -> void:
	start_animation()

func start_animation():
	wait_input = true

func _input(event):
	if (event is InputEventKey or event is InputEventMouseButton) and event.pressed and wait_input:
		end_animation()

func end_animation():
	get_tree().change_scene_to_packed(load_scene)
