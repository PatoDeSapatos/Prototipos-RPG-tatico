function battle_sort_by_speed(_u1, _u2) {
	return unit_get_stats(_u2, "spd") - unit_get_stats(_u1, "spd");
}

function battle_state_init() {
	current_waiting_frames++;
	
	if (current_waiting_frames >= waiting_frames) {
		array_sort(units, battle_sort_by_speed);
		state = battle_state_start_turn;
	}
}

function battle_state_start_turn() {
	if (battle_check_animating()) return;
	
	movement_actions = 1;
	main_actions = 1;
	
	with(obj_battle_unit) {
		if (!is_dead) {
			obj_battle_manager.grid[unit.position.x, unit.position.y].coll = true;
		}
	}
	
	battle_send_trigger(new StartTurnEvent(units[turns]))
	with (units[turns]) {
		var _to_remove = []
		
		for (var i = 0; i < array_length(unit.passives); ++i) {
			var _passive = unit.passives[i]
			
		    if (_passive.duration != -1) {
				_passive.duration -= 1
				
				if (_passive.duration <= 0) {
					array_push(_to_remove, i)
				}
			}
		}
		
		for (var i = 0; i < array_length(_to_remove); ++i) {
			add_battle_text(string("{0} {1}", units[turns].unit.name, unit.passives[_to_remove[i]].info.end_text))
		    array_delete(unit.passives, _to_remove[i], 1)
		} 
	}

	current_waiting_frames = 0;	
	obj_camera.follow = units[turns];
	units[turns].is_broken = false;
	units[turns].defended = false;
	
	if (units[turns].unit.hp <= 0) {
		add_battle_text( string("{0} is fainted.", units[turns].unit.name) );
		units[turns].ready = true;
		state = battle_state_waiting;
	} else if (units[turns].unit.is_player) {			
		state = battle_state_turn;
	} else if ( battle_host == obj_server.username && units[turns].unit.is_enemy ) {
		state = battle_state_enemy_turn;
	} else {
		state = battle_state_waiting;
	}
}

function battle_state_turn() {
			
	player_turn = true;
	battle_check_dead_units();
	
	check_charging();
	turn_camera();
	
	// Main Action
	if (main_actions > 0) {
		check_attack();
	}
	
	// End State
	if (!animating && (movement_actions <= 0 && main_actions <= 0 && special_actions <= 0) || units[turns].ready) {
		units[turns].ready = true;
		player_turn = false;
		exit_state_turn(battle_state_waiting);			
	}
}

function set_state_targeting(_action) {
	var _user = extra_action ? extra_turn_user : units[turns];
	selected_action = _action;
	action_targets = [];
	current_target = 0;
	prev_state = state;
	
	if (selected_action.range != -1) {
		var _range = selected_action.range;
		action_tiles = new Area(_user.unit.position.x, _user.unit.position.y, function(_x, _y, _player_x, _player_y, _range) {
			return sqrt(sqr(_player_x - _x) + sqr(_player_y - _y)) <= _range
		}, _range)
	}
	
	// Filter possible targets
	if (selected_action.targetRequired) {		
		action_possible_targets = array_filter(units, function(_unit) {
			var _user = extra_action ? extra_turn_user : units[turns];
			var _select = true;
			
			if (!struct_exists(selected_action, "targetDead") || !selected_action.targetDead) {
				_select = _select && _unit.unit.hp > 0;	
			}
			
			if (!struct_exists(selected_action, "targetSelf") || !selected_action.targetSelf) {
				_select = _select && _unit != _user;	
			}
			
			if (selected_action.range != -1) {
				_select = _select && calc_unit_distance(_user, _unit) <= selected_action.range;
			}
			
			return _select;
		});
		
		if (array_length(action_possible_targets) <= 0) {
			state = battle_state_turn;
			add_battle_text("No possible targets.");
			return;
		}
		
		if (struct_exists(selected_action, "prioritizeEnemies")) {
			array_sort(action_possible_targets, function (_unit) {
				return obj_battle_manager.selected_action.prioritizeEnemies ? !_unit.unit.is_enemy : _unit.unit.is_enemy;
			});	
		}
		
		if (instance_exists(unit_hover)) {
			array_sort(action_possible_targets, function (_unit) {
				return _unit == obj_battle_manager.unit_hover;
			});
		}
		
		if (!struct_exists(selected_action, "areaTarget") || !selected_action.areaTarget) {
			var _first_target = action_possible_targets[0];
			target_indicator = instance_create_depth(_first_target.x, _first_target.y, -10000, obj_target_indicator);
			target_indicator.target = _first_target;
		} else {
			action_origin.x = _user.unit.position.x;
			action_origin.y = _user.unit.position.y;
		}
	}
	
	state = battle_state_targeting;
}

