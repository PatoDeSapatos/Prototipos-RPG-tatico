/// @description Insert description here
if (sprite_exists(effect)) {
	effect_image += sprite_get_speed(effect) / FRAME_RATE;
	if (effect_image > sprite_get_number(effect)) effect_image = 0;
	
	draw_sprite_ext(effect, effect_image, x, y, image_xscale, image_yscale, 0, c_white, 1);
}

draw_self();
event_inherited();