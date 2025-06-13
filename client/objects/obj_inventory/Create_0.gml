/// @description

enum TABS {
	ITEMS,
	CRAFTING,
	SKILLS,
	LENGTH
}

enum FOCUS {
	LIST,
	ORDER,
	TABS,
	ITEM,
	ITEM_PANEL,
	LENGTH
}

enum ORDERS {
	TYPE,
	NAME,
	DATE,
	QUANTITY,
	LENGTH
}

inventory_open = false;
inventory_size = 64;

// Menu Parameters
gui_w = display_get_gui_width();
gui_h = display_get_gui_height();
border = gui_w/20;

// Items box
items_box_w = gui_w/2.5;
items_box_h = gui_h;
items_box_x = gui_w - border - items_box_w;
items_box_y = 0;
items_box_border = items_box_w div 10;

items_box_spr_size = sprite_get_height(spr_items) * (global.res_scale * 2) + 5;

items_box_category_y = 0; 
items_box_category_h = sprite_get_height(spr_items_categories) * (global.res_scale*2.5) + 5;

items_box_title_y = items_box_y + items_box_category_y + items_box_category_h + items_box_border/2;
items_box_title_h = sprite_get_height(spr_items) * global.res_scale*2 + 10;

items_box_name_x = items_box_border + items_box_spr_size;
items_box_name_y = items_box_title_y + items_box_title_h;
items_box_name_offset = 0;

items_box_name_w = (items_box_w div 2) - items_box_border*2;
items_box_name_h = sprite_get_height(spr_items) * (global.res_scale * 2) + 5;

items_box_category_x = items_box_w - items_box_border;
items_box_quantity_x = items_box_category_x - items_box_spr_size - items_box_border;

items_box_list_surf = -1;

// Navigation
selected_item = 0;
selected_category = 0;
selected_tab = 0;
mouse_navigation = false;
focus = 0;

active_item = noone;
active_item_y = -1;

// Order
orders = [
	"Type",
	"Name",
	"Date",
	"Quantity"
];
selected_order = 0;
order_ascending = true;
sort = 0;

order_w = 0;
for (var i = 0; i < array_length(orders); ++i) {
    order_w = max(order_w, string_width(orders[i]));
}
box_delay = 0;

// Inventory Tabs
has_tabs = true;
tabs_y = [];
tabs_x = items_box_x + items_box_w;
var _current_tab_y = items_box_title_y + items_box_title_h + items_box_border/4;;
var _tab_h = sprite_get_height(spr_inventory_tabs);
for (var i = 0; i < sprite_get_number(spr_inventory_tabs); ++i) {
    tabs_y[i] = _current_tab_y;
	_current_tab_y += (_tab_h - 3) * global.res_scale*2;
}

// Ingredients
ingredients_box_x = items_box_x;
ingredients_box_y = gui_h - items_box_h/2.8;
ingredients_box_w = items_box_w;
ingredients_box_h = gui_h - ingredients_box_y;

ingredients_cols = 2;
ingredients_border = 20 * global.res_scale;

ingredient_scale = 1.5 * global.res_scale;
ingredient_w = (ingredients_box_w - ingredients_border*2) / 2;
ingredient_h = sprite_get_height(spr_items) * ingredient_scale;

ingredient_spr_w = sprite_get_width(spr_items)*ingredient_scale;

// Inventory
max_items = 10;

// Bag Active Item
function Item_Action(_callback) constructor {
	callback = _callback;
	take_action = function (_selected_option) {
		var _callback = callback;
		with(obj_inventory) {
			_callback(_selected_option);
		}
	}
}

