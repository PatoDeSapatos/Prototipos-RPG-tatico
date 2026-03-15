extends Node2D

const ACTION_EFFECTS = preload("res://entities/actions/ActionEffects.tscn")
const FLOATING_TEXT = preload("res://battle/ui/floating_text.tscn")
var manager: BattleManager
var cutscenes: CutsceneHandler

@warning_ignore("shadowed_variable")
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
	
	target.info.hp = clamp(target.info.hp + amount, 0, target.info.stats.hp)
	var color = Palette.green if amount > 0 else Color.WHITE
	if (custom_color != null):
		color = custom_color
	
	create_floating_text(amount, target.global_position, true, color)

func change_unit_source(target: BattleUnit, source: Source, amount: int, custom_color = null):
	if (amount == 0 || source == null):
		return
		
	var color = source.color
	var n = source.name.to_lower()
	
	if (n == "life"): n = "hp"
	if (target.info.get(n) + amount > target.info.stats.get(n)):
		amount = target.info.stats.get(n) - target.info.get(n)
		
	color = load("res://entities/actions/sources/" + source.name.to_lower() + ".tres").color
	target.info.set(n, clamp(target.info.get(n) + amount, 0, target.info.get(n)))
	
	if (amount == 0):
		return

	if (custom_color != null):
		color = custom_color
	
	create_floating_text(amount, target.global_position, false, color)

func change_unit_stats(target: BattleUnit, stat_name: String, amount: int) -> void:
	if (amount == 0):
		return
	
	var cap = 6
	var current_changes = target.info.stat_changes.get(stat_name)
	target.info.stat_changes[stat_name] = clamp(current_changes + amount, -cap, cap)

func unit_take_damage(damage: int, user: BattleUnit, target: BattleUnit, action: Action):
	var defense = unit_get_stats(target.info, "defense") if action.is_physical else unit_get_stats(target.info, "magic_defense")
	var guard = 1.5 if target.info.is_guarding else 1.0
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
	@warning_ignore("integer_division")
	return round((2*user.info.level/2 + 2 + attack) * action.power/50 + 2)

func aim_action(action: Action):
	manager.set_targeting_state(action)

func create_floating_text(value, pos: Vector2, has_gravity: bool, color: Color = Color.WHITE):
	var text = FLOATING_TEXT.instantiate()
	text.has_gravity = has_gravity
	text.value = value
	text.position = pos
	text.color = color
	add_child(text)

func get_user() -> BattleUnit:
	return manager.user

func calc_unit_distance(unit1: BattleUnitInfo, unit2: BattleUnitInfo):
	return floor(sqrt((unit1.grid_pos.x - unit2.grid_pos.x)**2 + (unit1.grid_pos.y - unit2.grid_pos.y)**2))

func get_state() -> Callable:
	return manager.state

func set_state(new_state: Callable):
	manager.state = new_state

func return_to_prev_state():
	manager.state = manager.prev_state

func exit_state_turn(new_state: Callable):
	manager.camera.zoom_target = Vector2.ONE
	manager.camera.offset_target = Vector2.ZERO
	
	manager.camera.hide_bar()
	
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
