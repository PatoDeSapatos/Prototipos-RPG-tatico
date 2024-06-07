/// @description
var _y = y + z;
if ( facing_up && sprites[2].image != -1 ) {
	if ( (image_index >= 0 + idle_frames && image_index < 1 + idle_frames) || (image_index >= 3 + idle_frames && image_index < 4 + idle_frames) ) {
		_y += scale;
	} 
	draw_sprite_ext(spr_hand_acessories, sprites[2].image + facing_up, x, _y, scale*facing_right, scale, 0, c_white, 1);
}

draw_sprite_ext(sprite_index, image_index, x, y + z, scale*facing_right, scale, 0, c_white, 1);
if (sprite_index == spr_base_idle) {
	draw_sprite_ext(spr_clothes_idle, (clothing * idle_frames) + image_index, x, y + z, scale*facing_right, scale, 0, c_white, 1);
}

array_foreach(sprites, function(_value) {
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

draw_set_valign(fa_middle);
draw_set_halign(fa_center);
draw_text(
	x - sprite_xoffset + sprite_width/2,
	y + z - sprite_yoffset - 30,
	player_username
);
draw_set_valign(fa_top);
draw_set_halign(fa_left);