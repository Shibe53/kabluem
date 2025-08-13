extends Node

signal no_health
signal room_completed
signal health_changed(value)
signal max_health_changed(value)
signal bloom_changed(value)

@export var level = 1:
	set(value):
		level = value

@export var max_health = 1:
	set(value):
		max_health = value
		if health:
			self.health = min(health, max_health)
		emit_signal("max_health_changed", max_health)

@onready var health = max_health:
	set(value): 
		health = value
		emit_signal("health_changed", health)
		if health <= 0:
			emit_signal("no_health")

@export var bloom_needed = 50:
	set(value):
		bloom_needed = value

@onready var bloom = 0:
	set(value):
		bloom = value
		emit_signal("bloom_changed", bloom)
		if bloom >= bloom_needed:
			emit_signal("room_completed")
