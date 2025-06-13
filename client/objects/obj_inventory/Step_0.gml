/// @description
if ( keyboard_check_pressed( ord("I") ) && !instance_exists(obj_chest_inventory) ) {
	self.inventory_open = !self.inventory_open;
	radar_open = false
	if (global.pause) global.pause = false;
}

// Hammer
if (keyboard_check_pressed(ord("L"))) {
	inventory_add_item(inventory, 2, 1);	
}

if ( keyboard_check_pressed(ord("K")) ) {
	inventory_remove_item(inventory, 2, 1);	
}

// Slime
if (keyboard_check_pressed(ord("B"))) {
	inventory_add_item(inventory, 0, 3);	
}

if ( keyboard_check_pressed(ord("N")) ) {
	inventory_remove_item(inventory, 0, 10);	
}

var _previous_mouse_gui_x = mouse_gui_x;
var _previous_mouse_gui_y = mouse_gui_y;

up_input = keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));
down_input = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"));
left_input = keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A"));
right_input = keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"));
confirm_input = keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter);
cancel_input = keyboard_check_pressed(vk_backspace) || keyboard_check_pressed(vk_escape);

mouse_gui_x = device_mouse_x_to_gui(0);
mouse_gui_y = device_mouse_y_to_gui(0);
mouse_l = mouse_check_button_pressed(mb_left);
mouse_r = mouse_check_button_pressed(mb_right);


if ( up_input || down_input || left_input || right_input ) {
	mouse_navigation = false;
} else if ( _previous_mouse_gui_x != mouse_gui_x || _previous_mouse_gui_y != mouse_gui_y ) {
	mouse_navigation = true;
}

var _items_list_h = 0;
for (var i = 0; i < array_length(inventory); ++i) {
	_items_list_h += items_box_name_h + items_box_border/2;
}

var _sensi = 20;
var _offset = items_box_name_offset + (mouse_wheel_up() - mouse_wheel_down()) * _sensi;
items_box_name_offset = clamp(_offset, (items_box_h - items_box_title_h - items_box_border - items_box_category_h) - _items_list_h, 0);