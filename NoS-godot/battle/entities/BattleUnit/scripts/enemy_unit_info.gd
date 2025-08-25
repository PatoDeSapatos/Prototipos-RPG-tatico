class_name EnemyUnitInfo extends BattleUnitInfo

static func createe(enemy_id, position, stat_changes, hp, mana, energy, condition=null, passives=[]) -> BattleUnitInfo:
	var info : Enemy = load("res://entities/enemies/" + enemy_id + ".tres")
	var obj = super.create(
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
	return obj
