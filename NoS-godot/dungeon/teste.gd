extends Node

func _ready() -> void:
	var dun := DungeonGenerator.generate_dungeon()
	DungeonReviewer.review_dungeon(dun)
	DungeonCast.cast_dungeon(dun)
	
	for i in dun.rooms_height:
		var string = ""
		for j in dun.rooms_width:
			string += (dun.node_grid[i][j].args[0].to_upper() if dun.node_grid[i][j].args.size() else "_").lpad(2, " ")
		print(string)
	print("vvv")
	
	for i in dun.rooms_height:
		var string = ""
		for j in dun.rooms_width:
			string += ("_" if dun.node_grid[i][j].spawn == -1 else Tables.Spawns.keys()[dun.node_grid[i][j].spawn]).substr(0, 1).lpad(2, " ")
		print(string)
