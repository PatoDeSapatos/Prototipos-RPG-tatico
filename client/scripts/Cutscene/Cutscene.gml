function battle_execute_cutscene() {
	if (array_length(cutscene) <= 0) return;
	
	var _current_action = cutscene[action];
	var _arg_length = array_length(_current_action) - 1;

	cutscene_skip_percentage = clamp(cutscene_skip_percentage, 0, 1);

	switch (_arg_length) {
		case 1:
			script_execute(_current_action[0], _current_action[1]);
			break;
		case 2:
			script_execute(_current_action[0], _current_action[1], _current_action[2]);
			break;
		case 3:
			script_execute(_current_action[0], _current_action[1], _current_action[2], _current_action[3]);
			break;
		case 4:
			script_execute(_current_action[0], _current_action[1], _current_action[2], _current_action[3], _current_action[4]);
			break;
		case 5:
			script_execute(_current_action[0], _current_action[1], _current_action[2], _current_action[3], _current_action[4], _current_action[5]);
			break;
		case 6:
			script_execute(_current_action[0], _current_action[1], _current_action[2], _current_action[3], _current_action[4], _current_action[5], _current_action[6]);
			break;
		default:
			script_execute(_current_action[0]);
			break;
	}
}

function action_end() {
	with(obj_battle_manager) {
		action++;
		timer = 0;
		image = 0;
		setup = false;
		if (action >= array_length(cutscene)) {
			cutscene = [];
			action = 0;
		}
	}
}

function battle_action_start(_targets) {
	if (is_array(_targets)) {
		for (var i = 0; i < array_length(_targets); ++i) {
		    var _target = _targets[i];
			with(_target) {
				animating = true;
			}	
		}
	} else with(_targets) {
		animating = true;	
	}
}

function battle_action_end(_targets) {
	with (obj_battle_manager) {
		if (is_array(_targets)) {
			for (var i = 0; i < array_length(_targets); ++i) {
				var _target = _targets[i];
				with(_target) {
					animating = false;	
				}
			}
		} else with(_targets) {
			animating = false;	
		}
	}
	
	action_end();
}

function cutscene_await(_await_frames) {
	timer++;
	
	if (timer >= _await_frames) {
		action_end(self);		
	}
}

/// @param id
/// @param x
/// @param y
/// @param relative_to_character
/// @param speed
function cutscene_move_character(_id, _x, _y, _relative, _spd) {
	if ( x_dest == noone ) {
		if (_relative) {
			x_dest = _id.x + _x;	
			y_dest = _id.y + _y;
		} else {
			x_dest = _x;
			y_dest = _y;
		}
	}
	
	var _xx = x_dest;
	var _yy = y_dest;
	
	with (_id) {
		if (point_distance(x, y, _xx, _yy) >= _spd) {	
			var _dir = point_direction(x, y, _xx, _yy);	
			var hspd = lengthdir_x(_spd, _dir);
			var vspd = lengthdir_y(_spd, _dir);
		
			x += hspd;
			y += vspd;
			
			var _angle = point_direction(x, y, _xx, _yy);

			if (_angle >= 25 && _angle <= 185) {
				facing_up = true;
			} else {
				facing_up = false;
			}
			
			if (_angle >= 85 && _angle <= 275) {
				facing_right = -1;	
			} else {
				facing_right = 1;	
			}
			
		} else {
			x = _xx;
			y = _yy;
			other.x_dest = noone;
			other.y_dest = noone;
			
			if (other.action+1 >= array_length(other.cutscene)) {
				facing_right = 1;
				facing_up = false;
			}
			
			battle_action_end(_id);
		}	
	}
}

function cutscene_instance_create_depth(_x, _y, _depth, _object, _struct={}) {
	instance_create_depth(_x, _y, _depth, _object, _struct);
	action_end();
}

