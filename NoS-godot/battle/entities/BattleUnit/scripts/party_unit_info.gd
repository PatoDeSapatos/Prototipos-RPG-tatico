class_name PartyUnitInfo extends BattleUnitInfo

@export var username: String
@export var companions: Array
@export var max_companions: int
var peer_id: int

static func create(_position, _stats, _hp, _mana, _energy, _inventory, _animator_path, _movement, _weakness, _resistences, _immunities, _basic_attack, _player_username, _stat_changes=Stats.create(), _companions=[], _max_companions=1, _condition = null, _passives = []) -> BattleUnitInfo:
	var obj := PartyUnitInfo.new()
	
	var data = super(
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
	
	var dict = data.to_dict()
	dict["_type"] = "res://battle/entities/BattleUnit/scripts/party_unit_info.gd"
	obj = PartyUnitInfo.from_dict(dict)
	
	obj.peer_id = NetworkHandler.multiplayer.get_unique_id()
	obj.username = _player_username
	obj.is_player = true
	obj.is_enemy = false
	return obj
