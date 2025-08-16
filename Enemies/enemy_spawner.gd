extends Node2D

const LesserVegan = preload("res://Enemies/lesser_vegan.tscn")
@onready var timerCD = $Timer
@onready var area = $Area2D

@export var ENEMY = LesserVegan
@export var COOLDOWN = 20.0
@export var SHOOT_RANGE = 300
@export var DETECTION_RANGE = 300
@export var SPEED = 400
@export var BULLET_COOLDOWN = 3.0
@export var DAMAGE = 1
@export var SCALE = 0.15
@export var SPREAD = false
@export var SPREAD_ANGLE = 20

var onCooldown = false
var stats = PlayerStats

func _ready():
	stats.room_bloomed.connect(destroy_spawner)

func _process(_delta: float) -> void:
	if not onCooldown:
		onCooldown = true
		timerCD.start(COOLDOWN)
		if not has_body_inside():
			var enemy = ENEMY.instantiate()
			var main = get_tree().current_scene
			enemy.global_position = global_position
			enemy.set_values(SHOOT_RANGE, DETECTION_RANGE)
			main.add_child(enemy)
			enemy.set_owner(main)
			enemy.set_bullet_values(SPEED, BULLET_COOLDOWN, DAMAGE, SCALE, SPREAD, SPREAD_ANGLE)

func has_body_inside() -> bool:
	return area.get_overlapping_bodies().size() > 0

func destroy_spawner():
	queue_free()

func _on_timer_timeout() -> void:
	onCooldown = false
