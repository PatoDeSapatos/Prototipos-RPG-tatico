/// @description Insert description here
global.camera = instance_create_layer(0, 0, "Instances", obj_camera);
global.server = instance_create_layer(0, 0, "Instances", obj_server);
global.pause = false;
global.loading = false;
global.can_zoom = false;
room_goto(rm_main_menu);

global.controls = {
	key_up: [ord("W"), vk_up],
	key_down: [ord("S"), vk_down],
	key_left: [ord("A"), vk_left],
	key_right: [ord("D"), vk_right]
}

randomize()