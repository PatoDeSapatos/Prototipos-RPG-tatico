extends Node2D

var manager: BattleManager

func assign_manager(manager):
	self.manager = manager

func unit_get_stats(unit: BattleUnitInfo, stat_name: String):
	if (unit.stats == null):
		return null
	
	var stat = unit.stats[stat_name]
	var change = unit.stat_changes[stat_name] if unit.stat_changes != null else 0
	const rate = 4
	
	return stat * ((rate + max(0, change))/(rate + min(0, change)))

func change_unit_hp(target: BattleUnitInfo, amount: int):
	target.hp = clamp(target.hp + amount, 0, target.stats.hp)

func unit_take_damage(damage: int, user: BattleUnit, target: BattleUnit, action: Action):
	var defense = unit_get_stats(target.info, "defense") if action.is_physical else unit_get_stats(target.info, "magic_defense")
	var guard = 1.5 if target.is_guarding else 1
	var resistence_multiplier = 0
	
	for type in action.types:
		if (target.weakness.count(type) > 0):
			resistence_multiplier += 1
		if (target.resistences.count(type) > 0):
			resistence_multiplier -= 1
	
	if (!target.is_broken && resistence_multiplier > 0 && guard < 1):
		target.is_broken = true
		manager.extra_turn_given = false
		manager.extra_action = true
		manager.extra_turn_user = user
	
	var final_damage = round((damage - (defense*guard/(defense + 100))))
	final_damage = round(final_damage + final_damage*resistence_multiplier*0.5)
	
	if (final_damage > 0):
		target.focus = false
	
	change_unit_hp(target.info, -final_damage)

func aim_action(action: Action):
	manager.set_targeting_state(action)

func get_user() -> BattleUnit:
	return manager.units[manager.turn] if !manager.extra_action else manager.extra_turn_user

func calc_unit_distance(unit1: BattleUnitInfo, unit2: BattleUnitInfo):
	return floor(sqrt((unit1.grid_pos.x - unit2.grid_pos.x)**2 + (unit1.grid_pos.y - unit2.grid_pos.y)**2))

func get_state() -> Callable:
	return manager.state

func set_state(new_state: Callable):
	manager.state = new_state

func return_to_prev_state():
	manager.state = manager.prev_state

func exit_state_turn(new_state: Callable):
	manager.prev_state = manager.state
	manager.state = new_state

func unit_use_action(action: Action, user: BattleUnit, targets: Array[BattleUnit], origin_point: Vector2):
	pass
