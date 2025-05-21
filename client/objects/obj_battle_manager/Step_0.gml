/// @description
using_mouse = false;
if (mouse_sx != device_mouse_x_to_gui(0) || mouse_sy != device_mouse_y_to_gui(0)) {
	using_mouse = true;	
}

mouse_sx = device_mouse_x_to_gui(0);
mouse_sy = device_mouse_y_to_gui(0);

unit_hover = noone;
var _mouse_x = mouse_hover.x;
var _mouse_y = mouse_hover.y;

animating = battle_check_animating();

with(obj_battle_entity) {	
	var _x = screenToTileXG(x, y, other.tile_size, other.init_x, other.init_y);
	var _y = screenToTileYG(x, y, other.tile_size, other.init_x, other.init_y);

	if ( (_mouse_x != -1 && _mouse_y != -1) && (_x == _mouse_x && _y == _mouse_y) ) {
		obj_battle_manager.unit_hover = self;
	}

	depth = -(tileToScreenYExt(_x - 1, _y - 1, other.tile_size, other.init_y));
}

if (player_turn && movement_actions > 0 && is_struct(targeted_tiles)) {
	cursor_in_range = targeted_tiles.is_in_area(mouse_hover.x, mouse_hover.y);
}

l_click = mouse_check_button_pressed(mb_left);
left_input = keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A"));

r_click = mouse_check_button_pressed(mb_right);
right_input = keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"));

up_input = keyboard_check_pressed(ord("W")) || keyboard_check_pressed(vk_up);
down_input = keyboard_check_pressed(ord("S")) || keyboard_check_pressed(vk_down);

confirm_input = keyboard_check_pressed(vk_enter);
cancel_input = keyboard_check_pressed(vk_escape) || keyboard_check_pressed(vk_backspace);

attack_input = keyboard_check_pressed(ord("Q"));
item_input = keyboard_check_pressed(ord("W"));
move_input = keyboard_check_pressed(ord("E"));
interact_input = keyboard_check_pressed(ord("F"));

move_camera_input = keyboard_check_pressed(ord("M"));
skip_input = keyboard_check_pressed(ord("R"));

//if (mouse_hover.x != -1 && mouse_hover.y != noone && l_click) {
//	var _propinfo = new PropInfo(spr_props, 0, false, 10, noone)
//	battle_create_props(_propinfo, mouse_hover);
//}

battle_execute_cutscene();

state();
