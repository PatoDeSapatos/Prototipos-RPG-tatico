function Enemy(_display_name, _stats, _sprites, _init_state, _movement, _actions, _basic_attack, _weakness, _resistences, _immunities, _drops, _battle_script, _tameable, _tame_prop, _tame_condition) constructor {
	display_name = _display_name;
	stats = _stats;
	sprites = _sprites;
	init_state = _init_state;
	movement = _movement;
	actions = _actions;
	basic_attack = _basic_attack;
	weakness = _weakness;
	resistences = _resistences;
	immunities = _immunities;
	drops = _drops;
	battle_script = _battle_script;
	
	// Tame
	tameable = _tameable;
	tame_prop = _tame_prop;
	tame_condition = _tame_condition;
}

function Drop(_item_id, _quantity, _drop_chance) constructor {
	item_id = _item_id;
	quantity = _quantity;
	drop_chance = _drop_chance;
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
        
		var instance = instance_create_layer(_x, _y, "Instances", obj_dungeon_enemy, {
			dungeon_stats: _enemy
		});
        instance.set_uid(screenToTileX(_x, _y), screenToTileY(_x, _y))
        ds_map_set(obj_dungeon_manager.entities, instance.uid, instance)
	}
}

function init_enemies() {
	// Slime
	ds_map_add(global.enemies, "SLIME", new Enemy(
		"Slime",
		new Stats(10, 3, 5, 2, 0, 0, 0, 10, 10),
		{
			idle: spr_slime_idle,
			walking: spr_slime_idle,
			attack: spr_slime_attack,
			hurt: spr_slime_hurt,
			dying: spr_slime_dying,
			dead: spr_slime_dead
		},
		enemy_chase_idle,
		6,
		[global.actions.attack],
		global.basic_attacks.unarmed,
		[MOVE_TYPES.FIRE],
		[MOVE_TYPES.SLASHING],
		[MOVE_TYPES.POISON],
		[new Drop(0, 3, 33)],
		global.enemy_ui.simple,
		true,
		global.props.sticky_meal,
		function (_creature) {
			return _creature.unit.hp <= _creature.unit.max_hp/2
		}
	));
}
