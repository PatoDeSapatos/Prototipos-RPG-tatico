extends Node

func _ready() -> void:
	var d = DungeonGenerator.generate_dungeon()
	
	for i in d.rooms_height:
		var str = ""
		for j in d.rooms_width:
			str += (d.node_grid[i][j].direction as String).lpad(4, " ")
		print(str)
