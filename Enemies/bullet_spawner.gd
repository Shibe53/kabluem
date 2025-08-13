extends Node2D

const Bullet = preload("res://Enemies/bullet.tscn")
@onready var timer = $Timer

@export var SPEED = 400
@export var COOLDOWN = 5
@export var DAMAGE = 1

var onCooldown = false

func shoot_at_pos(pos):
	if !onCooldown:
		onCooldown = true
		var bullet = Bullet.instantiate()
		bullet.global_position = global_position
		bullet.set_values(pos, SPEED, DAMAGE)
		var main = get_tree().current_scene
		main.add_child(bullet)
		timer.start(COOLDOWN)

func _on_timer_timeout() -> void:
	onCooldown = false
