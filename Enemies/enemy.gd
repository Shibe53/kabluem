extends CharacterBody2D
class_name Enemy

const LesserVeganEffect = preload("res://Effects/lesser_vegan_death.tscn")
const GreaterVeganEffect = preload("res://Effects/greater_vegan_death.tscn")

signal enemy_dead

const ACCELERATION = 260
const MAX_SPEED = 30
const FRICTION = 100

@export var ENEMY_TYPE : String = "Lesser"
@export var SHOOT_RANGE = 300
@export var DETECTION_RANGE = 300

enum {
	IDLE,
	REACH,
	SHOOT
}

var state = SHOOT
var move_speed = MAX_SPEED
var last_hit_direction: Vector2 = Vector2.ZERO
var effect = null

@onready var stats = $Stats
@onready var playerDetectionZone = $PlayerDetection
@onready var hurtbox = $Hurtbox
@onready var softCollision = $SoftCollision
@onready var bulletSpawner = $Pivot/BulletSpawner
@onready var mainRC = $Pivot/MainRC
@onready var animations = $AnimatedSprite2D
@onready var navAgent = $NavigationAgent2D
@onready var animationPlayer = $BlinkAnimationPlayer
@onready var animatedSprite = $AnimatedSprite2D
@onready var player = get_tree().get_first_node_in_group("player")

func _ready():
	state = IDLE
	animations.frame = randi_range(0, 4)
	mainRC.target_position.x = SHOOT_RANGE
	if animatedSprite.material != null:
		animatedSprite.material = animatedSprite.material.duplicate()

func _process(_delta: float) -> void:
	playerDetectionZone.change_range(DETECTION_RANGE)
	if velocity.length() > 0.1:
		animations.play("Move")
		animatedSprite.flip_h = velocity.x < 0
	else:
		animations.play("Idle")
	if player != null:
		var dir_player = (player.global_position - $Pivot.global_position)
		var dist = $Pivot.global_position.distance_to(player.global_position)
#		$Pivot.rotation = dir_player.angle()
		if dist > SHOOT_RANGE:
			dir_player = dir_player.normalized() * SHOOT_RANGE
		mainRC.target_position = dir_player

func _physics_process(delta):
	move_speed = move_toward_int(move_speed, 0, FRICTION * delta)
	move_and_slide()
	
	match state:
		IDLE:
			idle_state(delta)
		REACH:
			reach_state()
		SHOOT:
			shoot_state()
			
	if softCollision.has_overlapping_areas():
		velocity += softCollision.get_push_vector() * delta * 500
	
	move_and_slide()

func seek_player():
	if playerDetectionZone.can_see_player():
		state = REACH

func check_detection():
	if not playerDetectionZone.can_see_player():
		state = IDLE

func idle_state(delta):
	DETECTION_RANGE = 300
	move_speed = move_toward_int(move_speed, 0, FRICTION * delta)
	seek_player()
	
func reach_state():
	DETECTION_RANGE = 400
	move_speed = MAX_SPEED
	if player != null:
		update_target_position(player.global_transform.origin)
		var dist = global_position.distance_to(player.global_position)
		if dist <= SHOOT_RANGE and has_los():
			state = SHOOT
	check_detection()

func shoot_state():
	if player != null:
		var dist = global_position.distance_to(player.global_position)
		if dist > SHOOT_RANGE or not has_los():
			state = REACH
		else:
			move_speed = lerp(0, MAX_SPEED, dist / SHOOT_RANGE)
			update_target_position(player.global_transform.origin)
			bulletSpawner.shoot_at_pos(player.hurtbox.global_position)
	check_detection()

func has_los():
	return (not mainRC.is_colliding()) or (mainRC.is_colliding() and is_instance_of(mainRC.get_collider(), Grenade))

func set_values(shootRange, detectionRange, enemyType):
	SHOOT_RANGE = shootRange
	DETECTION_RANGE = detectionRange
	ENEMY_TYPE = enemyType

func set_bullet_values(speed, cooldown, damage, dimension, spread, spreadAngle):
	bulletSpawner.set_values(speed, cooldown, damage, dimension, spread, spreadAngle)

func _on_hurtbox_area_entered(area):
	last_hit_direction = area.owner.position.direction_to(position)
	stats.health -= area.damage
	velocity = last_hit_direction * 20
	#hurtbox.create_hit_effect()
	hurtbox.start_invincibility(0.5)
	start_blinking()

func _on_stats_no_health():
	emit_signal("enemy_dead")
	queue_free()
	match ENEMY_TYPE:
		"Lesser":
			effect = LesserVeganEffect.instantiate()
		"Greater":
			effect = GreaterVeganEffect.instantiate()
		_:
			effect = LesserVeganEffect.instantiate()
	get_parent().add_child(effect)
	effect.set_owner(get_parent())
	effect.position = position
	effect.flip_h = last_hit_direction.x > 0
	if last_hit_direction != Vector2.ZERO:
		effect.velocity = last_hit_direction * 80

func start_blinking():
	animationPlayer.play("Start")

func _on_hurtbox_invincibility_ended():
	animationPlayer.play("Stop")

func _on_hurtbox_invincibility_started():
	pass

func update_target_position(target_pos : Vector2):
	var current_pos : Vector2 = self.global_transform.origin
	var next_pos : Vector2 = navAgent.get_next_path_position()
	var new_velocity : Vector2 = current_pos.direction_to(next_pos)
	navAgent.velocity = new_velocity
	navAgent.target_position = target_pos

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	if safe_velocity.length() > 0.001:
		var target_dir = safe_velocity.normalized()
		var current_dir = velocity.normalized() if velocity.length() > 0.001 else target_dir
		
		# Smoothly turn toward the new direction
		var smooth_dir = current_dir.lerp(target_dir, 0.075).normalized()
		velocity = smooth_dir * move_speed
	move_and_slide()

func move_toward_int(current: int, target: int, step: int) -> int:
	if current < target:
		return min(current + step, target)
	elif current > target:
		return max(current - step, target)
	return current
