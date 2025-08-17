extends CharacterBody2D
class_name Player

#const PlayerHurtSound = preload("res://Music and Sounds/player_hurt_sound.tscn")
const grnd = preload("res://Grenade/grenade.tscn")

@export var ACCELERATION = 800
@export var MAX_SPEED = 200
@export var MAX_THROW_SPEED = 100
@export var DODGE_SPEED = 300
@export var DODGE_INV = 0.35
@export var FRICTION = 500
@export var THROW_COOLDOWN = 1.0

enum {
	BURROW,
	MOVE,
	DODGE,
	THROW
}

var state = BURROW
var dodge_vector = Vector2.DOWN
var dodge_timer = 0.0
var last_facing = 1
var stats = PlayerStats
var charge = 0
var onThrowCooldown = false
var normalCursor = load("res://Assets/Sprites/cursor.png")
var grenadeCursor = load("res://Assets/Sprites/cursor_throw.png")

@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")
@onready var hurtbox = $Hurtbox
@onready var throwCDTimer = $ThrowCooldownTimer
@onready var chargeMeter = $AspectRatioContainer/ChargeMeter
@onready var blinkAnimationPlayer = $BlinkAnimationPlayer

func _ready():
	animationTree.active = false
	self.visible = false
	self.set_collision_layer_value(2, false)
	var timer = get_tree().create_timer(1.5)
	await timer.timeout 
	animationPlayer.play("Spawn")

func _on_spawn_finished():
	self.visible = true
	randomize()
	stats.no_health.connect(player_death)
	self.set_collision_layer_value(2, true)
	animationTree.active = true
	state = MOVE

func _physics_process(delta):
	match state:
		BURROW:
			pass
		MOVE:
			move_state(delta, MAX_SPEED)
			if Input.is_action_just_pressed("dodge"):
				state = DODGE
	
			if Input.is_action_pressed("throw") and not onThrowCooldown:
				chargeMeter.visible = true
				Input.set_custom_mouse_cursor(grenadeCursor)
				state = THROW
		DODGE:
			dodge_state(delta)
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
		if input_vector.x != 0:
			last_facing = sign(input_vector.x)
		animationTree.set("parameters/Idle/blend_position", last_facing)
		animationTree.set("parameters/Walk/blend_position", last_facing)
		animationTree.set("parameters/Dodge/blend_position", last_facing)
		animationState.travel("Walk")
		velocity = velocity.move_toward(input_vector * speed, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	move_and_slide()

func throw_state():
	charge = clamp(charge + chargeMeter.step, chargeMeter.min_value, chargeMeter.max_value)
	chargeMeter.value = charge
	if Input.is_action_just_released("throw"):
		var dir: Vector2 = (get_global_mouse_position() - global_position).normalized()
		var grenade = grnd.instantiate()
		grenade.global_position = global_position + dir * 10
		var world = get_tree().current_scene
		world.add_child(grenade)
		grenade.set_owner(world)
		
		grenade.apply_impulse(dir * charge)
		
		charge = 0
		chargeMeter.value = charge
		onThrowCooldown = true
		throwCDTimer.start(THROW_COOLDOWN)
		chargeMeter.visible = false
		Input.set_custom_mouse_cursor(normalCursor)
		state = MOVE
	elif Input.is_action_just_pressed("dodge"):
		charge = 0
		chargeMeter.value = charge
		chargeMeter.visible = false
		Input.set_custom_mouse_cursor(normalCursor)
		state = DODGE
	
func _on_throw_cooldown_timer_timeout() -> void:
	onThrowCooldown = false

func dodge_state(delta):
	dodge_timer += delta
	var speed_factor = clampf(sin(dodge_timer + PI / 2),0,1)
	velocity = dodge_vector * DODGE_SPEED * speed_factor
	animationState.travel("Dodge")
	move_and_slide()
	hurtbox.start_invincibility(DODGE_INV)

func dodge_animation_finished():
	state = MOVE
	dodge_timer = 0.0
	velocity /= 1.5

func _on_hurtbox_area_entered(area):
	stats.health -= area.damage
	var knockback_direction = area.owner.position.direction_to(position)
	velocity = knockback_direction * 200
	hurtbox.start_invincibility(0.6)
	start_blinking()
#	hurtbox.create_hit_effect()
#	var playerHurtSound = PlayerHurtSound.instantiate()
#	get_tree().current_scene.add_child(playerHurtSound)

func player_death():
	var newCamera = Camera2D.new()
	newCamera.enabled = true
	newCamera.global_position = self.global_position
	var world = get_tree().current_scene
	world.add_child(newCamera)
	newCamera.set_owner(world)
	queue_free()

func burrow():
	state = BURROW
	animationTree.active = false
	animationPlayer.play("Burrow")

func _on_burrow_finished():
	LevelSelect.end = true

func start_blinking():
	blinkAnimationPlayer.play("Start")

func _on_hurtbox_invincibility_ended():
	blinkAnimationPlayer.play("Stop")

func _on_hurtbox_invincibility_started() -> void:
	pass
