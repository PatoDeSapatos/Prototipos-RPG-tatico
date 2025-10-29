class_name BattleStateScript extends Serializable

var unit: BattleUnit
var manager: BattleManager

func filter_enemies(target: BattleUnit):
	return target.info.is_enemy

func filter_party(target: BattleUnit):
	return !target.info.is_enemy

func choose_closest_target(action: Action):
	var possible_targets: Array = manager.units
	
	if (action.prioritize_enemies && unit.info.is_enemy):
		possible_targets = possible_targets.filter(filter_party)
	else:
		possible_targets = possible_targets.filter(filter_enemies)
	
	if (possible_targets.size() <= 0):
		return null
	
	var distance = BattleHandler.calc_unit_distance(unit.info, possible_targets[0].info)
	var target = possible_targets[0]
	for t in possible_targets:
		var new_dist = BattleHandler.calc_unit_distance(unit.info, t.info)
		if (new_dist < distance):
			distance = new_dist
			target = t
	
	return target

func assing_info(unit: BattleUnit, manager: BattleManager):
	self.unit = unit
	self.manager = manager

func execute() -> bool:
	if (unit == null || manager == null):
		print("Trying to execute battle script with no info.")
		return false
	
	return true
