/// @description
depth = -10000;

if (object_exists(target)) {
	x = target.x;
	y = target.y - ((sprite_get_height(target.sprite_index)-5)*target.image_yscale)/2 - 10;
	image_xscale = target.image_xscale;
	image_yscale = target.image_yscale;
}

if (is_struct(target)) {
	x = tileToScreenXExt( target.x, target.y, obj_battle_manager.tile_size, obj_battle_manager.init_x );
	y = tileToScreenYExt( target.x, target.y, obj_battle_manager.tile_size, obj_battle_manager.init_y );
	
	image_xscale = obj_battle_manager.scale;
	image_yscale = obj_battle_manager.scale;
}