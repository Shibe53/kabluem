extends CharacterBody2D

#const EnemyDeathEffect = preload("res://Effects/enemy_death_effect.tscn")

@export var ACCELERATION = 260
@export var MAX_SPEED = 30
@export var FRICTION = 200

enum {
	IDLE,
	SHOOT
}

var state = SHOOT
@onready var stats = $Stats
@onready var playerDetectionZone = $PlayerDetection
@onready var sprite = $Sprite
@onready var hurtbox = $Hurtbox
@onready var softCollision = $SoftCollision
@onready var bulletSpawner = $BulletSpawner
#@onready var animationPlayer = $AnimationPlayer

func _ready():
	state = IDLE
#	sprite.frame = randi_range(0, 4)

func _physics_process(delta):
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move_and_slide()
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
		
		SHOOT:
			var player = playerDetectionZone.player
			if player != null:
				bulletSpawner.shoot_at_pos(player.global_position)
			else:
				state = IDLE
			
	if softCollision.has_overlapping_areas():
		velocity += softCollision.get_push_vector() * delta * 500
	
	move_and_slide()

func seek_player():
	if playerDetectionZone.can_see_player():
		state = SHOOT

#func pick_random_state(state_list):
#	state_list.shuffle()
#	return state_list.pop_front()

func _on_hurtbox_area_entered(area):
	stats.health -= area.damage
	var knockback_direction = area.owner.position.direction_to(position)
	velocity = knockback_direction * 120
	hurtbox.create_hit_effect()
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
