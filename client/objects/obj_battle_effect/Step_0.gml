/// @description
image_xscale = lerp(image_xscale, scale, .2);
image_yscale = lerp(image_xscale, scale, .2);

if (image_index >= sprite_get_number(sprite_index)-1) {
	instance_destroy();	
}