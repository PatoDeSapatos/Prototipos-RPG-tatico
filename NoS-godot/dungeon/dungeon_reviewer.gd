class_name DungeonReviewer

static func review_dungeon(dungeon: Dungeon) -> Dungeon:
	_assure(dungeon)
	_generate_end_pos(dungeon)
	_generate_init_pos(dungeon)
	_generate_spawnables(dungeon)
	return dungeon

static func _assure(dun: Dungeon):
	#assure end room
	if (_spawn_rooms(dun, 1).size() == 0):
		var _not_spawns := _get_nodes(dun, ["s"], true)
		
		for i in _not_spawns:
			if (i.node.direction.length() == 1):
				var _old = i
				var _new_array = _find_nodes(dun, _old.node.direction, ["s"])
				var _new = _new_array.pick_random()
				dun.node_grid[_old.y][_old.x] = _new
				break
	
	var _spawn_rooms_length = _spawn_rooms(dun).size()
	var _spawnables_length = dun.dungeon_table["spawnables"].size() + 2 #+ end and init rooms
	
	if (_spawn_rooms_length < _spawnables_length):
		var _nodes = _get_nodes(dun, ["s"], true)
		
		for i in (_spawnables_length - _spawn_rooms_length):
			var _old_index := randi_range(0, _nodes.size() - 1)
			var _old_node = _nodes[_old_index]
			_nodes.remove_at(_old_index)
			
			var _new_nodes_array := _find_nodes(dun, _old_node.node.direction, ["s"])
			var _new_node = _new_nodes_array.pick_random()
			
			dun.node_grid[_old_node.y][_old_node.x] = _new_node

static func _generate_end_pos(dungeon: Dungeon):
	var _sprm_array = _spawn_rooms(dungeon, 1)
	var _room = _sprm_array.pick_random()
	dungeon.node_grid[_room.y][_room.x].spawn = Tables.Spawns.END

static func _generate_init_pos(dungeon: Dungeon):
	var _sprm_array = _spawn_rooms(dungeon)
	var _room = _sprm_array.pick_random()
	
	dungeon.node_grid[_room.y][_room.x].spawn = Tables.Spawns.INITIAL
	
	var _initX = ((_room.x * Game.ROOM_SIZE) + (Game.ROOM_SIZE / 2))
	var _initY = ((_room.y * Game.ROOM_SIZE) + (Game.ROOM_SIZE / 2))
	
	dungeon.init_pos = Grid.tile_to_scene_pos(_initX, _initY, Game.START_POS)

static func _generate_spawnables(dungeon: Dungeon):
	var _spawnables = dungeon.dungeon_table["spawnables"]
	
	for spwnbl in _spawnables:
		if (randi_range(0, 99) < spwnbl[1]):
			var _sprm_array := _spawn_rooms(dungeon)
			var _room = _sprm_array.pick_random()
			dungeon.node_grid[_room.y][_room.x].spawn = spwnbl[0]

static func _spawn_rooms(dun: Dungeon, _name_length := -1, exclude_marked := true) -> Array:
	var array = []
	for y in dun.node_grid.size():
		for x in dun.node_grid[y].size():
			var node: GridNode = dun.node_grid[y][x]
			
			if (node == GridNode.EMPTY || !node.args.has("s")): continue
			if (exclude_marked && node.spawn != -1): continue
			if (_name_length != -1):
				if (node.direction.length() != _name_length): continue
			
			array.append({
				"x": x,
				"y": y
			})
	return array

static func _get_nodes(dun: Dungeon, args_array: Array[String], exclude := false) -> Array:
	var array = []
	for y in dun.node_grid.size():
		for x in dun.node_grid[y].size():
			var node: GridNode = dun.node_grid[y][x]
			if (node == GridNode.EMPTY): continue
			
			if (args_array is Array):
				var valid := true
				for s in args_array:
					var _contains = node.args.has(s)
					if (_contains if exclude else !_contains):
						valid = false
						break
				if (!valid): continue
			
			array.append({
				"node": node,
				"x": x,
				"y": y
			})
	return array

static func _find_nodes(dun: Dungeon, _direction: String, args_array: Array[String]) -> Array[GridNode]:
	var array = []
	for node in dun.nodes:
		if (node.direction != _direction): continue
		var valid = true
		for i in args_array:
			if !node.args.has(i):
				valid = false
				break
		if !valid: continue
		
		array.append(node)
	return array
