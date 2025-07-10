class_name BattleManager
extends Node2D

const TILE = preload("res://entities/Tile.tscn")
const Grid = preload("res://globals/grid.gd")
const PARTY_UNIT = preload("res://battle/entities/BattleUnit/PartyUnit.tscn")
const ENEMY_UNIT = preload("res://battle/entities/BattleUnit/EnemyUnit.tscn")

@onready var player_turn_ui: Control = $PlayerTurnUi
@onready var camera: Camera2D = $Camera

var handler = BattleHandler.new(self)
var host_name := ""

# Grid info
var grid := [[]]
var init_pos = self.global_position

# Combat info
var state : Callable
var party_info := []
var enemies_info := []
var units : Array[BattleUnit] = []
var prev_state : Callable
var player_turn : bool
var turn := 0
var round := 0
var movement_actions := 0
var main_actions := 0
var special_actions := 0

var extra_action := false
var extra_turn_user
var extra_turn_given

var waiting_frames = 60/2

func _ready() -> void:
	# Instantiate grid tiles
	for y in len(grid):
		for x in len(grid[y]):
			grid[x][y].instantiate(self, Grid.tile_to_scene_pos(x, y, init_pos))
	
	# Instantiate enemies
	for info in enemies_info:
		var unit = ENEMY_UNIT.instantiate()
		unit.assign_info(info)
		unit.global_position = Grid.tile_to_scene_pos(info["grid_pos"].x, info["grid_pos"].y, init_pos)
		
		units.push_front(unit)
		add_child(unit)
	
	# Instantiate party
	for info in party_info:
		var unit = PARTY_UNIT.instantiate()
		unit.assign_info(info)
		unit.global_position = Grid.tile_to_scene_pos(info["grid_pos"].x, info["grid_pos"].y, init_pos)
		
		units.push_front(unit)
		add_child(unit)
	
	state = start_turn_state

func _process(delta: float) -> void:
	state.call()

func start_turn_state():
	movement_actions = 1
	main_actions = 1 
	
	camera.follow = units[turn]
	
	if (units[turn].info.is_player):
		player_turn_ui.show_ui()
		print("player_turn")
		state = turn_state
	elif (host_name == Server.username && units[turn].info.is_enemy):
		print("enemy_turn")
		state = enemy_turn_state
	else:
		print(units[turn].info)
		state = waiting_state
		
func turn_state():
	pass

func enemy_turn_state():
	pass
	
func waiting_state():
	pass
