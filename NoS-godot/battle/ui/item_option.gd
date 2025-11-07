class_name ItemOption extends InventoryOption

@onready var item_name: Label = $Option/HBoxContainer/ItemName
@onready var item_icon: TextureRect = $Option/HBoxContainer/ItemIcon
@onready var quantity_value: Label = $Option/HBoxContainer/MarginContainer/QuantityValue

@export var item_stack: ItemStack:
	set(value):
		item_stack = value
		_update_info()

func _update_info():
	if (item_stack != null && item_stack.item != null && item_name != null):
		item_name.text = item_stack.item.display_name
		item_icon.texture = item_stack.item.sprite
		quantity_value.text = str(item_stack.quantity)
	else:
		print("Erro ao carregar item.")

func _ready() -> void:
	_update_info()

func _process(delta: float) -> void:
	pass
