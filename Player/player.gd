extends CharacterBody2D

#const PlayerHurtSound = preload("res://Music and Sounds/player_hurt_sound.tscn")
const grnd = preload("res://Grenade/grenade.tscn")

@export var ACCELERATION = 800
@export var MAX_SPEED = 200
@export var MAX_THROW_SPEED = 75
@export var DODGE_SPEED = 115
@export var FRICTION = 500
@export var THROW_COOLDOWN = 1.0

enum {
	MOVE,
	DODGE,
	THROW
}

var state = MOVE
var dodge_vector = Vector2.DOWN
var stats = PlayerStats
var charge = 0
var onThrowCooldown = false

#@onready var animationPlayer = $AnimationPlayer
#@onready var animationTree = $AnimationTree
#@onready var animationState = animationTree.get("parameters/playback")
@onready var hurtbox = $Hurtbox
@onready var throwCDTimer = $ThrowCooldownTimer
@onready var chargeMeter = $AspectRatioContainer/ChargeMeter
#@onready var blinkAnimationPlayer = $BlinkAnimationPlayer

func _ready():
	randomize()
	stats.no_health.connect(player_death)
#	animationTree.active = true

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta, MAX_SPEED)
			if Input.is_action_just_pressed("dodge"):
				state = DODGE
	
			if Input.is_action_just_pressed("throw") and not onThrowCooldown:
				chargeMeter.visible = true
				state = THROW
		DODGE:
			dodge_state()
		THROW:
			move_state(delta, MAX_THROW_SPEED)
			throw_state()

func move_state(delta, speed):
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
		velocity = velocity.move_toward(input_vector * speed, ACCELERATION * delta)
	else:
#		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	move_and_slide()

func throw_state():
	charge = clamp(charge + chargeMeter.step, chargeMeter.min_value, chargeMeter.max_value)
	chargeMeter.value = charge
	if Input.is_action_just_released("throw"):
		var dir: Vector2 = (get_global_mouse_position() - global_position).normalized()
		var grenade = grnd.instantiate()
		grenade.global_position = global_position + dir * 10
		get_tree().current_scene.add_child(grenade)
		
		grenade.apply_impulse(dir * charge)
		
		charge = 0
		chargeMeter.value = charge
		onThrowCooldown = true
		throwCDTimer.start(THROW_COOLDOWN)
		chargeMeter.visible = false
		state = MOVE
#	animationState.travel("Attack")
	
func _on_throw_cooldown_timer_timeout() -> void:
	onThrowCooldown = false

func dodge_state():
	velocity = dodge_vector * DODGE_SPEED
#	animationState.travel("Roll")
	move_and_slide()
	hurtbox.start_invincibility(0.15)

func dodge_animation_finished():
	state = MOVE
	velocity /= 1.5

func _on_hurtbox_area_entered(area):
	stats.health -= area.damage
	var knockback_direction = area.owner.position.direction_to(position)
	velocity = knockback_direction * 200
	hurtbox.start_invincibility(0.6)
#	start_blinking()
#	hurtbox.create_hit_effect()
#	var playerHurtSound = PlayerHurtSound.instantiate()
#	get_tree().current_scene.add_child(playerHurtSound)

func player_death():
	var newCamera = Camera2D.new()
	newCamera.enabled = true
	newCamera.global_position = self.global_position
	get_tree().current_scene.add_child(newCamera)
	queue_free()

func start_blinking():
#	blinkAnimationPlayer.play("Start")
	pass

func _on_hurtbox_invincibility_ended():
#	blinkAnimationPlayer.play("Stop")
	pass

func _on_hurtbox_invincibility_started():
	pass
