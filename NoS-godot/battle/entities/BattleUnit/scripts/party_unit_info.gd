class_name PartyUnitInfo extends BattleUnitInfo

@export var username: String
@export var skills: Array
@export var companions: Array
@export var max_companions: int

func _init(_position, _stats, _hp, _mana, _energy, _inventory, _animator_path, _movement, _weakness, _resistences, _immunities, _basic_attack, _player_username, _stat_changes=Stats.new(), _companions=[], _max_companions=1, _condition = null, _passives = []) -> void:
	super(
		_position,
		_stat_changes,
		_stats,
		_hp, 
		_mana, 
		_energy, 
		_inventory, 
		_animator_path, 
		_movement, 
		_weakness, 
		_resistences, 
		_immunities, 
		_basic_attack,  
		_condition, 
		_passives
	)
	
	username = _player_username;
	is_player = _player_username == NetworkHandler.username
	is_enemy = false
