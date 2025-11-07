class_name Item extends Serializable

enum ItemCategories {
	DEFAULT,
	MATERIAL,
	WEAPON,
	ARMOR,
	POTION
}

@export var name: String
@export var display_name: String
@export var description: String
@export var sprite: Texture2D
@export var max_stack: int
@export var category: ItemCategories = ItemCategories.DEFAULT
