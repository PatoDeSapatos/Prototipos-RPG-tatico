/// @description
image_alpha -= .2;

x += lengthdir_x(spd, dir);
y += lengthdir_y(spd, dir);

if (image_alpha <= 0) {
	instance_destroy();	
}
