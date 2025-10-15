class_name CreatureStateMachineNode 
extends GraphNode

@onready var initial_check: CheckButton = $VBoxContainer/InitialCheck

var state_path
var change_trigger: String
var change_expression: String

var slot_color := Color.WHITE
signal initial_button_selected(button: CreatureStateMachineNode)

func _ready() -> void:
	set_slot(0, true, 0, slot_color, true, 0, slot_color)

func _on_initial_check_pressed() -> void:
	initial_button_selected.emit(self)
