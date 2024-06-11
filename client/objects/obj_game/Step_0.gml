/// @description Insert description here
if ( keyboard_check_pressed(vk_f1) ) {
	if (instance_exists(obj_dungeon_manager)) instance_destroy(obj_dungeon_manager);
	game_restart();
}
