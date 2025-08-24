extends Node

func _ready() -> void:
	var raw := DungeonGenerator.generate_dungeon()
	
	for i in raw.rooms_height:
		var str = ""
		for j in raw.rooms_width:
			str += ("_" if raw.node_grid[i][j].spawn == -1 else Tables.Spawns.keys()[raw.node_grid[i][j].spawn]).substr(0, 1).lpad(2, " ")
		print(str)
	print("vvv")
	
	var rev = DungeonReviewer.review_dungeon(raw)
	for i in rev.rooms_height:
		var str = ""
		for j in rev.rooms_width:
			str += ("_" if rev.node_grid[i][j].spawn == -1 else Tables.Spawns.keys()[rev.node_grid[i][j].spawn]).substr(0, 1).lpad(2, " ")
		print(str)
