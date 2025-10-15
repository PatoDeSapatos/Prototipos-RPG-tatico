class_name InventoryOption extends PanelContainer

var selected: bool

signal interacted
signal focused

func _ready() -> void:
	focus_entered.connect(_on_focus_entered)
	mouse_entered.connect(_on_focus_entered)

func change_selection(selected: bool):
	self.selected = selected
	
func _on_focus_entered() -> void:
	self.emit_signal("focused", self)

func _on_mouse_entered() -> void:
	self.emit_signal("focused", self)
