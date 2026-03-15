class_name Inventory extends Serializable

var items: Array

func _init(items: Array = []) -> void:
	self.items = items

func add_item(item_name: String, quantity: int):
	var data: Item = Items.get_item(item_name)
	if (data == null):
		return
	
	for i: ItemStack in items:
		if (i.item.name == data.name):
			i.quantity += quantity
			return
	
	items.push_back( ItemStack.new(quantity, data) )

func remove_item(item_name: String, quantity: int):
	var data: Item = Items.get_item(item_name)
	if (data == null):
		return
	
	var c = 0
	for i: ItemStack in items:
		if (i.item.name == data.name):
			i.quantity -= quantity
			if (i.quantity <= 0):
				items.remove_at(c)
			break
		c += 1
