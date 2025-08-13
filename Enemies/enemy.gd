extends CharacterBody2D
class_name Enemy

#const EnemyDeathEffect = preload("res://Effects/enemy_death_effect.tscn")
@export var ACCELERATION = 260
@export var MAX_SPEED = 30
@export var FRICTION = 200
@export var DETECTION_RANGE = 400.0
@export var SHOOT_RANGE = 250

var move_speed = MAX_SPEED

enum {
	IDLE,
	REACH,
	SHOOT
}

var state = SHOOT
@onready var stats = $Stats
@onready var playerDetectionZone = $PlayerDetection
@onready var sprite = $Sprite
@onready var hurtbox = $Hurtbox
@onready var softCollision = $SoftCollision
@onready var bulletSpawner = $Pivot/BulletSpawner
@onready var rayCast = $Pivot/RayCast2D
#@onready var animationPlayer = $AnimationPlayer

@onready var navAgent = $NavigationAgent2D
@onready var player = get_tree().get_first_node_in_group("player")

func _ready():
	state = IDLE
#	sprite.frame = randi_range(0, 4)

func _process(_delta: float) -> void:
#	if velocity.length() > 0.1:
#		$Pivot.rotation = velocity.angle()
	if player != null:
		var dir_player = (player.global_position - $Pivot.global_position)
		var dist = $Pivot.global_position.distance_to(player.global_position)
#		$Pivot.rotation = dir_player.angle()
		if dist > SHOOT_RANGE:
			dir_player = dir_player.normalized() * SHOOT_RANGE
		rayCast.target_position = dir_player

func _physics_process(delta):
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move_and_slide()
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
		
		REACH:
			if player != null:
				update_target_position(player.global_transform.origin)
				var dist = global_position.distance_to(player.global_position)
				if dist <= SHOOT_RANGE and not rayCast.is_colliding():
					state = SHOOT
		
		SHOOT:
			if player != null:
				var dist = global_position.distance_to(player.global_position)
				if dist > SHOOT_RANGE or rayCast.is_colliding():
					state = REACH
					move_speed = MAX_SPEED
				else:
					move_speed = lerp(0, MAX_SPEED, dist / SHOOT_RANGE)
					update_target_position(player.global_transform.origin)
					bulletSpawner.shoot_at_pos(player.hurtbox.global_position)
			else:
				state = IDLE
				move_speed = MAX_SPEED
			
	if softCollision.has_overlapping_areas():
		velocity += softCollision.get_push_vector() * delta * 500
	
	move_and_slide()

func seek_player():
	if playerDetectionZone.can_see_player():
		state = REACH

func has_line_of_sight(player_pos: Vector2) -> bool:
	rayCast.target_position = to_local(player_pos)
	rayCast.force_raycast_update()
	return not rayCast.is_colliding()

func _on_hurtbox_area_entered(area):
	stats.health -= area.damage
	var knockback_direction = area.owner.position.direction_to(position)
	velocity = knockback_direction * 120
	#hurtbox.create_hit_effect()
	hurtbox.start_invincibility(0.4)
	start_blinking()

func _on_stats_no_health():
	queue_free()
#	var enemyDeathEffect = EnemyDeathEffect.instantiate()
#	get_parent().add_child(enemyDeathEffect)
#	enemyDeathEffect.position = position

func start_blinking():
#	animationPlayer.play("Start")
	pass

func _on_hurtbox_invincibility_ended():
#	animationPlayer.play("Stop")
	pass

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
