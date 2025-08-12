extends Node2D

@onready var timer = $Timer
@onready var hitbox = $Hitbox

var SPEED = 0
var DAMAGE = 0
var direction = Vector2.ZERO

func _ready():
	hitbox.damage = DAMAGE
	timer.start(5)

func _process(delta: float) -> void:
	self.position += direction * SPEED * delta
	
func set_values(point, speed, damage):
	direction = global_position.direction_to(point)
	SPEED = speed
	DAMAGE = damage

func _on_hitbox_area_entered(area: Area2D) -> void:
	queue_free()

func _on_timer_timeout() -> void:
	queue_free()
