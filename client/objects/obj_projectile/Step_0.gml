/// @description
image_xscale = lerp(image_xscale, scale, .2);
image_yscale = lerp(image_yscale, scale, .2);

obj_camera.follow = self;

if (instance_exists(action_origin) || is_struct(action_origin)) {
	var _target_x = tileToScreenXExt(action_origin.x, action_origin.y, obj_battle_manager.tile_size, obj_battle_manager.init_x);
	var _target_y = tileToScreenYExt(action_origin.x, action_origin.y, obj_battle_manager.tile_size, obj_battle_manager.init_y);
	
	x = lerp(x, _target_x, spd);	
	y = lerp(y, _target_y, spd);	
	
	if (abs(x - _target_x) + abs(y - _target_y) <= spd) {
		if (sprite_exists(landing_spr)) {
			var _effect = instance_create_depth(_target_x, _target_y, -1000, obj_battle_effect, {
				sprite_index: landing_spr
			});	
			
			_effect.scale = areaScale;
		}
		
		if (func != noone) {
			func(user, targets, action_origin);	
		}
		obj_camera.follow = user;
		instance_destroy();	
	}
	
	if (has_trail) {
		var _trail = instance_create_depth(x, y, depth+10, obj_projectile_trail);	
		_trail.dir = point_direction(_target_x, _target_y, x, y);
		_trail.spd = spd/2;
		_trail.sprite_index = sprite_index;
		_trail.image_index = image_index;
		_trail.image_xscale = image_xscale
		_trail.image_yscale = image_yscale;
	}
} else {
	instance_destroy();
}