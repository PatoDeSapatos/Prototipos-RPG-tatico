class_name BattleManager
extends Node2D

const TILE = preload("res://entities/Tile.tscn")
const Grid = preload("res://globals/grid.gd")
const PARTY_UNIT = preload("res://battle/entities/BattleUnit/PartyUnit.tscn")
const ENEMY_UNIT = preload("res://battle/entities/BattleUnit/EnemyUnit.tscn")

@onready var player_turn_ui: Control = $PlayerTurnUi
@onready var camera: Camera2D = $Camera
@onready var tiles: Node2D = $Tiles

@export var tile_highlight: Texture2D

var host_name := ""

# Grid info
var grid := [[]]
var init_pos = self.global_position
var highlight_area: ActionArea = null:
	set(new_area):
		for i in range(len(grid)):
			for j in range(len(grid[i])):
				if (new_area != null && new_area.point_in_area(Vector2(i, j))):
					grid[i][j].highlighted = true
				else:
					grid[i][j].highlighted = false
		
		highlight_area = new_area

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

# - targeting
var selected_action: Action = null
var action_possible_targets: Array[BattleUnit]
var action_targets: Array[BattleUnit]
var current_target: int
var action_origin: Vector2
var action_area: ActionArea

var extra_action := false
var extra_turn_user: BattleUnit
var extra_turn_given

var waiting_frames = 60/2

func _ready() -> void:
	# Instantiate grid tiles
	for y in len(grid):
		for x in len(grid[y]):
			var instance = TILE.instantiate()
			instance.global_position = Grid.tile_to_scene_pos(x, y, init_pos)
			tiles.add_child(instance)
			instance.tile_info = grid[x][y]
			grid[x][y] = instance
	
	# Instantiate enemies
	for info in enemies_info:
		var unit = ENEMY_UNIT.instantiate()
		unit.assign_info(info)
		unit.global_position = Grid.tile_to_scene_pos(info["grid_pos"].x, info["grid_pos"].y, init_pos)
		unit.grid_init_pos = self.init_pos
		units.push_front(unit)
		add_child(unit)
	
	# Instantiate party
	for info in party_info:
		var unit = PARTY_UNIT.instantiate()
		unit.assign_info(info)
		unit.global_position = Grid.tile_to_scene_pos(info["grid_pos"].x, info["grid_pos"].y, init_pos)
		unit.grid_init_pos = self.init_pos
		units.push_front(unit)
		add_child(unit)
	
	BattleHandler.assign_manager(self)
	state = start_turn_state

func _process(delta: float) -> void:
	state.call()

func start_turn_state():
	movement_actions = 1
	main_actions = 1 
	
	camera.follow = units[turn]
	
	if (units[turn].info.is_player):
		state = turn_state
	elif (host_name == Server.username && units[turn].info.is_enemy):
		state = enemy_turn_state
	else:
		state = waiting_state
		
func turn_state():
	player_turn_ui.show_ui()
	camera.follow = units[turn]

func enemy_turn_state():
	pass

func set_targeting_state(action: Action):
	var user = BattleHandler.get_user().info
	selected_action = action
	action_targets = []
	current_target = 0
	prev_state = state
	
	var range = action.range
	if (range != -1):
		highlight_area = ActionArea.new(user.grid_pos, range, ActionArea.Shapes.CIRCLE)
	
	if (action.target_required):
		var filter_callback = func (unit: BattleUnit):
			var selected = false
			
			if (!selected_action.target_dead):
				selected = unit.info.hp > 0
			
			if (!selected_action.target_self):
				selected = selected && unit != user
			
			if (selected_action.range != -1):
				selected = selected && BattleHandler.calc_unit_distance(user, unit.info) <= selected_action.range
			
			return selected
		
		var sort_callback = func (unit: BattleUnit):
			return unit.info.is_enemy if selected_action.prioritize_enemies else !unit.info.is_enemy
		
		action_possible_targets = units.filter(filter_callback)
		action_possible_targets.sort_custom(sort_callback)
		
		if (action_possible_targets.size() > 0):
			camera.follow = action_possible_targets[current_target]
			action_possible_targets[current_target].focus = true
		
		if (selected_action.area_target):
			action_origin = user.grid_pos
		
	BattleHandler.exit_state_turn(targeting_state)

func targeting_state():
	var user = BattleHandler.get_user()
	
	if (!selected_action.target_required):
		BattleHandler.unit_use_action(selected_action, user, [], action_origin)
		state = end_targeting_state
		return
	
	if (Input.is_action_just_pressed("menu_cancel")):
		state = end_targeting_state
		return
	
	if (selected_action.target_count > 0):
		var offset = Input.get_axis("left", "right")
		var new_target = clamp(current_target + offset, 0, len(action_possible_targets)-1)
		
		if (current_target != new_target):
			action_possible_targets[current_target].focus = false
			current_target = new_target
			camera.follow = action_possible_targets[current_target]
			action_possible_targets[current_target].focus = true

func end_targeting_state():
	if (len(action_possible_targets) > 0):
		action_possible_targets[current_target].focus = false
	
	selected_action = null
	action_targets = []
	action_possible_targets = []
	action_area = null
	highlight_area = null
	
	state = turn_state
	
func waiting_state():
	pass
