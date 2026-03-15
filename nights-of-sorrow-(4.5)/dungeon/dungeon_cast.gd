class_name DungeonCast

const TILE = preload("res://entities/Tile.tscn")

static func cast_dungeon(dun: Dungeon):
	var map = Image.create_empty(Game.WIDTH, Game.HEIGHT, false, Image.FORMAT_RGBA8)
	
	for y in dun.node_grid.size():
		for x in dun.node_grid[y].size():
			var node: GridNode = dun.node_grid[y][x]
			if (node == GridNode.EMPTY): continue
			var image_rect = Rect2i(0, 0, node.image.get_width(), node.image.get_height())
			map.blit_rect(node.image, image_rect, Vector2i(x * Game.ROOM_SIZE, y * Game.ROOM_SIZE))
	
	map.save_png(Game.GENERATED_RESOURCES + "map.png")
	
	for y in map.get_height():
		for x in map.get_width():
			var pixel = map.get_pixel(x, y)
			var tile_info: TileInfo
			var tile: Tile
			
			var wall_color = Color.from_rgba8(255, 0, 64) # BGR 4194559
			var floor_color = Color.from_rgba8(51, 31, 33) # BGR 2170681
			var chest_color = Color.from_rgba8(153, 0, 255) # BGR 16711833
			var spawn_color = Color.from_rgba8(255, 255, 0) # BGR 65535
			
			match pixel:
				wall_color:
					tile_info = TileInfo.new(0, dun.type, ["res://entities/Wall.tscn"])
					tile = TILE.instantiate()
					tile.coll = true
				floor_color:
					tile_info = TileInfo.new(1, dun.type)
					tile = TILE.instantiate()
				chest_color:
					tile_info = TileInfo.new(1, dun.type)
					tile = TILE.instantiate()
					
					var _chest_spawn = randi_range(0, 99) < dun.dungeon_table["chest_spawn"]
					if (_chest_spawn):
						tile.coll = true
						tile_info.stack.append("res://entities/Chest.tscn")
				spawn_color:
					tile_info = TileInfo.new(1, dun.type)
					tile = TILE.instantiate()
					tile.coll = true
					
					var _room = dun.node_grid[y / Game.ROOM_SIZE][x / Game.ROOM_SIZE]
					if (_room.spawn != -1):
						match (_room.spawn):
							Tables.Spawns.INITIAL:
								tile.coll = false
							Tables.Spawns.END:
								pass
								#tile_info.image_number = 7
								#tile.stack.append(obj_exit)
							Tables.Spawns.MERCADOR:
								tile.coll = false
								#tile.stack.append(obj_npc_test)
			
			if (tile_info == null): continue
			tile.tile_info = tile_info
			dun.tile_grid[y][x] = tile
