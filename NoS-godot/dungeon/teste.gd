extends Node

func _ready() -> void:
	var raw := DungeonGenerator.generate_dungeon()
	
	for i in raw.rooms_height:
		var string = ""
		for j in raw.rooms_width:
			string += (raw.node_grid[i][j].args[0].to_upper() if raw.node_grid[i][j].args.size() else "_").lpad(2, " ")
		print(string)
	print("vvv")
	
	for i in raw.rooms_height:
		var string = ""
		for j in raw.rooms_width:
			string += ("_" if raw.node_grid[i][j].spawn == -1 else Tables.Spawns.keys()[raw.node_grid[i][j].spawn]).substr(0, 1).lpad(2, " ")
		print(string)
	print("vvv")
	
	var rev = DungeonReviewer.review_dungeon(raw)
	for i in rev.rooms_height:
		var string = ""
		for j in rev.rooms_width:
			string += ("_" if rev.node_grid[i][j].spawn == -1 else Tables.Spawns.keys()[rev.node_grid[i][j].spawn]).substr(0, 1).lpad(2, " ")
		print(string)
	
	DungeonCast.cast_dungeon(rev)
