extends Control

@export var load_scene : PackedScene

@onready var label = $Label
@onready var animation = $AnimationPlayer

var wait_input = false
var explode = false

func _ready() -> void:
	wait_input = true
	animation.play("rotate")

func _input(event):
	if (event is InputEventKey or event is InputEventMouseButton) and event.pressed and wait_input:
		explode = true
		label.visible = false

func _on_rotate_end():
	if explode:
		end_animation()

func end_animation():
	wait_input = false
	animation.play("explode")

func _on_explode_finished():
	get_tree().change_scene_to_packed(load_scene)