function battle_state_targeting() {
	var _user = extra_action ? extra_turn_user : units[turns];
	turn_camera();
	
	// No target action
	if (!selected_action.targetRequired) {
		unit_use_action( selected_action, _user, noone );
		main_actions--;
		extra_action = false;
		end_state_targeting();
		return;
	}

	camera_reset_buffer();
	camera_zoom_reset();

	// Cancel targeting
	if (cancel_input) {
		end_state_targeting();
	}
	
	if (struct_exists(selected_action, "targetCount") && selected_action.targetCount > 0) {
		var _offset = right_input - left_input;
		
		current_target = clamp(current_target + _offset, 0, array_length(action_possible_targets)-1);
		if (instance_exists(action_possible_targets[current_target])) {
			var _target = action_possible_targets[current_target];
			global.camera.follow = _target;
			target_indicator.target = _target;
			
			if (confirm_input) {
				array_push(action_targets, _target);	
			}
		}

		// End targeting	
		if (array_length(action_targets) >= selected_action.targetCount || array_length(action_targets) >= array_length(action_possible_targets)) {
			if (struct_exists(selected_action, "charge") && selected_action.charge) {
				with (_user) {
					charging_targets = other.action_targets;
					charging_action = other.selected_action;
				}
				end_state_targeting();
				return;
			}
			
			unit_use_action(selected_action, _user, action_targets, action_origin, action_area);			
			main_actions--;
			extra_action = false;
			end_state_targeting();
		}
	}
	
	if (struct_exists(selected_action, "areaTarget") && selected_action.areaTarget) {
		var _range = selected_action.originInPlayer ? selected_action.range : selected_action.shapeSize;
		
		if (selected_action.originInPlayer) {
			action_origin.x = _user.unit.position.x
			action_origin.y = _user.unit.position.y
		} else {
			if (using_mouse && mouse_hover.x != -1 && mouse_hover.y != -1) {
				action_origin.x = mouse_hover.x;
				action_origin.y = mouse_hover.y;
			}
			
			action_origin.x = clamp(action_origin.x + (right_input - left_input), max(0, _user.unit.position.x - _range*2), min(array_length(grid[0])-1, _user.unit.position.x + _range*2));
			action_origin.y = clamp(action_origin.y + (down_input - up_input), max(0, _user.unit.position.y - _range*2), min(array_length(grid)-1, _user.unit.position.y + _range*2));
		}
		
		obj_camera.follow = {
			x: tileToScreenXExt(action_origin.x, action_origin.y, tile_size, init_x),	
			y: tileToScreenYExt(action_origin.x, action_origin.y, tile_size, init_y),	
		};
		
		action_area = new Area(action_origin.x, action_origin.y, function(_x, _y, _action_x, _action_y, _range, _shape) {
			return calc_in_shape_range(_action_x, _action_y, _x, _y, _shape) <= _range
		}, _range, selected_action.shape)
		
		action_targets = [];

		with (obj_battle_entity) {
			if (
				(!struct_exists(other.selected_action, "targetSelf"))
				|| ((!other.selected_action.targetSelf) && _user.id == self.id)
				|| (unit.hp <= 0 && (!struct_exists(other.selected_action, "targetDead") || other.selected_action.targetDead == CONDITIONS.NEVER))
			) {
				continue;	
			}
			
			in_target = other.action_area.is_in_area(unit.position.x, unit.position.y);
			if (in_target) {
				array_push(other.action_targets, self);
			}
		}

		if (confirm_input || l_click) {
			unit_use_action(selected_action, _user, action_targets, action_origin, action_area);
			main_actions--;
			extra_action = false;
			end_state_targeting();	
		}
	}
}

function end_state_targeting() {
	selected_action = noone;
	action_targets = [];
	action_possible_targets = [];
	action_area = noone;
	
	if (instance_exists(target_indicator)) instance_destroy(target_indicator);
	with(obj_battle_entity) {
		in_target = false;	
	}
	
	global.camera.follow = extra_turn_user != noone ? extra_turn_user : units[turns];
	state = battle_state_turn;
	prev_state = noone;
}

