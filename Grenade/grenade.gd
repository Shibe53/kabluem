extends RigidBody2D
class_name Grenade
# Experimenting with RigidBody2D

# Linear damp applies air resistance
@export var max_velocity := 1000
@onready var animated_sprite_2d = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Slows down the flying animation based on current velocity
	animated_sprite_2d.speed_scale = linear_velocity.length() / max_velocity

func _on_body_entered(body):
	if is_instance_of(body, Enemy):
		exuplode()
		
func exuplode():
	pass
	queue_free()
