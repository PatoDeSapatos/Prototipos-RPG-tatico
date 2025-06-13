/// @description 
if (in_target && is_struct(unit)) {
	var _yoffset = (sprite_get_yoffset(sprite_index)*image_yscale)-5;
	var _xoffset = sprite_get_width(spr_stat_bar_outline)/2 - sprite_get_xoffset(spr_stat_bar_outline);
		
	draw_sprite_ext(spr_stat_bar_targeting, 0, x - _xoffset - sprite_get_xoffset(spr_stat_bar_outline), y - _yoffset, 1, 1, 0, c_white, .7);
	draw_sprite_ext(spr_stat_bar_targeting, 0, x - _xoffset - sprite_get_xoffset(spr_stat_bar_outline), y - _yoffset, unit.hp/unit.stats.hp, 1, 0, get_resource_color(RESOURCES.LIFE), 1);
	draw_sprite_ext(spr_stat_bar_outline, 0, x - _xoffset, y - _yoffset, 1, 1, 0, c_white, 1);
	
	draw_sprite_ext(spr_battle_targeting, 0, x, y - _yoffset - sprite_get_height(spr_stat_bar_outline) - 3, image_xscale, image_yscale, 0, c_white, 1);
	
	if (defended) {
		draw_sprite_ext(spr_defended_icon, 0, x, y, image_xscale, image_yscale, 0, c_white, .8)		
	}
}