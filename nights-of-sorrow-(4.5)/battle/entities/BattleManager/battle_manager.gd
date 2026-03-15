class_name BattleManager
extends Node2D

const TILE = preload("res://entities/Tile.tscn")
const PARTY_UNIT = preload("res://battle/entities/BattleUnit/PartyUnit.tscn")
const ENEMY_UNIT = preload("res://battle/entities/BattleUnit/EnemyUnit.tscn")

@onready var player_turn_ui: BattleUI = $PlayerTurnUi
@onready var camera: BattleCamera = $Camera
@onready var tiles: Node2D = $Tiles

@export var tile_highlight: Texture2D

var players := {}
var done: bool = false
var state_changed := false
var host_id: int = 0
var using_mouse: bool
var unit_hover: BattleUnit
var animating: bool:
	get():
		return cutscene.size() > 0

var trigger_manager: TriggerManager

# Cutscenes
var cutscene_handler := CutsceneHandler.new(self)
var cutscene: Array[Array] = []
var cutscene_step := 0
var timer := 0
var image := 0
var setup := false

# Grid info
var grid := [[]]
var astar_grid : AStarGrid2D = AStarGrid2D.new()
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
var user: BattleUnit:
	get():
		return units[turn] if !extra_action else extra_turn_user

# - targeting
var selected_action: Action = null
var action_possible_targets: Array[BattleUnit]
var action_targets: Array[BattleUnit]
var current_target: int
var action_origin: Node2D
var action_area: ActionArea:
	set(value):
		action_area = value
		if (action_area == null):
			for y in range(grid.size()):
				for x in range(grid[0].size()):
					grid[x][y].selected = false
					

var extra_action := false
var extra_turn_user: BattleUnit
var extra_turn_given

var is_host:
	get():
		return host_id == NetworkHandler.peer_id
		
var waiting_frames := 1
var current_waiting_frames := 0.0

func _ready() -> void:
	# Instantiate grid tiles
	astar_grid.region = Rect2i(0, 0, len(grid[0]), len(grid))
	astar_grid.cell_size = Vector2(Game.TILE_SIZE, Game.TILE_SIZE)
	astar_grid.cell_shape = AStarGrid2D.CELL_SHAPE_ISOMETRIC_DOWN
	astar_grid.update()
	trigger_manager = TriggerManager.new()
	
	for y in len(grid):
		for x in len(grid[y]):
			var instance = TILE.instantiate()
			instance.global_position = Grid.tile_to_scene_pos(x, y, init_pos)
			tiles.add_child(instance)
			instance.tile_info = grid[x][y]
			grid[x][y] = instance
	
	# Instantiate enemies
	var cont := 0
	for info: BattleUnitInfo in enemies_info:
		var unit = ENEMY_UNIT.instantiate()
		
		unit.assign_info(info, self)
		unit.global_position = Grid.tile_to_scene_pos(info["grid_pos"].x, info["grid_pos"].y, init_pos)
		astar_grid.set_point_solid(Vector2i(info["grid_pos"].x, info["grid_pos"].y), true)
		unit.grid_init_pos = self.init_pos
		unit.name = str("Enemy ", cont)
		cont += 1
		units.push_front(unit)
		
		for p in info.passives:
			connect_passive(p, unit, unit)
		
		add_child(unit)
	
	# Instantiate party
	for info: BattleUnitInfo in party_info:
		var unit = PARTY_UNIT.instantiate()
		
		unit.assign_info(info, self)
		unit.global_position = Grid.tile_to_scene_pos(info["grid_pos"].x, info["grid_pos"].y, init_pos)
		astar_grid.set_point_solid(Vector2i(info["grid_pos"].x, info["grid_pos"].y), true)
		unit.grid_init_pos = self.init_pos
		unit.name = info["username"]
		unit.set_multiplayer_authority(info.peer_id, true)
		units.push_front(unit)
		add_child(unit)
		
		for p in info.passives:
			connect_passive(p, unit, unit)
		
		if (host_id == 0):
			host_id = info.peer_id
	
	for p in NetworkHandler.players.keys():
		players[p] = {
			"ready": false
		}
	
	player_turn_ui.camera = camera
	is_host = host_id == NetworkHandler.peer_id
	state_changed = false
	BattleHandler.assign_manager(self)
	state = start_turn_state

