/// @description

if ( point_in_rectangle(mouse_x, mouse_y, border, border, border + player_menu_width, border + player_menu_height) ) {
	if ( mouse_wheel_up() ) {
		player_menu_y += 25;
	} else if ( mouse_wheel_down() ) {
		player_menu_y -= 25;	
	}
}

player_menu_y = clamp(player_menu_y, -player_menu_card_height/2, 0);

if ( admin_username == global.server.username ) {
	enter_dungeon_button.button_text = "Start";	
	enter_dungeon_button.can_click = players_ready;
} else {
	enter_dungeon_button.button_text = "Ready";	
	enter_dungeon_button.can_click = true;
}