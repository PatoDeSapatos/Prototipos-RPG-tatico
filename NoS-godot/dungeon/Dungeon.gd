class_name Dungeon extends Object

var type: Tables.DungeonType
var level: int
var dungeon_table: Dictionary
var rooms_amount: int
var to_collapse: Array[Vector2i] = []
var nodes := Game.MAP_NODES
var salas := 1
var node_grid: Array[Array] = []
var tile_grid: Array[Array] = []
var rooms_width := Game.WIDTH / Game.ROOM_SIZE
var rooms_height := Game.HEIGHT / Game.ROOM_SIZE
var init_pos = Vector2(-1, -1)

func _init(dungeon_type: Tables.DungeonType, level := 1):
	self.type = dungeon_type
	self.level = level
	self.dungeon_table = Tables.get_dungeon_table(dungeon_type, level)
	self.rooms_amount = dungeon_table["rooms_amount"]
	
	for i in rooms_height:
		var row := []
		row.resize(rooms_width)
		node_grid.append(row)
	
	for i in Game.HEIGHT:
		var row := []
		row.resize(Game.WIDTH)
		tile_grid.append(row)
