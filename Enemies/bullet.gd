extends CharacterBody2D
class_name BulletEntity

@onready var timer = $Timer
@onready var hitbox = $Hitbox

var SPEED = 0
var DAMAGE = 0
var SCALE = 0
var direction = Vector2.ZERO

func _ready():
	hitbox.damage = DAMAGE
	self.scale = Vector2(SCALE, SCALE)
	timer.start(5)

func _physics_process(delta: float) -> void:
	velocity = direction * SPEED * delta
	var collision = move_and_collide(velocity)
	if collision:
		queue_free()

func set_values(point, speed, damage, dimension):
	direction = global_position.direction_to(point)
	SPEED = speed
	DAMAGE = damage
	SCALE = dimension

func _on_hitbox_area_entered(area: Area2D) -> void:
	if is_instance_of(area, Hurtbox):
		return
	queue_free()

func _on_timer_timeout() -> void:
	queue_free()
