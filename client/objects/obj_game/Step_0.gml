/// @description Insert description here
if ( keyboard_check_pressed(ord("R")) ) {
	network_destroy(global.socket);
	game_restart();
} if (keyboard_check_pressed(vk_escape)) {
	network_destroy(global.socket);
	game_end();
}