bag_item_options = {
	material: {
		options: ["Discard", "Discard All", "Cancel"],
		action: new Item_Action( function(_selected_option) {
			switch (_selected_option) {
				case 0:
					show_discard_panel(active_item);
					break;
				case 1:
					inventory_remove_item(inventory, active_item.id, active_item.quantity);
					focus = FOCUS.LIST;
					break;
				case 2:
					focus = FOCUS.LIST;
					break;
			}
		} )
	},
	equipment: {
		options: ["Equip/Unnequip", "Discard", "Discard All", "Cancel"],
		action: new Item_Action( function(_selected_option) {
			switch (_selected_option) {
				case 0:
					equip_item(active_item);
					focus = FOCUS.LIST;
					break;
				case 1:
					show_discard_panel(active_item);
					break;
				case 2:
					inventory_remove_item(inventory, active_item.id, active_item.quantity);
					focus = FOCUS.LIST;
					break;
				case 3:
					focus = FOCUS.LIST;
					break;
			}
		} )
	},
	consumable: {
		options: ["Use", "Discard", "Discard All", "Cancel"],
		action: new Item_Action( function(_selected_option) {
			switch (_selected_option) {
				case 1:
					show_discard_panel(active_item);
					break;
				case 2:
					inventory_remove_item(inventory, active_item.id, active_item.quantity);
					focus = FOCUS.LIST;
					break;
				case 3:
					focus = FOCUS.LIST;
					break;
			}
		} )
	},
	crafting: {
		options: ["Craft", "Craft All", "Cancel"],
		action: new Item_Action( function(_selected_option) {
			switch(_selected_option) {
				case 0:
					if (active_item.craftable) inventory_craft_recipe(recipes, active_item);
					break;
				case 1:
					if (active_item.craftable) inventory_craft_recipe_all(recipes, active_item);
					focus = FOCUS.LIST;
					break;
				case 2:
					focus = FOCUS.LIST;
					break;
			}
		})
	}
}

// Item options
item_option_selected = 0;
item_option_x = items_box_x + items_box_border*1.5;
mouse_hover_option = false;

// Item Quantity Panel
item_quantity_panel_x = items_box_x + items_box_w/2;
item_quantity_panel_y = items_box_y + items_box_h/2;
item_panel_item_id = -1;
active_panel = noone;

discard_item_callback = function (_parameters) {
	var _item_id = _parameters.item_id;
	var _quantity = _parameters.quantity;
	
	typing = false
	discard_panel.quantity = clamp(string_length(discard_panel.quantity_typing) > 0 ? (real(discard_panel.quantity_typing)) : (1), 1, discard_panel.item.quantity);
	discard_panel.quantity_typing = discard_panel.quantity;
	
	inventory_remove_item(inventory, _item_id, discard_panel.quantity);
	focus = FOCUS.LIST;
}
craft_item_callback = function(_parameters) {
	var _recipe = _parameters.recipe;
	
	typing = false
	craft_item_panel.quantity = clamp(string_length(craft_item_panel.quantity_typing) > 0 ? (real(craft_item_panel.quantity_typing)) : (1), 1, 999);
	craft_item_panel.quantity_typing = craft_item_panel.quantity;

	repeat(craft_item_panel.quantity) inventory_craft_recipe(recipes, _recipe);
	focus = FOCUS.LIST;	
}


discard_panel = new Item_Quantity_Panel(item_quantity_panel_x, item_quantity_panel_y, "How Many Items to Discard?", "Discard", discard_item_callback, {});
craft_item_panel = new Item_Quantity_Panel(item_quantity_panel_x, item_quantity_panel_y, "How Many Items to Craft?", "Craft", craft_item_callback, {});

// Crafting Active Item

// inputs
up_input = 0;
down_input = 0;
left_input = 0;
right_input = 0;
confirm_input = 0;
cancel_input = 0;

mouse_gui_x = 0;
mouse_gui_y = 0;
mouse_l = 0;
mouse_r = 0;

typing = false;
typing_bar = false;

inventory = [];
recipes = [];
skills = [];
recipe_ingredients = [];

// Equipment Box
has_equipment_box = true;
equipment_box_x = border;
equipment_box_y = border;
equipment_box_x2 = items_box_x - border;
equipment_box_y2 = (gui_h-border*2)*0.66;

equipment_box_border = 10;

equipment_box_w = (equipment_box_x2 - equipment_box_x) - equipment_box_border*2;
equipment_box_h = (equipment_box_y2 - equipment_box_y) - equipment_box_border*4;

stats_box_x = equipment_box_x;
stats_box_y = equipment_box_y + equipment_box_border + (equipment_box_y2 - equipment_box_y)*0.60;

equipments = new Equipment_Set();

equipment_rows = 4;
equipment_slot_w = equipment_box_w/(ceil( struct_names_count(equipments)/equipment_rows ));
equipment_slot_h = (equipment_box_h*0.60)/equipment_rows;

player_base_stats = new Stats(5, 5, 5, 5, 5, 5);
player_equipment_stats = new Stats(0, 0, 0, 0, 0, 0);

stats_rows = 4;
stats_w = equipment_box_w/(ceil( struct_names_count(player_equipment_stats)/stats_rows ));
stats_h = (equipment_box_h*0.40)/stats_rows;

// Item desc box
has_description = false;
inventory_add_recipe(recipes, 0);
