class_name PartyUnitInfo extends BattleUnitInfo

@export_category("Unit Resources")
@export var hp : int
@export var mana : int
@export var energy : int

@export var username : String
@export var stats : Stats

@export var inventory : Array
@export var movement : int
@export var weakness : Array
@export var resistences : Array
@export var immunities : Array
@export var skills : Array
@export var companions : Array
@export var max_companions : int

var sprites
var basic_attack
var is_player : bool
var is_enemy : bool
var focus

func _init(_position, _stats, _hp, _mana, _energy, _inventory, _sprites, _movement, _weakness, _resistences, _immunities, _basic_attack, _player_username, _stat_changes, _companions=[], _max_companions=1, _condition = null, _passives = []) -> void:
	super(_position, _stat_changes, _condition, _passives)
	username = _player_username;
	stats = _stats;
	hp = _hp;
	mana = _mana;
	energy = _energy;
	inventory = _inventory;
	sprites = _sprites;
	movement = _movement;
	weakness = _weakness;
	resistences = _resistences;
	immunities = _immunities;
	basic_attack = _basic_attack;
	is_player = _player_username == Server.username;
	companions = _companions
	max_companions = _max_companions
	is_enemy = false;
	focus = false;
