extends StaticBody2D

@export var breakable = false

func _on_hurtbox_area_entered(area):
	if breakable:
		queue_free()
