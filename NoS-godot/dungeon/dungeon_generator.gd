class_name DungeonGenerator

func _init() -> void:
	LoadMapNodes.load_map_nodes()

func generate_dungeon(dungeon_type: Tables.DungeonType = -1, level := -1):
	var room_size = Game.ROOM_SIZE
	
	if (dungeon_type == -1):
		dungeon_type = randi_range(0, Tables.DungeonType.size() - 1)
	
	var dungeon_table = Tables.get_dungeon_table(dungeon_type, level)
	
	var ambient := {
		"dungeon_table": dungeon_table,
		"rooms_amount": dungeon_table.rooms_amount,
		offsets: [
			Vector2i.UP,
			Vector2i.DOWN,
			Vector2i.RIGHT,
			Vector2i.LEFT,
		],
		offset_letter: [
			"U",
			"D",
			"R",
			"L"
		],
		to_collapse: [],
		nodes: [],
		salas: 1,
		node_grid: [],
		roomsWidth: obj_dungeon_manager.width div roomSize,
		roomsHeight: obj_dungeon_manager.height div roomSize,
		init_x: -1,
		init_y: -1
	}
	
	collapse()

func collapse():
	pass

func isInside(point: Vector2i):
	return (point.x >= 0 && point.x < roomsWidth && point.y >= 0 && point.y < roomsHeight)
