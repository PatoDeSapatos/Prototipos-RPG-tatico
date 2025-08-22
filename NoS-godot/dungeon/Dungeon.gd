class_name Dungeon extends Object

var dungeon_table: Dictionary
var rooms_amount: int
var to_collapse: Array[Vector2i] = []
var nodes := LoadMapNodes.load_map_nodes()
var salas := 1
var node_grid: Array[Array] = []
var rooms_width := Game.WIDTH / Game.ROOM_SIZE
var rooms_height := Game.HEIGHT / Game.ROOM_SIZE
var init_x := -1
var init_y := -1

func _init(dungeon_table: Dictionary):
	self.dungeon_table = dungeon_table
	self.rooms_amount = dungeon_table["rooms_amount"]
	
	for i in rooms_height :
		var row := []
		row.resize(rooms_width)
		node_grid.append(row)
