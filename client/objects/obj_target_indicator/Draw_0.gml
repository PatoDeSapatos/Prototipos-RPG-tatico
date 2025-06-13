/// @description
draw_self();

if (instance_exists(target) && variable_instance_exists(target, "unit")) {
	var _yoffset = (((sprite_get_height(sprite_index)-5)*image_yscale)/2 - 15 - floor(image_index))*obj_battle_manager.scale;
	var _xoffset = sprite_get_width(spr_stat_bar_outline)/2 - sprite_get_xoffset(spr_stat_bar_outline);
	
	draw_sprite_ext(spr_stat_bar_targeting, 0, x - _xoffset - sprite_get_xoffset(spr_stat_bar_outline), y - _yoffset, 1, 1, 0, c_white, .7);
	draw_sprite_ext(spr_stat_bar_targeting, 0, x - _xoffset - sprite_get_xoffset(spr_stat_bar_outline), y - _yoffset, target.unit.hp/target.unit.stats.hp, 1, 0, get_resource_color(RESOURCES.LIFE), 1);
	draw_sprite_ext(spr_stat_bar_outline, 0, x - _xoffset, y - _yoffset, 1, 1, 0, c_white, 1);
}