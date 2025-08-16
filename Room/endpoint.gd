extends Area2D

var canEnd = false

func _on_area_entered(area: Area2D) -> void:
	if canEnd:
		LevelSelect.end = true
