extends Node2D

const LesserVegan = preload("res://Enemies/lesser_vegan.tscn")
const GreaterVegan = preload("res://Enemies/greater_vegan.tscn")
@onready var timerCD = $Timer
@onready var area = $Area2D

@export var ENEMY : String = "Lesser"
@export var MAX_ENEMIES = 5
@export var COOLDOWN = 20.0
@export var SHOOT_RANGE = 300
@export var DETECTION_RANGE = 300
@export var DETECTION_CHANGE = 100
@export var SPEED = 400
@export var BULLET_COOLDOWN = 3.0
@export var DAMAGE = 1
@export var HEALTH = 0
@export var SCALE = 0.15
@export var SPREAD = false
@export var SPREAD_ANGLE = 20

var enemy = null
var onCooldown = false
var level_select = LevelSelect
var current_enemies = 0

func _ready():
	level_select.room_bloomed.connect(stop_spawner)

func _process(_delta: float) -> void:
	if not onCooldown:
		onCooldown = true
		timerCD.start(COOLDOWN)
		if not has_body_inside() and current_enemies < MAX_ENEMIES:
			match ENEMY:
				"Lesser":
					enemy = LesserVegan.instantiate()
				"Greater":
					enemy = GreaterVegan.instantiate()
				_:
					enemy = LesserVegan.instantiate()
			var main = get_tree().current_scene
			enemy.global_position = global_position
			enemy.set_values(SHOOT_RANGE, DETECTION_RANGE, DETECTION_CHANGE, ENEMY, HEALTH)
			level_select.enemies += 1
			current_enemies += 1
			enemy.enemy_dead.connect(enemy_dead)
			main.add_child(enemy)
			enemy.set_owner(main)
			enemy.set_bullet_values(SPEED, BULLET_COOLDOWN, DAMAGE, SCALE, SPREAD, SPREAD_ANGLE)

func has_body_inside() -> bool:
	return area.get_overlapping_bodies().size() > 0

func enemy_dead():
	LevelSelect.enemies -= 1
	current_enemies -= 1

func stop_spawner():
	MAX_ENEMIES = 0

func _on_timer_timeout() -> void:
	onCooldown = false
