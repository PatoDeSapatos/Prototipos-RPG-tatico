class_name DungeonGenerator

const OFFSET_LETTER := {
	Vector2i.UP: "U",
	Vector2i.DOWN: "D",
	Vector2i.RIGHT: "R",
	Vector2i.LEFT: "L"
}

static func generate_dungeon(dungeon_type: Tables.DungeonType = -1, level := 1) -> Dungeon:
	if (dungeon_type == -1):
		dungeon_type = randi_range(0, Tables.DungeonType.size() - 1)
	
	var dungeon := Dungeon.new(Tables.get_dungeon_table(dungeon_type, level))
	
	var time = Time.get_unix_time_from_system()
	_collapse(dungeon)
	print("finished in: %.3f s with %d/%d rooms (%d%%)" % [Time.get_unix_time_from_system() - time, dungeon.salas, dungeon.rooms_amount, dungeon.salas * 100 / dungeon.rooms_amount])
	return dungeon

static func _collapse(dun: Dungeon):
	dun.to_collapse.append(Vector2i(dun.rooms_width / 2, dun.rooms_height / 2))
	var initial = true
	
	while (dun.to_collapse.size() > 0):
		var atual: Vector2i = dun.to_collapse.pop_front()
		if (dun.node_grid[atual.y][atual.x] is GridNode): continue
		
		var potential_nodes := dun.nodes.slice(0) as Array[GridNode]
		
		var nome: Array[String] = []
		var nome_restritivo: Array[String] = []
		
		for offset: Vector2i in OFFSET_LETTER.keys():
			var neighbour := Vector2i(atual.x + offset.x, atual.y + offset.y)
			
			if (_is_inside(neighbour, dun)):
				var neighbour_node: GridNode = dun.node_grid[neighbour.y][neighbour.x]
				
				if (neighbour_node is GridNode):
					if neighbour_node == GridNode.EMPTY:
						_add_restritivo(offset, nome_restritivo)
					match (offset):
						Vector2i.UP:
							if neighbour_node.direction.contains("D"): nome.append("U")
							else: _add_restritivo(offset, nome_restritivo)
						Vector2i.DOWN:
							if neighbour_node.direction.contains("U"): nome.append("D")
							else: _add_restritivo(offset, nome_restritivo)
						Vector2i.RIGHT:
							if neighbour_node.direction.contains("L"): nome.append("R")
							else: _add_restritivo(offset, nome_restritivo)
						Vector2i.LEFT:
							if neighbour_node.direction.contains("R"): nome.append("L")
							else: _add_restritivo(offset, nome_restritivo)
				elif !dun.to_collapse.has(neighbour):
					dun.to_collapse.append(neighbour)
			else:
				_add_restritivo(offset, nome_restritivo)
		
		_apenas_compativeis(potential_nodes, nome, nome_restritivo)
		
		if (potential_nodes.size() <= 0):
			if (initial):
				var init_node: GridNode = dun.nodes.pick_random().duplicate()
				dun.node_grid[atual.y][atual.x] = init_node
				dun.salas += init_node.direction.length()
				initial = false
			else:
				dun.node_grid[atual.y][atual.x] = GridNode.EMPTY
		else:
			var random_node
			if (dun.salas < dun.rooms_amount):
				potential_nodes.sort_custom(func (a, b): return a.direction.length() > b.direction.length())
				random_node = randi_range(0, floori(potential_nodes.size() / 2))
			else:
				potential_nodes.sort_custom(func (a, b): return a.direction.length() < b.direction.length())
				random_node = 0
			
			var new_node: GridNode = potential_nodes[random_node].duplicate()
			dun.salas += new_node.direction.length() - 1
			dun.node_grid[atual.y][atual.x] = new_node

static func _apenas_compativeis(potentials: Array[GridNode], nome: Array[String], restritivo: Array[String]):
	if (nome.size() == 0):
		potentials.clear()
		return
	for i in range(potentials.size() - 1, -1, -1):
		var includes = nome.all(func (l): return potentials[i].direction.contains(l))
		var excludes = restritivo.any(func (l): return potentials[i].direction.contains(l))
		if (!includes || excludes):
			potentials.remove_at(i)

static func _is_inside(point: Vector2i, dun: Dungeon):
	return (point.x >= 0 && point.x < dun.rooms_width && point.y >= 0 && point.y < dun.rooms_height)

static func _add_restritivo(offset: Vector2i, nome_restritivo: Array[String]):
	nome_restritivo.append(OFFSET_LETTER[offset])