func _process(_delta: float) -> void:
	if (state.is_valid()):
		state.call_deferred()
	
	var _animating = cutscene.size() > 0
	if (!_animating):
		for unit in units:
			if (unit.animating):
				_animating = true;
				break;
	self.animating = _animating;
	
	if (!animating && done):
		set_player_ready.rpc(NetworkHandler.peer_id)
		done = false
	
	if (action_area != null):
		for i in range(len(grid)):
			for j in range(len(grid[i])):
				if (action_area.point_in_area(Vector2(i, j))):
					grid[i][j].selected = true
				else:
					grid[i][j].selected = false
	
	if (cutscene.size() <= 0):
		return
	
	var current_action: Array = cutscene[cutscene_step]
	cutscene_handler.callv(current_action.front(), current_action.slice(1, current_action.size()))

func _unhandled_input(event: InputEvent) -> void:
	if (event is InputEventMouseMotion):
		using_mouse = true
		await get_tree().create_timer(0.1).timeout
		using_mouse = false

func _turn_camera():
	if (!camera.follow):
		return
	
	var offset = (get_global_mouse_position() - camera.follow.global_position)/20;
	offset.x = clamp(offset.x, -20, 10)
	offset.y = clamp(offset.y - 5, -20, 20)
	camera.offset_target = offset
	
	camera.zoom_target = Vector2(1.08, 1.08)
	
	if(!camera.is_bar_on):
		camera.show_bar()

func _handle_target_area():
	var offset = Vector2(
		int(Input.is_action_just_pressed("right")) - int(Input.is_action_just_pressed("left")), 
		int(Input.is_action_just_pressed("down")) - int(Input.is_action_just_pressed("up"))
		)
		
	var point = action_area.origin_point
	var new_x = clamp(point.x + offset.x, 0, len(grid[0])-1)
	var new_y = clamp(point.y + offset.y, 0, len(grid)-1)
	var mouse_pos = Grid.scene_to_tile_pos(get_global_mouse_position().x, get_global_mouse_position().y, init_pos)
	
	if (using_mouse):
		mouse_pos.x += 1
		mouse_pos.y += 1
		if (highlight_area.point_in_area( mouse_pos )):
			new_x = clamp(mouse_pos.x, 0, len(grid[0])-1)
			new_y = clamp(mouse_pos.y, 0, len(grid)-1)
		camera.follow = user
	
	if ((new_x != point.x || new_y != point.y) && (highlight_area.point_in_area(Vector2(new_x, new_y)))):
		action_area.origin_point = Vector2(new_x, new_y)
		action_origin.global_position = Grid.tile_to_scene_pos(new_x, new_y, init_pos)
		action_targets = []
		action_area = action_area
		
		if (!using_mouse):
			camera.follow = action_origin
	
		if ((new_x != point.x || new_y != point.y) && (highlight_area.point_in_area(Vector2(new_x, new_y)))): 
			for unit in action_possible_targets:
				if (action_area.point_in_area(unit.info.grid_pos)):
					unit.focus = true
					action_targets.push_back(unit)
				else:
					unit.focus = false

func add_passive(passive_name: String, origin: BattleUnit, target: BattleUnit):
	pass

func connect_passive(passive_name: String, origin: BattleUnit, target: BattleUnit):
	var passive = Passives.passives_library.get(passive_name)
	if (passive == null): return
	
	for e in passive.battle_effects:
		e.origin = origin
		e.target = target
		trigger_manager.connect(e.trigger, e.resolve)

func disconnect_passive(passive: Passive):
	pass

func trigger_event(event: BattleEvent) -> Array:
	var cutscene := []
	for e in trigger_manager.get_signal_connection_list(event.trigger_name):
		var c := []
		c.push_back(["call_script", e.callable.call, [event]])
		if (c.size() > 0):
			cutscene.append_array(c)
	
	return cutscene

