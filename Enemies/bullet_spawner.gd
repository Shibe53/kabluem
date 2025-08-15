extends Node2D

const Bullet = preload("res://Enemies/bullet.tscn")
@onready var timer = $Timer

@export var SPEED = 400
@export var COOLDOWN = 5.0
@export var DAMAGE = 1
@export var SPREAD = false
@export var SPREAD_ANGLE = 20

var onCooldown = false

func shoot_at_pos(pos):
	if not onCooldown:
		onCooldown = true
		timer.start(COOLDOWN)
		var timer = get_tree().create_timer(0.1)
		await timer.timeout  
		var bullet = Bullet.instantiate()
		var main = get_tree().current_scene
		
		bullet.global_position = global_position
		bullet.set_values(pos, SPEED, DAMAGE)
		main.add_child(bullet)
		bullet.set_owner(main)
		
		if SPREAD:
			var bullets_pos = get_spread(pos, global_position)
			
			var bullet2 = Bullet.instantiate()
			bullet2.global_position = global_position
			bullet2.set_values(bullets_pos[0], SPEED, DAMAGE)
			main.add_child(bullet2)
			bullet2.set_owner(main)
			
			var bullet3 = Bullet.instantiate()
			bullet3.global_position = global_position
			bullet3.set_values(bullets_pos[1], SPEED, DAMAGE)
			main.add_child(bullet3)
			bullet3.set_owner(main)

func get_spread(player_pos: Vector2, enemy_pos: Vector2) -> Array:
	var delta = player_pos - enemy_pos
	var angle_offset = deg_to_rad(SPREAD_ANGLE)
	
	# Direct angle from enemy to player
	var base_angle = atan2(delta.y, delta.x)
	var max_range = 500.0  # Change to your desired bullet travel distance
	
	var results = []
	for sgn in [1, -1]:
		var angle = base_angle + sgn * angle_offset
		var dir = Vector2(cos(angle), sin(angle))
		var end_point = enemy_pos + dir * max_range
		results.append(end_point)
	
	return results

func _on_timer_timeout() -> void:
	onCooldown = false
