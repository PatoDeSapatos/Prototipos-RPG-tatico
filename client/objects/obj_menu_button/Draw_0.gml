/// @description
if ( can_click ) { 
	if ( hover && mouse_check_button_pressed(mb_left) )	{
		callback();
	}
} else {
	draw_set_alpha(.5);	
}

draw_set_color(hover && can_click ? (hover_color) : (button_color));
draw_set_halign(fa_middle);
draw_set_valign(fa_center);
if (button_font != -1) draw_set_font(button_font);

draw_rectangle(button_x - button_width/2, button_y - button_height/2, button_x + button_width/2, button_y + button_height/2, false);

draw_set_alpha(1);
draw_set_color(hover && can_click ? (button_font_color) : (button_font_color_hover));
draw_text(button_x, button_y, button_text);

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);