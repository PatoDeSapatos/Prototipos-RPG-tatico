function Enemy(_idle_spr, _walking_spr, _init_state) constructor {
	idle_spr = _idle_spr;
	walking_spr = _walking_spr;
	init_state = _init_state;
}

function get_enemy(_id) {
	if ( ds_map_exists(global.enemies, _id) ) {
		return ds_map_find_value(global.enemies, _id);
	}
	
	return undefined;
}

function instantiate_enemy(_x, _y, _id) {
	var _enemy = get_enemy(_id);
	
	if (!is_undefined(_enemy)) {
		instance_create_layer(_x, _y, "Instances", obj_dungeon_enemy, {
			dungeon_stats: _enemy
		});
	}
}

function init_enemies() {
	var _map = ds_map_create();
	
	// Slime
	ds_map_add(_map, "SLIME", new Enemy(
		spr_slime_idle,
		spr_slime_idle,
		enemy_chase_idle
	));
	
	return _map;
}
