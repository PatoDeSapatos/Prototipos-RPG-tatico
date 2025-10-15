class_name BattleManager
extends Node2D

const TILE = preload("res://entities/Tile.tscn")
const PARTY_UNIT = preload("res://battle/entities/BattleUnit/PartyUnit.tscn")
const ENEMY_UNIT = preload("res://battle/entities/BattleUnit/EnemyUnit.tscn")

@onready var player_turn_ui: Control = $PlayerTurnUi
@onready var camera: Camera2D = $Camera
@onready var tiles: Node2D = $Tiles

@export var tile_highlight: Texture2D

var state_changed := false
var host_id: int = 0
var using_mouse: bool
var unit_hover: BattleUnit
var animating: bool:
	get():
		return cutscene.size() > 0

# Cutscenes
var cutscene_handler = CutsceneHandler.new(self)
var cutscene: Array[Array] = []
var action := 0
var timer := 0
var image := 0
var setup := false

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
var action_origin: Node2D
var action_area: ActionArea:
	set(new_area):
		for i in range(len(grid)):
			for j in range(len(grid[i])):
				if (new_area != null && new_area.point_in_area(Vector2(i, j))):
					grid[i][j].selected = true
				else:
					grid[i][j].selected = false
		
		action_area = new_area

var extra_action := false
var extra_turn_user: BattleUnit
var extra_turn_given

var waiting_frames = 60/2
var current_waiting_frames := 0

# Triggers
signal turn_started
signal attack

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
	var cont := 0
	for info in enemies_info:
		var unit = ENEMY_UNIT.instantiate()
		unit.assign_info(info)
		unit.global_position = Grid.tile_to_scene_pos(info["grid_pos"].x, info["grid_pos"].y, init_pos)
		unit.grid_init_pos = self.init_pos
		unit.name = str("Enemy ", cont)
		cont += 1
		units.push_front(unit)
		add_child(unit)
	
	# Instantiate party
	for info in party_info:
		var unit = PARTY_UNIT.instantiate()
		unit.assign_info(info)
		unit.global_position = Grid.tile_to_scene_pos(info["grid_pos"].x, info["grid_pos"].y, init_pos)
		unit.grid_init_pos = self.init_pos
		unit.name = info["username"]
		unit.set_multiplayer_authority(info.peer_id, true)
		units.push_front(unit)
		add_child(unit)
		
		if (host_id == 0):
			host_id = info.peer_id
	
	state_changed = false
	BattleHandler.assign_manager(self)
	state = start_turn_state

func _process(delta: float) -> void:
	if (state.is_valid()):
		state.call_deferred()
	
	var animating = cutscene.size() > 0
	if (!animating):
		for unit in units:
			if (unit.animating):
				animating = true;
				break;
	self.animating = animating;
	
	if (cutscene.size() <= 0):
		return
	
	var current_action = cutscene[action]
	var arg_length = current_action.size() - 1
	
	match arg_length:
		1:
			cutscene_handler.call(current_action[0], current_action[1])
		2:
			cutscene_handler.call(current_action[0], current_action[1], current_action[2])
		3:
			cutscene_handler.call(current_action[0], current_action[1], current_action[2], current_action[3])
		4:
			cutscene_handler.call(current_action[0], current_action[1], current_action[2], current_action[3], current_action[4])
		5:
			cutscene_handler.call(current_action[0], current_action[1], current_action[2], current_action[3], current_action[4], current_action[5])
		6:
			cutscene_handler.call(current_action[0], current_action[1], current_action[2], current_action[3], current_action[4], current_action[5], current_action[6])
		0:
			cutscene_handler.call(current_action[0])

func _unhandled_input(event: InputEvent) -> void:
	if (event is InputEventMouseMotion):
		using_mouse = true
		await get_tree().create_timer(0.1).timeout
		using_mouse = false

func start_turn_state():
	movement_actions = 1
	special_actions = 1
	main_actions = 1 
	state_changed = false
	
	camera.follow = units[turn]
	
	if (units[turn].is_multiplayer_authority() && units[turn].info.is_player):
		state = turn_state
	elif (units[turn].info.is_enemy):
		state = enemy_turn_state
	else:
		state = waiting_state
		
func turn_state():
	if (!animating):
		if (main_actions <= 0 || BattleHandler.get_user().done):
			set_unit_done.rpc(BattleHandler.get_user().owner_id)
			BattleHandler.exit_state_turn(waiting_state)
		else:
			player_turn_ui.show_ui()
			camera.follow = units[turn]

func enemy_turn_state():
	BattleHandler.get_user().done = true
	state = waiting_state

func end_turn_state():
	if (animating || state_changed):
		return
	
	for unit in units:
		unit.done = false
	
	extra_action = false
	extra_turn_user = null
	extra_turn_given = false
	
	turn += 1
	if (turn >= units.size()):
		turn = 0
		round += 1
	
	state_changed
	BattleHandler.set_state(start_turn_state)

func waiting_state():
	if (animating):
		return
	
	var is_everyone_done := true
	for unit in units:
		if (!unit.done):
			is_everyone_done = false
			break
	
	if (extra_action && extra_turn_user is BattleUnit):
		if (extra_turn_user.info.is_player && extra_turn_user.owner_id == NetworkHandler.peer_id):
			extra_turn_user.done = false
			state = extra_turn_state
		elif (extra_turn_user.info.is_enemy && host_id == NetworkHandler.peer_id):
			state = extra_turn_state
	
	if BattleHandler.get_user().done:
		state = end_turn_state