function calc_in_shape_range(_x1, _y1, _x2, _y2, _shape) {
	switch(_shape) {
		case MOVE_SHAPES.CIRCLE:
			return sqrt( sqr(_x2 - _x1) + sqr(_y2 - _y1) );
		case MOVE_SHAPES.SQUARE:
			return floor( sqrt(sqr(_x1 - _x2) + sqr(_y1 - _y2)) );
		default:
			return false;
	}
}

function battle_state_extra() {
	check_charging();
	turn_camera();
	movement_actions = 0;
	
	// Main Action
	if (extra_action) {
		check_attack();
	}
	
	// Give Extra Turn
	if (!extra_turn_given && keyboard_check_pressed(ord("G"))) {
		extra_units = array_filter(units, function(_unit) {
			return !_unit.unit.is_enemy && _unit != obj_battle_manager.extra_turn_user && !_unit.is_dead;
		});
		current_extra_unit = 0;
		
		if (array_length(extra_units) > 0) {
			state = battle_state_extra_choosing;
		}
	}
	
	if (!animating && (!extra_action || extra_turn_user.ready)) {
		extra_turn_user.ready = true;
		extra_action = false;
		state = battle_state_waiting;	
	}
}

function battle_state_extra_choosing() {
	var _curr = extra_units[current_extra_unit];
	obj_camera.follow = _curr;
	
	// Change Unit
	if (keyboard_check_pressed(vk_left)) {
		current_extra_unit--;
	}
	if (keyboard_check_pressed(vk_right)) {
		current_extra_unit++;	
	}
	
	current_extra_unit = clamp(current_extra_unit, 0, array_length(extra_units)-1);
	
	// Select Unit
	if ( confirm_input ) {
		extra_turn_user.ready = true;
		extra_turn_user = _curr;
		obj_camera.follow = _curr;
		extra_turn_given = true;
		state = battle_state_waiting;
	}
	
	// Cancel
	if (keyboard_check_pressed(ord("G"))) {
		obj_camera.follow = extra_turn_user;
		current_extra_unit = 0;
		state = battle_state_extra;
	}
}

function battle_state_enemy_turn() {
	if ( battle_host == obj_server.username && units[turns].unit.is_enemy ) {
		var _user = units[turns];
		
		if (extra_turn_user != noone) {
			_user = extra_turn_user;
		}
		
		if (main_actions > 0 || extra_action) {
			with (_user) {
				unit.enemy_info.battle_script(self);
			}
			if (!extra_turn_given) extra_action = false;
		}

		state = battle_state_waiting;
	}	
}

function battle_state_waiting() {
	if (keyboard_check_pressed(ord("R"))) {
		units[turns].ready = true;	
	}
	
	battle_check_dead_units();
	turn_camera();
	
	if (!animating) {
		
		if (extra_action && extra_turn_user != noone) {
			if(extra_turn_user.unit.player_username == global.server.username) {
				extra_turn_user.ready = false;
				state = battle_state_extra;	
			} else if (battle_host == global.server.username && extra_turn_user.is_enemy) {
				state = battle_state_enemy_turn;
			}
		}
		
		current_waiting_frames++;
		
		if (current_waiting_frames >= waiting_frames) {
			camera_reset_bar();
			camera_reset_buffer();
			
			if (units[turns].ready || extra_turn_user.ready) {
				state = battle_state_end_turn;
			}
			
			current_waiting_frames = 0;
		}
		
		battle_check_over();
	}
}

function battle_check_dead_units() {
	// Animate death (brutal)
	with (obj_battle_unit) {
		if (unit.hp <= 0 && !is_dead) {
			var _cutscene = [];
			unit.condition = noone;
			is_dead = true;
			
			if ( struct_exists(unit.sprites, "dying") ) {
				array_push(_cutscene, [cutscene_animate_once, self, unit.sprites.dying]);	
			}
			
			if ( struct_exists(unit.sprites, "dead") ) {
				array_push(_cutscene, [cutscene_change_sprite, self, unit.sprites.dead]);	
			}
			
			battle_create_cutscene(_cutscene);
		}
	}	
}

function battle_check_animating() {
	with (obj_battle_manager) {
		var _animating = array_length(obj_battle_manager.cutscene) > 0 || instance_exists(obj_battle_effect) || instance_exists(obj_projectile);
	
		if (!_animating) {
			for (var i = 0; i < array_length(units); ++i) {
			    if (units[i].animating) {
					_animating = true;
					break;
				}
			}
		}
	
		return _animating;
	}
}

