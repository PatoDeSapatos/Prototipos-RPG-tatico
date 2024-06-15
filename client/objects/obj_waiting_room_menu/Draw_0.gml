/// @description Insert description here
if ( waiting_server ) {
	draw_set_color(c_black);
	gpu_set_zwriteenable(true);
	gpu_set_ztestenable(true);
	gpu_set_depth(-9999);
	draw_rectangle(0,0,room_width, room_height, false);
	draw_set_color(c_white);
	return;
}

if ( setup ) {
	gpu_set_depth(menu_depth);
	player_menu_card_height = menu_border*(max_players+2) + player_card_height*(max_players-2);
	var _x = width - dungeon_info_width - border;
	var _y = (height - dungeon_info_height - buttons_height)/2

	change_privacy_width = dungeon_info_width - border*2;
	change_privacy_height = 50;
	change_privacy_x = _x + border + change_privacy_width/2;
	change_privacy_y = _y + dungeon_info_height - menu_border - change_privacy_height/2;

	create_menu_button(
		change_privacy_x,
		change_privacy_y,
		change_privacy_width,
		change_privacy_height,
		"Change Privacy",
		c_red,
		c_grey,
		c_white,
		c_white,
		change_privacy_callback
	);
	
	setup = false;
}

// Players Menu
if ( surface_exists(player_menu_surface) ) {
	surface_set_target(player_menu_surface);
	
	draw_set_color(c_white);
	draw_rectangle(0, 0, player_menu_width, player_menu_height, false);
	
	draw_set_color(c_red);
	for (var i = 0; i < max_players; ++i) {
		var _x = menu_border;
		var _y = menu_border + (menu_border + player_card_height)*i + player_menu_y;
	
		// Background
		draw_set_color(c_red);
	    draw_rectangle(_x, _y, _x + player_card_width, _y + player_card_height, false);
	
		// Text
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		draw_set_color(c_white);
		
		if ( i < array_length(waiting_players) ) {
			var _username = waiting_players[i].username;
			var _height = string_height(_username)*2 + 10;

			draw_set_valign(fa_top);

			draw_text(player_card_width/2, _y + (player_card_height - _height)/2, _username);
			draw_text(player_card_width/2, _y + 10 + (player_card_height - _height + string_height(_username))/2, waiting_players[i].ready ? ("Ready") : ("Not Ready"));

		} else {
			draw_text(player_card_width/2, _y + player_card_height/2, "Empty");	
		}
		
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
	}
	
	draw_set_color(c_white);
	surface_reset_target();
	draw_surface(player_menu_surface, border, border);
} else {
	player_menu_surface = surface_create(player_menu_width, player_menu_height);	
}

// Dungeon Info
var _x = width - dungeon_info_width - border;
var _y = (height - dungeon_info_height - buttons_height)/2
draw_rectangle(_x, _y, _x + dungeon_info_width, _y + dungeon_info_height, false);

draw_set_color(c_red);
draw_rectangle(_x + menu_border, _y + menu_border, _x + menu_border + code_box_width, _y + menu_border + code_box_height, false);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Dungeon Privacy
draw_text(_x + menu_border + code_box_width/2, _y + menu_border + code_box_height + border/2, "Privacy: " + dungeon_privacy);

//Dungeon Code
draw_set_color(c_white);
draw_text(_x + menu_border + code_box_width/2, _y + menu_border + code_box_height/2, "Code: " + dungeon_code);

draw_set_halign(fa_left);
draw_set_valign(fa_top);

_y += dungeon_info_height + border;
draw_rectangle(_x, _y, _x + buttons_width, _y + buttons_height, false)

