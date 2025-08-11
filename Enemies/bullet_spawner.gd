extends Node2D

const Bullet = preload("res://Enemies/bullet.tscn")
@onready var timer = $Timer

@export var SPEED = 600
@export var ACCELERATION = 500
@export var COOLDOWN = 5

var onCooldown = false

func shoot_at_pos(position):
	if !onCooldown:
		onCooldown = true
		var bullet = Bullet.instantiate()
		bullet.set_values(position, SPEED, ACCELERATION)
		add_child(bullet)
		timer.start(COOLDOWN)

func _on_timer_timeout() -> void:
	onCooldown = false
