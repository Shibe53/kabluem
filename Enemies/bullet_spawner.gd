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
	if !onCooldown:
		onCooldown = true
		var bullet = Bullet.instantiate()
		var main = get_tree().current_scene
		
		bullet.global_position = global_position
		bullet.set_values(pos, SPEED, DAMAGE)
		
		if SPREAD:
			var bullets_pos = get_spread(pos, global_position)
			
			var bullet2 = Bullet.instantiate()
			bullet2.global_position = global_position
			bullet2.set_values(bullets_pos[0], SPEED, DAMAGE)
			main.add_child(bullet2)
			
			var bullet3 = Bullet.instantiate()
			bullet3.global_position = global_position
			bullet3.set_values(bullets_pos[1], SPEED, DAMAGE)
			main.add_child(bullet3)
			
		main.add_child(bullet)
		timer.start(COOLDOWN)

func get_spread(player_pos: Vector2, enemy_pos: Vector2) -> Array:
	var delta = player_pos - enemy_pos
	var angle_offset = deg_to_rad(SPREAD_ANGLE)
	
	# Direct angle from B to A
	var base_angle = atan2(delta.y, delta.x)
	
	var results = []
	for sign in [1, -1]:
		var angle = base_angle + sign * angle_offset
		var dir = Vector2(cos(angle), sin(angle))
		
		# Solve for λ where x = x_A
		var lambda = (player_pos.x - enemy_pos.x) / dir.x
		var y_intersect = enemy_pos.y + lambda * dir.y
		
		results.append(Vector2(player_pos.x, y_intersect))
	return results

func _on_timer_timeout() -> void:
	onCooldown = false
