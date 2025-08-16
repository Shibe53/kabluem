extends Control

@onready var healthLabel = $HealthLabel
@onready var bloomLabel = $BloomLabel
@onready var objLabel = $ObjectiveLabel

func set_health(value):
	healthLabel.text = str(value) + "/" + str(PlayerStats.max_health)

func set_max_health(value):
	healthLabel.text = str(PlayerStats.health) + "/" + str(value)

func set_bloom(value):
	bloomLabel.text = str(clamp(floor(value * 100 / LevelSelect.bloom_needed), 0, 100)) + "%"

func change_obj_label(msg : String):
	objLabel.text = msg

func _ready():
	PlayerStats.health_changed.connect(set_health)
	PlayerStats.max_health_changed.connect(set_max_health)
	LevelSelect.bloom_changed.connect(set_bloom)
