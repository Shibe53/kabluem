extends Node

@export var end = false:
	set(value):
		end = value
		if end:
			level += 1

@onready var level = 1:
	set(value):
		level = value
		end = false
		match level:
			1:
				call_deferred("change_scene", "res://Levels/level1.tscn")
			2:
				call_deferred("change_scene", "res://Levels/level2.tscn")
			3:
				pass

func change_scene(path : String):
	get_tree().change_scene_to_file(path)
