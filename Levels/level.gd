extends Node2D

@export var level_number = 1
@export var bloom_needed = 1
@export var player_max_health = 3

@onready var gui = $CanvasLayer/Gui
@onready var endpoint = $Endpoint

var stats = PlayerStats
var level_select = LevelSelect

func _ready():
	stats.room_bloomed.connect(kill_enemies)
	stats.bloom_needed = bloom_needed
	stats.max_health = player_max_health
	gui.visible = true

func kill_enemies():
	gui.change_obj_label("Free the rest of them")

func go_to_endpoint():
	gui.change_obj_label("Burrow back from where you came from")
	endpoint.canEnd = true
