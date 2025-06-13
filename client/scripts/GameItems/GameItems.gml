enum ItemCategory {
	DEFAULT,
	MATERIAL,
	WEAPON,
	POTION,
	LENGTH	
}

// Slots
#macro Hand1Slot "hand1"
#macro Hand2Slot "hand2"
#macro bothHandsSlot "bothHands"

function Item(_name, _description, _display_name, _sprId, _category, _max_stack) constructor {
	name = _name;
	description = _description;
	display_name = _display_name;
	sprId = _sprId;
	max_stack = _max_stack;
	category = _category;
}

function Material_Item(_name, _description, _display_name, _sprId, _category, _max_stack) : Item(_name, _description, _display_name, _sprId, _category, _max_stack) constructor {}

function Equipment_Item(_name, _description, _display_name, _sprId, _category, _stats, _slot, _max_stack ) : Item(_name, _description, _display_name, _sprId, _category, _max_stack) constructor {
	slot = _slot;
	stats = _stats;
}

function Consumable_Item(_name, _description, _display_name, _sprId, _category, _action, _max_stack) : Item(_name, _description, _display_name, _sprId, _category, _max_stack) constructor {
	action = _action;
}

function add_material_item( _name, _description, _display_name, _sprId, _category, _max_stack = 999 ) {
	struct_set( global.items, struct_names_count(global.items), new Material_Item(_name, _description, _display_name, _sprId, _category, _max_stack) );
}

function add_equipment_item( _name, _description, _display_name, _sprId, _category, _stats, _slot, _max_stack = 999 ) {
	struct_set( global.items, struct_names_count(global.items), new Equipment_Item(_name, _description, _display_name, _sprId, _category, _stats, _slot, _max_stack) );
}

function add_consumable_item( _name, _description, _display_name, _sprId, _category, _action, _max_stack = 999 ) {
	struct_set( global.items, struct_names_count(global.items), new Consumable_Item(_name, _description, _display_name, _sprId, _category, _action, _max_stack) );
}

function init_items() {
	// Without Stats
	add_material_item( "SLIME_BALL", "", "Bola de Slime", 0, ItemCategory.MATERIAL, 20 );
	add_material_item( "BONE", "", "Osso", 1, ItemCategory.MATERIAL );
	
	// With Stats
	add_equipment_item( "MAD_HAMMER", "", "Martelo Maluco", 2, ItemCategory.WEAPON, new Stats(0, 0, 0, 5, 0, 0), bothHandsSlot, 1 );
	add_equipment_item( "STICKY_HAMMER", "", "Martelo Grudento", 3, ItemCategory.WEAPON, new Stats(0, 0, 0, 10, 0, 0), Hand1Slot, 1 );
	
	// Comsumables
	add_consumable_item("S_HEALTH_POTION", "Recovers 10 health points per use.", "Small Health Potion", 4, ItemCategory.POTION, global.actions.smallHealthPotion, 10);
	add_consumable_item("STICKY_MEAL", "Slimes seens to love this. You don't.", "Sticky Meal", 5, ItemCategory.MATERIAL, global.actions.placeProp)
}