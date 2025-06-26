extends Node

const BATTLE_MANAGER = preload("res://battle/entities/BattleManager/BattleManager.tscn")

func init_battle(grid, party, enemies, host_name):
	var manager = BATTLE_MANAGER.instantiate()
	
	manager.grid = grid
	manager.party_info = party
	manager.enemies_info = enemies
	manager.host_name = host_name
	
	add_child(manager)

func init_demo_battle(grid_size : Vector2):
	var grid : Array
	
	var unit1 = PartyUnitInfo.new(
		Vector2(0, 0),
		Stats.new(100, 100, 100),
		100,
		100,
		100,
		[],
		[],
		7,
		[],
		[],
		[],
		null,
		"",
		{}
		)
	
	for y in grid_size.y:
		grid.append([])
		for x in grid_size.x:
			grid[y].append(Tile.new(1))
	
	init_battle(grid, [unit1], [], Server.username)
