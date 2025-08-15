extends CharacterBody2D

@onready var timer = $Timer
@onready var hitbox = $Hitbox

var SPEED = 0
var DAMAGE = 0
var direction = Vector2.ZERO

func _ready():
	hitbox.damage = DAMAGE
	timer.start(5)

func _physics_process(delta: float) -> void:
	velocity = direction * SPEED * delta
	var collision = move_and_collide(velocity)
	if collision:
		queue_free()

func set_values(point, speed, damage):
	direction = global_position.direction_to(point)
	SPEED = speed
	DAMAGE = damage

func _on_hitbox_area_entered(_area: Area2D) -> void:
	queue_free()

func _on_timer_timeout() -> void:
	queue_free()
