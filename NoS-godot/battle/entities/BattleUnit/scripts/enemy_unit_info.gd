class_name EnemyUnitInfo extends BattleUnitInfo

func _init(enemy_id, position, stat_changes, hp, mana, energy, condition=null, passives=[]) -> void:
	var info : Enemy = load("res://entities/enemies/" + enemy_id + ".tres")
	
	super(
		position, 
		stat_changes, 
		info.stats,
		hp,
		mana,
		energy,
		[],
		info.animator_path,
		info.movement,
		info.weakness,
		info.resistences,
		info.immunities,
		info.basic_attack,
		condition, 
		passives,
	)
