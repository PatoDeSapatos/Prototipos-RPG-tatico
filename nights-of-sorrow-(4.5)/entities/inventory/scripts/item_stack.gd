class_name ItemStack extends Serializable

@export var quantity: int
@export var item: Item

func _init(quantity: int = 1, item: Item = null) -> void:
	self.quantity = quantity
	self.item = item
