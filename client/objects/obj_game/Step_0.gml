/// @description Insert description here
if ( keyboard_check_pressed(vk_f1) ) {
	if (instance_exists(obj_dungeon_manager)) instance_destroy(obj_dungeon_manager);
	game_restart();
}

if (instance_exists(obj_wall)) {
	if (keyboard_check_pressed(ord("Z"))) {
		instance_deactivate_object(obj_wall);
	}
} else if (keyboard_check_pressed(ord("X"))) {
	instance_activate_object(obj_wall);	
}