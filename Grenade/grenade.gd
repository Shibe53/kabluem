extends RigidBody2D
class_name Grenade
# Experimenting with RigidBody2D

# Linear damp applies air resistance
@export var max_velocity := 1000 # TODO doesn't actually cap the velocity yet. Its kinda awkwardly implemented within Player
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer
@onready var cpu_particles_2d_2 = $CPUParticles2D2

# Called when the node enters the scene tree for the first time.
func _ready():
	resize(0.4)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Slows down the flying animation based on current velocity
	animated_sprite_2d.speed_scale = linear_velocity.length() / max_velocity

func _on_body_entered(body):
	if is_instance_of(body, Enemy):
		exuplode()
		
func exuplode():
	animation_player.play("Exuplode")

func resize(new_size):
	for child in get_children():
		if is_instance_of(child, Node2D):
			child.scale.x = new_size
			child.scale.y = new_size
