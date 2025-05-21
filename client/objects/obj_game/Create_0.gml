/// @description Insert description here
global.camera = instance_create_layer(0, 0, "Instances", obj_camera);
global.server = instance_create_layer(0, 0, "Instances", obj_server);
global.pause = false;
global.loading = false;
global.loading_screen = false;
global.can_zoom = false;
global.can_pan = false;
global.enemies = ds_map_create();
global.items = {};
global.recipes = {};
global.player_inventory = noone;
init_items();
init_recipes();
init_enemies();

global.controls = {
	key_up: [ord("W"), vk_up],
	key_down: [ord("S"), vk_down],
	key_left: [ord("A"), vk_left],
	key_right: [ord("D"), vk_right]
}

randomize();
room_goto(rm_battle_demo);

global.settings = {
	camera_sensibility: 100,
	vibrations: true
}

instance_create_depth(0, 0, 0, obj_signal)