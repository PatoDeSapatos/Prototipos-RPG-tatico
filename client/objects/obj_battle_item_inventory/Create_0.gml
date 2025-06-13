/// @description Insert description here
event_inherited();

inventory_open = true;
has_equipment_box = false;
has_tabs = false;
has_description = true;
selected_tab = TABS.ITEMS;

equipment_box_border *= 2;
equipment_box_y = (display_get_gui_height() - equipment_box_h)/2;

selector_y = noone;
selector_image = 0;

bag_item_options = noone;