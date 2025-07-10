extends Node2D

const BATTLE_MANAGER = preload("res://battle/entities/BattleManager/BattleManager.tscn")

func _ready() -> void:
	init_demo_battle(Vector2(10, 10))

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
		"res://entities/PlayerCharAnimator.tscn",
		7,
		[],
		[],
		[],
		null,
		Server.username,
		Stats.new()
		)
	
	var enemy1 = EnemyUnitInfo.new(
		"slime",
		Vector2(1, 1), 
		Stats.new(25, 0, 10), 
		25,
		0,
		10
		)
	
	for y in grid_size.y:
		grid.append([])
		for x in grid_size.x:
			grid[y].append(Tile.new(1))
	
	init_battle(grid, [unit1], [enemy1], Server.username)
