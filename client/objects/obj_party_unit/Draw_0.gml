/// @description Insert description here
var _y = y + z;

if (sprite_exists(effect)) {
	effect_image += sprite_get_speed(effect) / FRAME_RATE;
	if (effect_image > sprite_get_number(effect)) effect_image = 0;
	
	draw_sprite_ext(effect, effect_image, x, y, image_xscale, image_yscale, 0, c_white, 1);
}

if (facing_up) {		
	if (image_index < idle_frames) {
		image_index = idle_frames;	
	}
	
	if (sprites.hand.image != -1 ) {
		if ( (image_index >= 0 + idle_frames && image_index < 1 + idle_frames) || (image_index >= 3 + idle_frames && image_index < 4 + idle_frames) ) {
			_y += scale;
		}
		draw_sprite_ext(spr_hand_acessories, sprites.hand.image + facing_up, x, _y, scale*facing_right, scale, 0, c_white, 1);
	}
} else {
	if(image_index > idle_frames) {
		image_index = 0;	
	}	
}

draw_sprite_ext(sprite_index, image_index, x, y + z, scale*facing_right, scale, 0, c_white, 1);
if (sprite_index == spr_base_idle) {
	draw_sprite_ext(spr_clothes_idle, (clothing * idle_frames) + image_index, x, y + z, scale*facing_right, scale, 0, c_white, 1);
}

struct_foreach(sprites, function(_key, _value) {
	if (!is_struct(_value)) return;
	
	var _x = x;
	var _y = y + z;
	
	if (sprite_index == spr_base_idle && _value.image != -1) {
		if ((image_index >= 1 + (facing_up*idle_frames) && image_index < 2 + (facing_up*idle_frames)) || (image_index >= 2 + (facing_up*idle_frames) && image_index < 3 + (facing_up*idle_frames)) ) {
			if (array_contains(head_sprites, _value.sprite)) {
				_y += scale;	
			}
		} else if (!array_contains(head_sprites, _value.sprite)) {
			_y += scale;
		}
	}
	if (_value.image != -1 && !(facing_up && _value.sprite == spr_hand_acessories)) draw_sprite_ext(_value.sprite, _value.image + facing_up, _x, _y, scale*facing_right, scale, 0, c_white, 1);
});

event_inherited();