function Stats(_hp = 0, _defense = 0, _magic_defense = 0, _attack = 0, _magic_attack = 0, _spd = 0, _luck = 0, _mana = 0, _energy = 0) constructor {
	hp = _hp;
	defense = _defense;
	magic_defense = _magic_defense;
	attack = _attack;
	magic_attack = _magic_attack;
	spd = _spd;
	luck = _luck;
	mana = _mana;
	energy = _energy;
}

function get_stat_display_name(_key) {
	switch (_key) {
		case "hp":
			return "Health";
		case "defense":
			return "Defense";
		case "magic_defense":
			return "Magic Defense";
		case "attack":
			return "Attack";
		case "magic_attack":
			return "Magic Attack";
		case "spd":
			return "Speed";
		case "luck":
			return "Luck";
		case "mana":
			return "Mana";
		case "energy":
			return "Energy";
		default:
			return _key;
	}
}