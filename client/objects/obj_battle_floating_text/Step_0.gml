/// @description Insert description here
image_alpha -= .01;
if (vspeed < 0) image_alpha = 1.0;
if (y > ystart) vspeed = 0;
if (image_alpha <= 0) instance_destroy();