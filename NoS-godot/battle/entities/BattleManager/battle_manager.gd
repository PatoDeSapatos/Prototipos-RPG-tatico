class_name BattleManager
extends Node2D

const TILE = preload("res://entities/Tile.tscn")
const battle = preload("res://battle/scripts/battle.gd")
const Grid = preload("res://globals/grid.gd")
const PARTY_UNIT = preload("res://battle/entities/BattleUnit/PartyUnit.tscn")

var host_name := ""

# Grid info
var grid := [[]]
var init_pos = self.global_position

# Combat info
var party_info := []
var enemies_info := []
var state : Callable
var prev_state : Callable
var player_turn : bool
var turns := 0
var rounds := 0
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
	
	# Instantiate party
	for info in party_info:
		var unit = PARTY_UNIT.instantiate()
		unit.info = info
		unit.global_position = Grid.tile_to_scene_pos(info["grid_pos"].x, info["grid_pos"].y, init_pos)
		
		add_child(unit)
	
	for info in enemies_info:
		var unit = EnemieUnit.instantiate()
