extends Node2D

@onready var timer = $Timer

var TARGET = Vector2.ZERO
var SPEED = 0
var ACCELERATION = 0
var direction = Vector2.ZERO

func _ready():
	direction = global_position.direction_to(TARGET)
	timer.start(5)

func _process(delta: float) -> void:
	self.position = position.move_toward(direction * SPEED, ACCELERATION  * delta)
	
func set_values(point, speed, acceleration):
	TARGET = point
	SPEED = speed
	ACCELERATION = acceleration

func _on_hitbox_area_entered(area: Area2D) -> void:
	queue_free()

func _on_timer_timeout() -> void:
	queue_free()
