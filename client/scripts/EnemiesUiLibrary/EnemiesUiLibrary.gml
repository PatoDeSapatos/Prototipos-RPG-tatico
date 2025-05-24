function enemy_give_turn(_id, _give_extra_chance) {
	var _give_extra = false;
	var _possible_gives = [];
	
	with(obj_battle_manager) {
		if (!extra_turn_given && extra_action) {
			if (irandom_range(1, 100) >= _give_extra_chance) {
				_give_extra = true;
			}
		}
			
		if (_give_extra) {
			var _filter = function(_unit) {
				return _unit.unit.is_enemy && _unit != user.id;
			}

			_possible_gives = array_filter(units, method({user: _id}, _filter));
			
			if (array_length(_possible_gives) <= 0) {
				_give_extra = false;
			}	
		}
	}
	
	if (_give_extra) {
		var _target = _possible_gives[irandom_range(0, array_length(_possible_gives)-1)];
			
		with (obj_battle_manager) {
			main_actions = 1;
			extra_turn_user.ready = true;
			extra_turn_user = _target;
			obj_camera.follow = _target;
			extra_turn_given = true
		}
	}
	
	return _give_extra
}

function entity_move_to(_entity, _target) {
	with (_entity) {
		var _path = [];
		with (obj_battle_manager) {
			_path = get_shortest_path_array(grid, _entity.unit.position.x, _entity.unit.position.y, _target.unit.position.x, _target.unit.position.y, true);
		}
		
		if (array_length(_path) > unit.enemy_info.movement) {
			array_resize(_path, unit.enemy_info.movement);
		}
		
		array_resize(_path, array_length(_path) - 1);
		move_unit_path(self, array_filter(_path, function(_value) {
			return is_array(_value);	
		}));
	}
}

global.enemy_ui = {
	simple: function(_id) {
		var _give_extra = enemy_give_turn(_id, 50);
		
		var _can_move = !obj_battle_manager.extra_action;

		var _target;

		if (!_give_extra) {			
			with (_id) {
				// Tame
				var _info = unit.enemy_info
				
				if (struct_exists(_info, "tameable") && struct_exists(_info, "tame_prop") && _info.tameable && _info.tame_condition(_id)) {
					var _target_prop = unit.enemy_info.tame_prop
					var _tame_prop = noone
				
					with(obj_battle_prop) {
						show_debug_message("info: {0}, target: {1}", prop_info.name, _target_prop.name)
						if (prop_info.name == _target_prop.name) {
							_tame_prop = self	
							break
						}
					}
					
					if (_tame_prop != noone) {
						var _in_range = _can_move ? (calc_unit_distance(_id, _tame_prop) < _info.movement + 2) : (calc_unit_distance(_id, _tame_prop) < 2);
				
						if (_can_move) {
							entity_move_to(_id, _tame_prop)
						}
					
						if (_in_range) {
							ready = true
							unit_use_action(global.actions.tame, _id, [_tame_prop], _tame_prop.unit.position, noone);
											
							obj_battle_manager.main_actions--;
							obj_battle_manager.extra_action = false;
						}
						
						return;
					}
				}
				
				// Attack random unit
				var _possible_targets = array_filter(obj_battle_manager.units, function(_unit) {
					return (!_unit.unit.is_enemy && !_unit.is_dead);
				});
		
				if (array_length(_possible_targets) <= 0) {
					ready = true;
					return;
				}
		
				var _distances = [];
		
				for (var i = 0; i < array_length(_possible_targets); ++i) {
					_target = _possible_targets[i];
			
					var _distance = calc_unit_distance(_id, _target);
					array_push(_distances, [_distance, _target])
				}
		
				array_sort(_distances, function (a, b) {
					return a[0]-b[0];
				});
			
				_target = _distances[0, 1];
		
				if (array_length(_possible_targets) > 1) {
					var _in_range = _can_move ? (_distances[1,0] < unit.enemy_info.movement + unit.enemy_info.actions[0].range) : (_distances[1,0] < unit.enemy_info.actions[0].range);
					_target = _distances[irandom_range(0, 1), 1];
				}
		
				if (_can_move) {
					entity_move_to(_id, _target)
				}
		
				ready = true;
				if (_in_range) {
					unit_use_action(unit.enemy_info.actions[0], _id, [_target], _target.unit.position, noone);
				}
				
				obj_battle_manager.main_actions--;
				obj_battle_manager.extra_action = false;
			}
		}
	} 
}