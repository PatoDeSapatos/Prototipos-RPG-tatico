class_name DungeonGenerator

func _init() -> void:
	LoadMapNodes.load_map_nodes()

func generate_dungeon(dungeon_type: Tables.DungeonType = -1, level := -1):
	if (dungeon_type == -1):
		dungeon_type = randi_range(0, Tables.DungeonType.size() - 1)
	
	var dungeon_table = Tables.get_dungeon_table(dungeon_type, level)
	
	var ambient := {
		"dungeon_table": dungeon_table,
		"rooms_amount": dungeon_table.rooms_amount,
		"offsets": [
			Vector2i.UP,
			Vector2i.DOWN,
			Vector2i.RIGHT,
			Vector2i.LEFT,
		],
		"offset_letter": [
			"U",
			"D",
			"R",
			"L"
		],
		"to_collapse": [],
		"nodes": [],
		"salas": 1,
		"node_grid": [],
		"rooms_width": Game.WIDTH / Game.ROOM_SIZE,
		"rooms_height": Game.HEIGHT / Game.ROOM_SIZE,
		"init_x": -1,
		"init_y": -1
	}
	
	collapse(ambient)

func collapse(a: Dictionary[String, Variant]):
	a["to_collapse"].append(Vector2i(a["rooms_width"] / 2, a["rooms_height"] / 2))
	var initial = true
	
	while (a["to_collapse"].size() > 0):
		pass

func isInside(point: Vector2i, a: Dictionary):
	return (point.x >= 0 && point.x < a["rooms_width"] && point.y >= 0 && point.y < a["rooms_height"])
