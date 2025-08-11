extends CharacterBody2D

#const PlayerHurtSound = preload("res://Music and Sounds/player_hurt_sound.tscn")

@export var ACCELERATION = 800
@export var MAX_SPEED = 200
@export var DODGE_SPEED = 115
@export var FRICTION = 500

enum {
	MOVE,
	DODGE,
	THROW
}

var state = MOVE
var dodge_vector = Vector2.DOWN
var stats = PlayerStats
'''
@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")
@onready var swordHitbox = $HitboxPivot/SwordHitbox
@onready var hurtbox = $Hurtbox
@onready var blinkAnimationPlayer = $BlinkAnimationPlayer
'''
func _ready():
	randomize()
	stats.no_health.connect(queue_free)
#	animationTree.active = true

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		DODGE:
			dodge_state()
		THROW:
			throw_state()

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		dodge_vector = input_vector
#		animationTree.set("parameters/Idle/blend_position", input_vector)
#		animationTree.set("parameters/Run/blend_position", input_vector)
#		animationTree.set("parameters/Attack/blend_position", input_vector)
#		animationTree.set("parameters/Roll/blend_position", input_vector)
#		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
#		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	move_and_slide()
	
	if Input.is_action_just_pressed("dodge"):
		state = DODGE
	
	if Input.is_action_just_pressed("throw"):
		state = THROW

func throw_state():
	velocity = Vector2.ZERO
#	animationState.travel("Attack")

func throw_animation_finished():
	state = MOVE

func dodge_state():
	velocity = dodge_vector * DODGE_SPEED
#	animationState.travel("Roll")
	move_and_slide()
#	hurtbox.start_invincibility(0.15)

func dodge_animation_finished():
	state = MOVE
	velocity /= 1.5

func _on_hurtbox_area_entered(area):
	stats.health -= area.damage
	var knockback_direction = area.owner.position.direction_to(position)
	velocity = knockback_direction * 200
#	hurtbox.start_invincibility(0.6)
#	start_blinking()
#	hurtbox.create_hit_effect()
#	var playerHurtSound = PlayerHurtSound.instantiate()
#	get_tree().current_scene.add_child(playerHurtSound)

func start_blinking():
#	blinkAnimationPlayer.play("Start")
	pass

func _on_hurtbox_invincibility_ended():
#	blinkAnimationPlayer.play("Stop")
	pass

func _on_hurtbox_invincibility_started():
	pass
