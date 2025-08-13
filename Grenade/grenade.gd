extends RigidBody2D
class_name Grenade
# Experimenting with RigidBody2D

# Linear damp applies air resistance TDOD: this just makes it slippery, needs to be quadratic not linear
@export var scale_workaround := 1.0
@export var max_velocity := 1000 # TODO doesn't actually cap the velocity yet. Its kinda awkwardly implemented within Player

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer
@onready var cpu_particles_2d_2 = $CPUParticles2D2
@onready var hitbox = $Hitbox

# Called when the node enters the scene tree for the first time.
func _ready():
	print(global_position, position)
	print(hitbox.global_position, position)
	resize(scale_workaround)
	print(global_position, position)
	print(hitbox.global_position, position)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Slows down the flying animation based on current velocity
	animated_sprite_2d.speed_scale = linear_velocity.length() / max_velocity

func _on_body_entered(body):
	if is_instance_of(body, Enemy):
		exuplode()
		
# Both timer and enemy collision triggers this
func exuplode():
	animation_player.play("Exuplode")

# so turns out you can't change the scale of RigidBody2D so you just have to change its children
# This has been a learning opportinity to not use that node just for
# "shits and giggles, it's bouncing is gonna be so much funnier"
func resize(new_size: float):
	for child in get_children():
		if is_instance_of(child, Node2D):
			child.scale.x = new_size
			child.scale.y = new_size
	if cpu_particles_2d_2:
		cpu_particles_2d_2.scale_amount_min = new_size
		cpu_particles_2d_2.scale_amount_max = new_size

func _on_hitbox_body_entered(body):
	if is_instance_of(body, Floor):
		var col_shape = hitbox.get_node_or_null("CollisionShape")
		body.bloom(col_shape)
