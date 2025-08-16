extends Node2D

@export var level_number = 1
@export var bloom_needed = 1
@export var player_max_health = 3

@onready var gui = $CanvasLayer/Gui
@onready var endpoint = $Endpoint

var stats = PlayerStats
var level_select = LevelSelect

func _ready():
	level_select.room_bloomed.connect(kill_enemies)
	level_select.no_enemies_left.connect(go_to_endpoint)
	level_select.bloom_needed = bloom_needed
	stats.max_health = player_max_health
	gui.visible = true

func kill_enemies():
	if not endpoint.canEnd:
		gui.change_obj_label("Free the rest of them")
	else:
		gui.change_obj_label("Burrow back from where you came from")

func go_to_endpoint():
	gui.change_obj_label("Burrow back from where you came from")
	endpoint.canEnd = true