@rpc("any_peer", "call_local", "reliable")
func set_unit_done(peer_id: int, value: bool = true):
	for unit in units:
		if (unit.owner_id == peer_id):
			unit.done = value

func set_targeting_state(action: Action):
	var user = BattleHandler.get_user().info
	selected_action = action
	action_targets = []
	current_target = 0
	prev_state = state
	
	var range = action.range
	if (range != -1):
		highlight_area = ActionArea.new(range, ActionArea.Shapes.CIRCLE, user.grid_pos)
	
	if (action.target_required):
		var filter_callback = func (unit: BattleUnit):
			var selected = false
			
			if (!selected_action.target_dead):
				selected = unit.info.hp > 0
			
			if (!selected_action.target_self):
				selected = selected && unit.info != user
			
			if (selected_action.range != -1 && !(selected_action.area_target && !selected_action.origin_in_player)):
				selected = selected && BattleHandler.calc_unit_distance(user, unit.info) <= selected_action.range
			
			return selected
		
		var sort_callback = func (unit: BattleUnit, unit2):
			return unit.info.is_enemy if selected_action.prioritize_enemies else !unit.info.is_enemy
		
		action_possible_targets = units.filter(filter_callback)
		action_possible_targets.sort_custom(sort_callback)

		if (selected_action.on_target && action_possible_targets.size() > 0):
			camera.follow = action_possible_targets[current_target]
			action_possible_targets[current_target].focus = true
		
		if (selected_action.area_target && selected_action.area != null):
			action_targets = action_possible_targets.duplicate()
			
			if (selected_action.origin_in_player):
				var area = ActionArea.new(selected_action.range, selected_action.area.shape, user.grid_pos)
				action_area = area
				
				for unit in action_targets:
					unit.focus = true
			else:
				var area = selected_action.area
				area.origin_point = user.grid_pos
				action_area = area
				
				action_origin = BattleUnit.new()
				action_origin.focus = true
				action_origin.global_position = Grid.tile_to_scene_pos(action_area.origin_point.x, action_area.origin_point.y, init_pos)
				add_child(action_origin)
				
				for unit in units:
					if (unit in action_possible_targets && action_area.point_in_area(unit.info.grid_pos)):
						unit.focus = true
				
	BattleHandler.exit_state_turn(targeting_state)

func targeting_state():
	var user = BattleHandler.get_user()
	
	if (!selected_action.target_required):
		BattleHandler.unit_use_action(selected_action, user, [user], action_area)
		state = end_targeting_state
		return
	
	if (Input.is_action_just_pressed("menu_cancel")):
		state = end_targeting_state
		return
	
	# On Target Skills
	if (selected_action.on_target && action_possible_targets.size() > 0):
		var offset = int(Input.is_action_just_pressed("right")) - int(Input.is_action_just_pressed("left"))
		var new_target = current_target + offset
		
		if (new_target >= action_possible_targets.size()):
			new_target = 0
		elif (new_target < 0):
			new_target = action_possible_targets.size() - 1
		
		if (using_mouse && unit_hover in action_possible_targets):
			current_target = action_possible_targets.find(unit_hover)
		
		if (current_target != new_target):
			action_possible_targets[current_target].focus = false
			current_target = new_target
			camera.follow = action_possible_targets[current_target]
			action_possible_targets[current_target].focus = true
		
		if (Input.is_action_just_pressed("menu_confirm")):
			action_targets.push_back(action_possible_targets[current_target])
		
		if (action_targets.size() >= selected_action.target_count || action_targets.size() >= action_possible_targets.size()):
			BattleHandler.unit_use_action(selected_action, user, action_targets, action_area)
			state = end_targeting_state
			return
		
	# Area Skills
	if (selected_action.area_target):
		if (!selected_action.origin_in_player):
			var offset = Vector2(
				int(Input.is_action_just_pressed("right")) - int(Input.is_action_just_pressed("left")), 
				int(Input.is_action_just_pressed("down")) - int(Input.is_action_just_pressed("up"))
				)
				
			var point = action_area.origin_point
			var new_x = clamp(point.x + offset.x, 0, len(grid[0]))
			var new_y = clamp(point.y + offset.y, 0, len(grid))
			var mouse_pos = Grid.scene_to_tile_pos(get_global_mouse_position().x, get_global_mouse_position().y, init_pos)
			
			if (using_mouse):
				if (highlight_area.point_in_area( mouse_pos )):
					new_x = clamp(mouse_pos.x+1, 0, len(grid[0]))
					new_y = clamp(mouse_pos.y+1, 0, len(grid))
				camera.follow = user
			
			if ((new_x != point.x || new_y != point.y) && (highlight_area.point_in_area(Vector2(new_x, new_y)))):
				action_area.origin_point = Vector2(new_x, new_y)
				action_origin.global_position = Grid.tile_to_scene_pos(new_x, new_y, init_pos)
				action_targets = []
				action_area = action_area
				
				if (!using_mouse):
					camera.follow = action_origin
				
				for unit in action_possible_targets:
					if (action_area.point_in_area(unit.info.grid_pos)):
						unit.focus = true
						action_targets.push_back(unit)
					else:
						unit.focus = false
						
		if (Input.is_action_just_pressed("menu_confirm") || Input.is_action_just_pressed("mouse_left")):
			BattleHandler.unit_use_action(selected_action, user, action_targets, action_area)
			state = end_targeting_state
			return

func end_targeting_state():
	for unit in units:
		unit.focus = false
	
	if (action_origin != null):
		action_origin.queue_free()
	
	selected_action = null
	action_targets = []
	action_possible_targets = []
	highlight_area = null
	action_area = null
	
	state = turn_state

func extra_turn_state():
	pass
