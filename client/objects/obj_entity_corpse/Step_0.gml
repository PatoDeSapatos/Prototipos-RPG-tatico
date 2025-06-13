/// @description
if (alarm[0] <= 0 && array_length(inventory) <= 0) {
	alarm[0] = FRAME_RATE;	
}

if (vanish) {
	image_alpha -= .05;
	if (image_alpha <= 0) instance_destroy();
}