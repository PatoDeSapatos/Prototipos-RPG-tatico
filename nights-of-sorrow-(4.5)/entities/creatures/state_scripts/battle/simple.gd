class_name Simple extends BattleStateScript

func execute():
	if (!super()):
		return
	
	if (manager.animating):
		return 
	
	var action: Action = unit.info.basic_attack
	var target: BattleUnit = choose_closest_target(action)
	
	if (manager.movement_actions > 0 && target != null):
		BattleHandler.move_unit(unit, Vector2(unit.info.grid_pos), Vector2(target.info.grid_pos))
		manager.movement_actions -= 1
	
	if (manager.main_actions > 0):
		if (BattleHandler.calc_unit_distance(unit.info, target.info) <= action.range):
			BattleHandler.unit_use_action(unit.info.basic_attack, unit, [target], unit.info.basic_attack.area)
		elif (manager.movement_actions <= 0):
			manager.set_unit_done(manager.host_id)
