extends Node2D

const ACTION_EFFECTS = preload("res://entities/actions/ActionEffects.tscn")
const FLOATING_TEXT = preload("res://battle/ui/floating_text.tscn")
var manager: BattleManager
var cutscenes: CutsceneHandler

func assign_manager(manager):
	self.manager = manager
	self.cutscenes = CutsceneHandler.new(manager)

func unit_get_stats(unit: BattleUnitInfo, stat_name: String):
	if (unit.stats == null):
		return null
	
	var stat = unit.stats[stat_name]
	var change = unit.stat_changes[stat_name] if unit.stat_changes != null else 0
	const rate = 4
	return stat * ((rate + max(0, change))/(rate + min(0, change)))

func change_unit_hp(target: BattleUnit, amount: int, custom_color = null):
	if (amount == 0):
		return
	
	target.info.hp = target.info.hp + amount
	var color = Palette.green if amount > 0 else Color.WHITE
	if (custom_color != null):
		color = custom_color
	
	create_floating_text(amount, target.global_position, color)

func change_unit_stats(target: BattleUnit, stat_name: String, amount: int) -> void:
	if (amount == 0):
		return
	
	var cap = 6
	var current_changes = target.info.stat_changes.get(stat_name)
	target.info.stat_changes[stat_name] = clamp(target.info.stat_changes[stat_name] + amount, -cap, cap)

func unit_take_damage(damage: int, user: BattleUnit, target: BattleUnit, action: Action):
	var defense = unit_get_stats(target.info, "defense") if action.is_physical else unit_get_stats(target.info, "magic_defense")
	var guard = 1.5 if target.info.is_guarding else 1
	var resistence_multiplier = 0
	
	for type in action.types:
		if (type in target.info.weakness):
			resistence_multiplier += 1
		if (type in target.info.resistences):
			resistence_multiplier -= 1
	
	if (!target.info.is_broken && resistence_multiplier > 0 && guard <= 1):
		target.info.is_broken = true
		manager.extra_turn_given = false
		manager.extra_action = true
		manager.extra_turn_user = user
	
	var final_damage = round((damage - (defense*guard/(defense + 100))))
	final_damage = round(final_damage + final_damage*resistence_multiplier*0.5)
	
	if (final_damage > 0):
		target.focus = false

	change_unit_hp(target, -final_damage)

func calc_action_default_damage(action: Action, user: BattleUnit) -> int:
	if (action.power <= 0):
		return 0
	
	var attack = unit_get_stats(user.info, "attack") if action.is_physical else unit_get_stats(user.info, "magic_attack")
	return round((2*user.info.level/2 + 2 + attack) * action.power/50 + 2)

func aim_action(action: Action):
	manager.set_targeting_state(action)

func create_floating_text(value, position: Vector2, color: Color = Color.WHITE):
	var text = FLOATING_TEXT.instantiate()
	text.value = value
	text.position = position
	text.color = color
	add_child(text)

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

func get_units_in_area(area: ActionArea) -> Array[BattleUnit]:
	if (area == null):
		return []
	
	var res: Array[BattleUnit] = []
	for unit in manager.units:
		if (area.point_in_area(unit.info.grid_pos)):
			res.push_back(unit)
	
	return res

func set_unit_hover(unit: BattleUnit):
	manager.unit_hover = unit

func unit_inflict_condition(target:BattleUnit, condition_name: String, chance: int) -> bool:
	var sucess = randi_range(0, 100) <= chance
	if (!sucess):
		return sucess
	
	target.info.condition = condition_name
	return sucess

@rpc("any_peer", "call_local", "reliable")
func battle_create_cutscene(cutscene: Array):
	var desserial: Array = CutsceneHandler.desserialize(cutscene)
	manager.set_unit_done.rpc(NetworkHandler.peer_id, false)
	desserial.push_back(["set_unit_done", NetworkHandler.peer_id, true])
	manager.cutscene.append_array(desserial)

func get_use_action_params(action: Action, user: BattleUnit, targets: Array[BattleUnit], area: ActionArea) -> Array:
	var res = [action.to_dict(), str(user.get_path()), targets.map(func (e: BattleUnit): return str(e.get_path())), area.to_dict() if area != null else ActionArea.new().to_dict()]
	
	return res.map(func(e): 
		if(e is Dictionary):
			return JSON.stringify(e)
		else:
			return e
		)

