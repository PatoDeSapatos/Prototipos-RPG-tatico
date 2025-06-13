/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

inventory_open = true;
has_equipment_box = false;
has_tabs = false;
selected_tab = TABS.SKILLS;

equipment_box_border *= 2;
equipment_box_y = (display_get_gui_height() - equipment_box_h)/2;

selector_y = noone;
selector_image = 0;