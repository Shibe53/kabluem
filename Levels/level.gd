extends Node2D

@export var level_number = 1
@export var bloom_needed = 1
@export var bloom_percentage_needed = 0
@export var player_max_health = 3

@onready var gui = $CanvasLayer/Gui
@onready var endpoint = $Endpoint
@onready var concrete_layer = $NavigationRegion2D/TileMap/TileMapLayer

var stats = PlayerStats
var level_select = LevelSelect

func _ready():
	print(concrete_layer.get_used_cells().size())
	if bloom_percentage_needed != 0:
		bloom_needed = bloom_percentage_needed * concrete_layer.get_used_cells().size() / 100
		print(bloom_needed)
	level_select.room_bloomed.connect(kill_enemies)
	level_select.no_enemies_left.connect(go_to_endpoint)
	level_select.bloom_needed = bloom_needed
	stats.max_health = player_max_health
	stats.health = player_max_health
	stats.no_health.connect(restart_level)
	gui.visible = true

func restart_level():
	var timer = get_tree().create_timer(2.5)
	await timer.timeout  
	level_select.level = level_select.current_level

func kill_enemies():
	if not endpoint.canEnd:
		gui.change_obj_label("Free the rest of them")
	else:
		gui.change_obj_label("Find a spot to burrow")
		endpoint.canEnd = true

func go_to_endpoint():
	gui.change_obj_label("Find a spot to burrow")
	endpoint.canEnd = true
