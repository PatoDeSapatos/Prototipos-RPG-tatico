/// @description Insert description here
draw_set_color(c_white);
draw_set_alpha(alpha);

draw_sprite_stretched(spr_menu_chat, 0, chat_x, chat_y, width, height);

if (!surface_exists(message_surface)) display_surface = surface_create(width, height - message_box_h - border*2); 
surface_set_target(display_surface);
draw_clear_alpha(c_black, 0);

var _display_height = 0;
var _messages = array_reverse(messages);
for( var i = 0; i < array_length(_messages); i++ ) {
	var _sender = _messages[i].sender;
	var _y = display_y + height - message_box_h - border*4 - (border/2*i) - string_height(_messages[i].message)*i
	
	switch ( _messages[i].type ) {
		case "CHAT":
			draw_set_color(c_white);
			draw_text(border, _y, _sender + ": ");
			draw_text(border + string_width(_sender + ": "), _y, _messages[i].message);
			break;
		case "JOIN": case "LEAVE":
			draw_set_color(c_ltgray);
			draw_text(border, _y, _sender + " " + _messages[i].message + ".");
			break;
	}
	_display_height += (border/2) + string_height(_messages[i].message);
}
display_height = _display_height;
draw_set_color(c_white)

surface_reset_target();
draw_surface(display_surface, chat_x, chat_y);

if ( !surface_exists(message_surface) ) message_surface = surface_create( message_box_w - border*2, message_box_h );
surface_set_target(message_surface);
draw_clear_alpha(c_black, 0);

draw_sprite_stretched(spr_menu_messagebox, 0, 0, 0, message_box_w - border*2, message_box_h);

draw_set_valign(fa_middle);
draw_set_halign(fa_right);
draw_set_font(fnt_chat);
draw_set_color(c_black);
draw_text(border + min(message_box_w-border*4, string_width(message_typing)), message_box_h/2, message_typing);
draw_set_color(c_white);
draw_set_valign(fa_top);
draw_set_halign(fa_left);

surface_reset_target();
draw_surface(message_surface, chat_x + border*2, chat_y + height - border - message_box_h);


draw_set_alpha(1);