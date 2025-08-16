extends Area2D

var canEnd = false

func _on_area_entered(area: Area2D) -> void:
	if canEnd:
		area.get_parent().global_position = self.global_position
		area.get_parent().burrow()