function battle_state_end_turn() {
	if (animating) { 
		return;
	}
	
	camera_reset_buffer();

	var _unit = units[turns];
	
	with(_unit) {
		if (unit.condition != noone && unit.condition.trigger == EFFECT_TRIGGERS.END_TURN_SELF) {
			battle_activate_condition(self);
		}
	}
	
	units[turns].ready = false;
	turns++;
	extra_turn_given = false;
	extra_action = false;
	extra_turn_user = noone;
	
	with(obj_battle_unit) {
		// Trigger effect
		if (unit.condition != noone && unit.condition.trigger == EFFECT_TRIGGERS.END_TURN_ALL) {
			battle_activate_condition(self);
		}
	}
	
	if (turns >= array_length(units)) {
		array_sort(units, battle_sort_by_speed);
		turns = 0;
		rounds++;
	}
	
	// TODO trigger end battle and clean damage temp
	
	// TODO instantiate queued units (units waiting to enter the battle)
	if (array_length(queued_allies) > 0) {
	
	}

	battle_check_over();
	state = battle_state_start_turn;
}

function check_charging() {
	var _user = extra_action ? extra_turn_user : units[turns];
	
	if ((main_actions > 0 || extra_action) && _user.charging_action != noone && _user.charging_targets != noone) {
		if (_user.charging_turns >=_user.charging_action.chargingTurns-1) {
			add_battle_text( string("{0} move has charged!", _user.unit.name));
		} else {
			add_battle_text( string("{0} is charging!", _user.unit.name));
		}
		
		unit_use_action(_user.charging_action, _user, _user.charging_targets);
		main_actions = 0;
		movement_actions = 0;
		extra_action = false;
	}
}

function exit_state_turn(_new_state) {
	with(obj_battle_manager) {
		prev_state = state;
		state = _new_state;
		movement_tile.x = units[turns].x;
		movement_tile.y = units[turns].y;
		camera_reset_buffer();
		camera_zoom_reset();
	}
}

function turn_camera() {
	with(global.camera) {
		var _buffer_x = clamp((mouse_x - camera_x - camera_w/2)/10, -10, 10);
		var _buffer_y = clamp((mouse_y - camera_y - camera_h/2)/10, -10, 10);
		
		camera_set_x_buffer(_buffer_x, .2);
		camera_set_y_buffer(_buffer_y, .2);
	}
	
	camera_zoom(25, true, .25);
	camera_set_bar(50, .15);	
}

function check_attack() {	
	//if (keyboard_check_pressed(ord("A")) || (l_click && unit_hover != noone && !unit_hover.is_dead)) {
	//	set_state_targeting(global.actions.attack);
	//}
		
	//if (keyboard_check_pressed(ord("Q"))) {
	//	set_state_targeting(global.actions.lightRay);
	//}
		
	//if (keyboard_check_pressed(ord("W"))) {
	//	set_state_targeting(global.actions.attackBoost);
	//}
	
	//if (keyboard_check_pressed(ord("E"))) {
	//	set_state_targeting(global.actions.fireBall);
	//}
	
	//if (keyboard_check_pressed(ord("T"))) {
	//	set_state_targeting(global.actions.poisonMist);
	//}
		
	//if (array_length(units[turns].unit.inventory) > 0 && keyboard_check_pressed(ord("I"))) {
	//	unit_use_action(global.actions.useItem, units[turns], units[turns].unit.inventory[0]);
	//	main_actions--;
	//}

}

function battle_check_over() {
	var _allies_win = true;
	var _enemies_win = true;
	
	for (var i = 0; i < array_length(allies); ++i) {
	    if (allies[i].hp > 0) {
			_enemies_win = false;
			break;
		}
	}
	
	for (var i = 0; i < array_length(enemies); ++i) {
	    if (enemies[i].hp > 0) {
			_allies_win = false;
			break;
		}
	}
	
	if ( _allies_win || _enemies_win ) {
		current_waiting_frames = 0;
		state = end_battle;
	}
}

function end_battle() {
	if (!animating) current_waiting_frames++;
	
	if (current_waiting_frames >= waiting_frames) {
		for (var i = 0; i < array_length(units); ++i) {
		    var _unit = units[i];
			
			if (_unit.is_dead) {
				create_unit_corpse(_unit);	
			}
		}
		
		show_message("Cabou!")
		instance_destroy(obj_battle_entity);
		instance_destroy(obj_battle_effect);
		instance_destroy(obj_battle_manager);
	}
}