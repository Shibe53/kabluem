extends Area2D

@onready var collisionShape = $CollisionShape2D

var player = null

func can_see_player():
	return player != null

func _on_body_entered(body):
	player = body

func _on_body_exited(_body):
	player = null

func change_range(newRange):
	collisionShape.shape.radius = newRange
