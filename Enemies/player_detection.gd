extends Area2D

@onready var collisionShape = $CollisionShape2D

var player = null

func can_see_player():
	return player != null

func change_detection_range(newRange : float):
	collisionShape.shape.radius = newRange

func _on_body_entered(body):
	player = body

func _on_body_exited(_body):
	player = null