function cutscene_use_action(_user, _action, _targets, _origin_point, _area) {
	if (!setup) {
		image = _user.sprite_index;
		_user.image_index = 0;	
		
		if (struct_exists(_action, "userAnimation") && !is_undefined(_action.userAnimation) && !is_undefined( _user.unit.sprites[$ _action.userAnimation])) {
			_user.sprite_index = _user.unit.sprites[$ _action[$ "userAnimation"]];	
		}
		
		battle_action_start(_targets);
		
		if (struct_exists(_action, "onUserEffect") && _action.onUserEffect != noone) {
			_user.effect = _action.onUserEffect;
		}
		
		setup = true;
	}
	
	var _frames = (_user.object_index == obj_party_unit) ? _user.idle_frames-1 : sprite_get_number(_user.sprite_index)-1;
	
	if (_user.image_index >= _frames) {
		
		var _missing_resource = battle_change_resource(_user, _action.resource, -_action.costValue);
				
		if (_missing_resource) {
			add_battle_text(string("Not enough {0}", get_resource_name(_resource)));	
			battle_text_set_color(get_resource_color(_resource), 2, 2);
			_user.effect = noone;
			_user.sprite_index = image;
			_user.image_index = 0;
			battle_action_end(_targets);
			return;
		}
		
		if (struct_exists(_action, "hit_effect") && !is_undefined(_action.hit_effect)) {
			for (var i = 0; i < array_length(_targets); ++i) {
			    var _target = _targets[i];
				var _effect = instance_create_depth(_target.x, _target.y, _target.depth-1, obj_battle_effect);
				_effect.sprite_index = _action.hit_effect;
			}
		}


		if (struct_exists(_action, "projectile") && _action.projectile != noone) {
			var _projectile = instance_create_depth(_user.x, _user.y, -1000, obj_projectile);
			var _areaScale = ((_action.shapeSize * obj_battle_manager.tile_size)/sprite_get_width(_action.projectile))*2;
			
			_projectile.sprite_index = _action.projectile;
			_projectile.action_origin = _origin_point;
			_projectile.func = _action.func;
			_projectile.user = _user;
			_projectile.targets = _targets;
			_projectile.scale = obj_battle_manager.scale;
			
			if(struct_exists(_action, "landingSpr") && _action.landingSpr != noone) {
				_projectile.landing_spr = _action.landingSpr;
			}
			
			_projectile.areaScale = _areaScale;
		} else {
			_action.func(_user, _targets, _origin_point);
		}
		
		_user.effect = noone;
		_user.sprite_index = image;
		_user.image_index = 0;
		battle_action_end(_targets);
	}
}

function cutscene_animate_once(_id, _sprite_index) {
	if (!setup) {
		image = _id.sprite_index;
		_id.sprite_index = _sprite_index;
		_id.image_index = 0;
		battle_action_start(_id);
		setup = true;
	}
	
	if (_id.image_index >= sprite_get_number(_id.sprite_index)-1) {
		_id.sprite_index = image;
		battle_action_end(_id);
	}
}

function cutscene_activate_condition(_target) {
	var _condition = _target.unit.condition;
	
	if (!setup) {
		if (!is_undefined(_condition.targetAnimation) && !is_undefined( _target.unit.sprites[$ _condition.targetAnimation] )) {
			image = _target.sprite_index;
			_target.sprite_index = _target.unit.sprites[$ _condition[$ "targetAnimation"]];
			_target.image_index = 0;	
		}

		if (!is_undefined(_condition.effect_spr)) {
			var _effect = instance_create_depth(_target.x, _target.y, _target.depth-1, obj_battle_effect);
			_effect.sprite_index = _condition.effect_spr;
		}
		
		add_battle_text( string("{0} suffers from {1}", _target.unit.name, _condition.name) );
		battle_text_set_color(_condition.col, 3, 3);

		battle_action_start(_target)
		setup = true;
	}
	
	var _frames = (_target.object_index == obj_party_unit) ? _target.idle_frames-1 : sprite_get_number(_target.sprite_index)-1;
	
	if (_target.image_index >= _frames) {
		_condition.func(_target);
		_target.sprite_index = image;
		_target.image_index = 0;
		battle_action_end(_target);
	}
}

function cutscene_change_sprite(_id, _sprite) {
	with (_id) {
		sprite_index = _sprite;
		image_index = 0;
	}
	
	battle_action_end(_id);
}