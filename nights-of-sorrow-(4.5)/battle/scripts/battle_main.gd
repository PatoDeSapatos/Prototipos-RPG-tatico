extends Node2D

const BATTLE_MANAGER = preload("res://battle/entities/BattleManager/BattleManager.tscn")

func _ready() -> void:
	init_demo_battle(Vector2(10, 10))

func init_battle(grid, party, enemies, host_name):
	var manager = BATTLE_MANAGER.instantiate()
	
	manager.grid = grid
	manager.party_info = party
	manager.enemies_info = enemies
	
	add_child(manager)

func init_demo_battle(grid_size : Vector2):
	var grid : Array
	
	var party = []
	var pos_offset = 0
	for key in NetworkHandler.players.keys():
		var unit = NetworkHandler.players[key].unit
		if (unit is EncodedObjectAsID):
			unit = instance_from_id(unit.get_object_id())
			
		unit.grid_pos = Vector2(0, pos_offset)
		party.push_back(unit)
		pos_offset += 1
	
	var enemy1 = EnemyUnitInfo.createe(
		"slime",
		Vector2(1, 2), 
		Stats.create(), 
		1000,
		0,
		10
		)
	
	var enemy2 = EnemyUnitInfo.createe(
		"slime",
		Vector2(1, 1), 
		Stats.create(), 
		1000,
		0,
		10
		)
	
	for y in grid_size.y:
		grid.append([])
		for x in grid_size.x:
			grid[y].append(TileInfo.new(1))
	
	init_battle(grid, party, [enemy1, enemy2], NetworkHandler.username)
