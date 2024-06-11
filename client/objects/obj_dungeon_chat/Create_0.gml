/// @description
function Message() constructor {
	type = -1;
	content = -1;
}

depth = -9999;
messages = [];
message_typing = "";
keyboard_string = "";

focus = false;
message_box_hover = false;
typing = false;
alpha = 1;
alpha_rate = .015;

width = display_get_gui_width()/3;
height = display_get_gui_height()/3;
display_height = 0;
display_y = 0;
display_surface = -1;

border = 10;
message_box_w = width - border;
message_box_h = height/8;
message_surface = -1;

chat_x = 0;
chat_y = 0 + display_get_gui_height() - height;

receive_message = function(_message) {
	array_push(messages, _message);
}
