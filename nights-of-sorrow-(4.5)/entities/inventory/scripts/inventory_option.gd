class_name InventoryOption extends PanelContainer

var selected: bool
var active: bool = true:
	set(value):
		active = value
		modulate.a = 1.0 if active else 0.3

signal interacted
signal focused(InventoryOption)

func _ready() -> void:
	focus_entered.connect(_on_focus_entered)
	mouse_entered.connect(_on_focus_entered)

func change_selection(selected: bool):
	self.selected = selected
	
func _on_focus_entered() ->  void:
	self.emit_signal("focused", self)

func _on_mouse_entered() -> void:
	self.emit_signal("focused", self)