func unit_use_action(action: Action, user: BattleUnit, targets: Array[BattleUnit], area: ActionArea):
	var cutscene: Array = []
	
	if (action.user_effect):
		cutscene.push_back(["create_battle_effect", action.user_effect, user.get_effect_origin_position(), 0, false])

	cutscene.push_back(["play_animation", user, action.user_animation])
	cutscene.push_back(["clear_effect_by_name", action.user_effect])
	
	var inflict_condition = func(target: BattleUnit, action: Action) -> Array:
		if (action.condition_name == ""):
			return []
		
		var inflicted = unit_inflict_condition(target, action.condition_name, action.inflict_chance)
		var condition: StatusCondition = Conditions.condition_library.get(action.condition_name)
		if (inflicted && condition != null):
			return ["play_animation", target, condition.target_animation]
		
		return []
		
	# Projectile
	if (action.has_projectile):
		var pos = Grid.tile_to_scene_pos(area.origin_point.x, area.origin_point.y, manager.init_pos)
		cutscene.push_back(["cast_projectile", action.projectile_texture, user.position, pos, action.projectile_particle_path])
		
		if (action.projectile_texture != null && action.projectile_effect_name != null):
			var effect_scale = ((action.area.range * Game.TILE_SIZE)/(action.projectile_texture.get_size().x))*2
			cutscene.push_back(["create_battle_effect", action.projectile_effect_name, pos, 1000, false])
		
		for path in action.particle_effect_paths:
			cutscene.push_back(["instantiate_scene", path, pos, {"z_index": 999}])
			cutscene.push_back(["wait", 0.1])
	
	# Apply effects on target
	if (!action.apply_effects_at_once):
		for target in targets:
			cutscene.push_back(["cast_action_func", action, user, [target], area])
			cutscene.push_back(["play_animation", target, action.target_animation])
	else:
		cutscene.push_back(["cast_action_func", action, user, targets, area])
		cutscene.push_back(["play_multiple_animations", targets, action.target_animation])

	# Stat Changes
	var create_stat_change_cutscene = func(targets: Array, is_on_user: bool):
		var stat_changes = action.on_user_stat_changes if is_on_user else action.on_target_stat_changes
		var change_chances = action.on_user_change_chances if is_on_user else action.on_target_change_chances
		var change_levels = action.on_user_change_levels if is_on_user else action.on_target_change_levels
		
		for target: BattleUnit in targets:
			for i in stat_changes.size():
				if (randi_range(0, 100) <= change_chances[i]):
					var effect = "stat_raise" if change_levels[i] > 0 else "stat_decrease"
					cutscene.push_back(["change_stats", target, stat_changes[i], change_levels[i]])
					cutscene.push_back(["create_battle_effect", effect, target.get_effect_origin_position(), target.z_index, true])

	create_stat_change_cutscene.call([user], true)
	create_stat_change_cutscene.call(targets, false)

	# Inflict Condiction
	for target in targets:
		var condition_cutscene: Array = inflict_condition.call(target, action)
		if (condition_cutscene.size() > 0):
			cutscene.push_back(condition_cutscene)
	
	cutscene.push_back(["wait", 0.7])
	cutscene.push_back(["subtract_turn_step", action.turn_step])
	
	var serialized = cutscenes.serialize(cutscene)
	battle_create_cutscene.rpc(serialized)

func create_battle_effect(effect_name: String, pos: Vector2, z_index=0) -> ActionEffects:
	var effect = ACTION_EFFECTS.instantiate()
	effect.z_index = z_index
	add_child(effect)
	effect.play(effect_name, pos)
	return effect

func move_unit(user: BattleUnit, from: Vector2, to: Vector2):
	var cutscene = []
	var path = manager.astar_grid.get_id_path(from, to, true)
	var move_range = ActionArea.new(user.info.movement, ActionArea.Shapes.CIRCLE, user.info.grid_pos)
	
	path = path.filter(func(step):
		return move_range.point_in_area(step) && !manager.astar_grid.is_point_solid(step)
		)
	
	for step in path:
		cutscene.push_back(["move_unit", user, Grid.tile_to_scene_pos(step.x, step.y, manager.init_pos), 0.6])
		cutscene.push_back(["wait", 0.01])
	
	cutscene.push_back(["end_movement", user, from, to])
	battle_create_cutscene.rpc(cutscenes.serialize(cutscene))
