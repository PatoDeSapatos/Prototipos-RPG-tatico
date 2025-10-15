class_name BattleUnitInfo extends Serializable

var in_target = false;
var is_guarding = false;

var is_broken = false;
var is_dead = false;
var animating = false;

var grid_pos: Vector2
var stat_changes: Stats
var condition
var passives: Array

var level: int = 1
var stats: Stats
var hp: int
var mana: int
var energy: int
var inventory: Array
var movement: int
var weakness: Array
var resistences: Array
var immunities: Array
var focus: bool
var is_enemy: bool
var basic_attack: Action
var animator
var is_player: bool
var state_machine: CreatureStateMachine
var state: CreatureState

static func create(_position, _stat_changes, _stats, _hp, _mana, _energy, _inventory, _animator_path, _movement, _weakness, _resistences, _immunities, _basic_attack, _condition = null, _passives = []) -> BattleUnitInfo:
	var obj = BattleUnitInfo.new()
	
	obj.grid_pos = _position
	obj.stat_changes = _stat_changes
	obj.condition = _condition
	obj.passives = _passives
	obj.stats = _stats;
	obj.hp = _hp;
	obj.mana = _mana;
	obj.energy = _energy;
	obj.inventory = _inventory;
	obj.animator = _animator_path;
	obj.movement = _movement;
	obj.weakness = _weakness;
	obj.resistences = _resistences;
	obj.immunities = _immunities;
	obj.basic_attack = _basic_attack;
	obj.focus = false;
	
	return obj

func _to_string() -> String:
	var result := ""
	result += "in_target: %s\n" % in_target
	result += "is_guarding: %s\n" % is_guarding
	result += "is_broken: %s\n" % is_broken
	result += "is_dead: %s\n" % is_dead
	result += "animating: %s\n" % animating
	result += "grid_pos: %s\n" % str(grid_pos)
	result += "stat_changes: %s\n" % str(stat_changes)
	result += "condition: %s\n" % str(condition)
	result += "passives: %s\n" % str(passives)
	result += "stats: %s\n" % (stats if stats != null else "null")
	result += "hp: %d\n" % hp
	result += "mana: %d\n" % mana
	result += "energy: %d\n" % energy
	result += "inventory: %s\n" % str(inventory)
	result += "movement: %d\n" % movement
	result += "weaknesses: %s\n" % str(weakness)
	result += "resistences: %s\n" % str(resistences)
	result += "immunities: %s\n" % str(immunities)
	result += "focus: %s\n" % focus
	result += "is_player: %s\n" % is_player
	result += "is_enemy: %s\n" % is_enemy
	result += "basic_attack: %s\n" % str(basic_attack)
	result += "animator: %s\n" % str(animator)
	return result
