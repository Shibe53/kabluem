extends Control

@onready var healthLabel = $HealthLabel
@onready var bloomLabel = $BloomLabel

var stats = PlayerStats

func set_health(value):
	healthLabel.text = str(value) + "/" + str(stats.max_health)

func set_max_health(value):
	healthLabel.text = str(stats.health) + "/" + str(value)

func set_bloom(value):
	bloomLabel.text = str(clamp(floor(value * 100 / stats.bloom_needed), 0, 100)) + "%"

func _ready():
	stats.health_changed.connect(set_health)
	stats.max_health_changed.connect(set_max_health)
	stats.bloom_changed.connect(set_bloom)
