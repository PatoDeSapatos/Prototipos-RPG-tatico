/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

if (selector_y != noone) {
	draw_sprite_ext(spr_skill_selector, selector_image, items_box_x, items_box_name_y + selector_y, global.res_scale*2, global.res_scale*2, 0, c_white, 1);
	selector_image += sprite_get_speed(spr_skill_selector)/FRAME_RATE;
	if (selector_image > sprite_get_number(spr_skill_selector)) {
		selector_image = 0;	
	}
}