func start_turn_state():
	movement_actions = 1
	special_actions = 1
	main_actions = 1 
	state_changed = false
	
	camera.follow = units[turn]
	current_waiting_frames = 0.0
	
	for p in players:
		players[p].ready = false
	
	if (is_host):
		trigger_event(TurnStartedEvent.new(units[turn], turn))
	
	if (units[turn].is_multiplayer_authority() && units[turn].info.is_player):
		state = turn_state
	elif (units[turn].info.is_enemy && is_host):
		state = enemy_turn_state
	else:
		state = waiting_state
		
func turn_state():
	if (!units[turn].is_multiplayer_authority()):
		BattleHandler.exit_state_turn(waiting_state)
	
	if (!animating):
		if (main_actions <= 0):
			set_unit_done.rpc(NetworkHandler.peer_id)
			BattleHandler.exit_state_turn(waiting_state)
		else:
			_turn_camera()
			player_turn_ui.show_ui()
			camera.follow = units[turn]
			if (Input.is_action_just_pressed("end_turn")):
				main_actions = 0

func enemy_turn_state():
	if (current_waiting_frames <= waiting_frames):
		current_waiting_frames += get_process_delta_time()
		return
	
	if (!is_host || animating):
		return

	if (main_actions <= 0 || players[host_id].ready):
		set_unit_done.rpc(host_id, true)
		BattleHandler.exit_state_turn(waiting_state)
	else:
		user.state_script.execute()

@rpc("any_peer", "call_local", "reliable")
func end_turn_state(new_turn):
	if (animating || state_changed):
		return
	
	for unit in units:
		unit.done = false
	
	extra_action = false
	extra_turn_user = null
	extra_turn_given = false
	
	turn = new_turn
	if (turn >= units.size()):
		turn = 0
		round += 1
	
	BattleHandler.set_state(start_turn_state)

func waiting_state():
	if (animating || !is_host):
		return
	var is_everyone_done := true
	for p in players:
		if (!players[p].ready):
			is_everyone_done = false
			break
	#
	#if (extra_action && extra_turn_user is BattleUnit):
		#if (extra_turn_user.info.is_player && extra_turn_user.owner_id == NetworkHandler.peer_id):
			#extra_turn_user.done = false
			#state = extra_turn_state
		#elif (extra_turn_user.info.is_enemy && host_id == NetworkHandler.peer_id):
			#state = extra_turn_state
	
	if (is_everyone_done):
		end_turn_state.rpc(turn+1)

@rpc("any_peer", "call_local", "reliable")
func set_player_ready(player_id: int):
	if (player_id in players):
		players[player_id].ready = true

@rpc("any_peer", "call_local", "reliable")
func set_unit_done(peer_id: int, value: bool = true):
	done = true

func start_state_move():
	var user = BattleHandler.get_user()
	var area = ActionArea.new(user.info.movement, ActionArea.Shapes.CIRCLE, user.info.grid_pos)
	self.action_area = ActionArea.new(0, ActionArea.Shapes.CUSTOM, user.info.grid_pos)
	highlight_area = area
	
	action_origin = BattleUnit.new()
	action_origin.focus = true
	action_origin.global_position = Grid.tile_to_scene_pos(action_area.origin_point.x, action_area.origin_point.y, init_pos)
	add_child(action_origin)
	BattleHandler.set_state(state_move)
 
func state_move():
	if (Input.is_action_just_pressed("menu_cancel")):
		BattleHandler.set_state(exit_state_move)

	_handle_target_area()
	action_area.custom_area = astar_grid.get_id_path(user.info.grid_pos, action_area.origin_point, true)
	if ((Input.is_action_just_pressed("menu_confirm") || Input.is_action_just_pressed("mouse_left")) && action_area.custom_area.size() > 1):
		BattleHandler.move_unit(user, user.info.grid_pos, action_area.origin_point)
		BattleHandler.set_state(exit_state_move)

func exit_state_move():
	camera.hide_bar()
	camera.follow = user
	highlight_area = null
	action_area = null
	action_origin.queue_free()
	action_origin = null
	BattleHandler.set_state(turn_state)

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
			_handle_target_area()
		
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
