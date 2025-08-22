class_name Tables

enum DungeonType {
	DEFAULT
}

enum Spawns {
	INITIAL,
	END,
	MERCADOR
}

static var _spawnables = [
	[Spawns.MERCADOR, 0.5]
]

static var _tables: Dictionary[DungeonType, Callable] = {
	DungeonType.DEFAULT: func (level: int):
		return {
		"chest_spawn": 20 + (0.5 * level),
		"rooms_amount": max(10, round(3.5 * level) + _spawnables.size()),
		"spawnables": _spawnables,
		#"items": get_default_items()
	}
}

static func get_dungeon_table(type: DungeonType, level: int) -> Dictionary:
	return _tables[type].call(level)
