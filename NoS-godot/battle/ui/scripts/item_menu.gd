class_name ItemMenu extends Control

@onready var inventory_list: InventoryList = $MarginContainer/Container/InventoryList
@onready var container: HBoxContainer = $MarginContainer/Container
@onready var item_name: Label = $MarginContainer/Container/PanelContainer/MarginContainer/VBoxContainer/ItemName
@onready var item_desc: RichTextLabel = $MarginContainer/Container/PanelContainer/MarginContainer/VBoxContainer/ItemDesc

var current_item: ItemStack = null

var items: Array:
	set(value):
		items = value
		inventory_list.clear()
		
		for i in items:
			var e: ItemOption = preload("res://battle/ui/item_option.tscn").instantiate()
			e.item_stack = i
			inventory_list.add_element(e)
		
		if (items.size() > 0):
			current_item = items[0]

func _ready() -> void:
	hide()

func show_menu():
	modulate.a = 0.0
	inventory_list.change_option_selected(0)
	show()
	create_tween().tween_property(self, "modulate:a", 1.0, 0.2)

func hide_menu():
	hide()
	var tween = create_tween()
	tween.tween_callback(func (): hide())
	tween.tween_property(self, "modulate:a", 0.0, 0.2)

func _process(delta: float) -> void:
	pass

func _on_inventory_list_option_changed(new_option: int) -> void:
	if (items.size() <= 0):
		return
		
	item_name.text = items[new_option].item.display_name
	item_desc.text = DescHandler.format_text_colors(items[new_option].item.description)
	current_item = items[new_option]
