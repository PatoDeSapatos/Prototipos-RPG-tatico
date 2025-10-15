class_name EnemyUnitInfo extends BattleUnitInfo

@warning_ignore("shadowed_variable_base_class")
static func createe(enemy_id, position, stat_changes, hp, mana, energy, condition=null, passives=[]) -> BattleUnitInfo:
	var info : Creature = load("res://entities/creatures/" + enemy_id + ".tres")
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
	obj.is_player = false
	obj.is_enemy = true
	
	obj.state_machine = info.state_machine
	obj.state = info.state_machine.states[info.state_machine.initial_state_index]
	return obj
