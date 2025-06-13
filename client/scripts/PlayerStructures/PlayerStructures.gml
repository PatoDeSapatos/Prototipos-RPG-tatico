function Equipment_Set(_head = noone, _body = noone, _legs = noone, _hand1 = noone, _hand2 = noone, _accessorie1 = noone, _accessorie2 = noone, _accessorie3 = noone) constructor {
	head = _head;
	body = _body;
	legs = _legs;
	hand1 = _hand1;
	hand2 = _hand2;
	accessorie1 = _accessorie1;
	accessorie2 = _accessorie2;
	accessorie3 = _accessorie3;
}

function Player(_equipment, _base_stats, _inventory) constructor {
	equipment = _equipment;
	base_stats = _base_stats;
	inventory = _inventory;
}