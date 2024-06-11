/// @description Insert description here
if ( message_box_hover ) {
	window_set_cursor(cr_beam);
	if (mouse_check_button_pressed(mb_left)) {
		typing = true;
	}
} else {
	window_set_cursor(cr_default);	
}

if ( point_in_rectangle(mouse_x, mouse_y, chat_x, chat_y, chat_x + width, chat_y + height) ) {
	if ( point_in_rectangle(mouse_x, mouse_y, chat_x + border, chat_y + height - border - message_box_h, chat_x + message_box_w, chat_y + height - border) ) {
		message_box_hover = true;
	} else message_box_hover = false;
	
	if ( mouse_wheel_down() ) {
		display_y -= 25	
	} else if ( mouse_wheel_up() ) {
		display_y += 25
	}
	
	if ( alpha > 0) focus = true; 
} else {
	if (alarm[0] <= 0) alarm[0] = 50;
	if ( mouse_check_button_pressed(mb_any) ) {
		typing = false;	
	}
}

if (typing) {
	focus = true;
	message_typing = keyboard_string;
	
	if (keyboard_check_pressed(vk_enter)) {
		if ( string_trim_end(message_typing) != "" ) {
			global.server.send_chat_message("CHAT", message_typing);
			message_typing = "";
			keyboard_string = "";
		}
	}
} else {
	keyboard_string = message_typing;	
}

if (focus) {
	alpha = 1;
} else {
	alpha -= alpha_rate;
	typing = false;
}

if ( keyboard_check_pressed(ord("O")) ) {
	typing = true;
}

display_y = clamp(display_y, 0, (display_height+border*6)-height);
if (display_y < 0) display_y = 0;

chat_x = 0;
chat_y = display_get_gui_height() - height;

alpha = clamp(alpha, 0, 1);
