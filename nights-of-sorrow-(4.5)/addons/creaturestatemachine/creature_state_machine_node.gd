@tool
class_name CreatureStateMachineNode 
extends GraphNode

@onready var script_path: TextEdit = $VBoxContainer/StatePath
@onready var change_expression: CodeEdit = $VBoxContainer/ChangeExpression
@onready var initial_check: CheckButton = $VBoxContainer/InitialCheck
@onready var change_trigger: OptionButton = $VBoxContainer/ChangeTrigger
@onready var delete_node: Button = $VBoxContainer/DeleteNode

var triggers: Array

var state: CreatureState:
	set(value):
		state = value
		
		script_path.text = value.script_path
		change_expression.text = value.change_expression
		initial_check.button_pressed = value.initial
		
		for i in range(triggers.size()):
			change_trigger.add_item(triggers[i])
			if (triggers[i] == state.change_trigger):
				change_trigger.select(i)
		
		state.change_trigger = change_trigger.get_item_text(change_trigger.selected);

var slot_color := Color.WHITE
signal initial_seted(node: CreatureStateMachineNode)
signal delete(node: CreatureStateMachineNode)

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is Dictionary && data.has("files")

func _drop_data(position: Vector2, data: Variant):
	var file_paths = data["files"]
	for path in file_paths:
		script_path.text = path
	state.script_path = script_path.text

func _ready() -> void:
	script_path.drag_and_drop_selection_enabled = true
	delete_node.pressed.connect(_on_delete_pressed)
	
func _on_initial_check_toggled(toggled_on: bool) -> void:
	if (toggled_on):
		initial_seted.emit(self)
	
	state.initial = toggled_on

func _on_delete_pressed():
	delete.emit(self)

func _on_state_path_text_changed() -> void:
	state.script_path = script_path.text

func _on_position_offset_changed() -> void:
	if (state != null):
		state.node_pos = position_offset

func _on_change_expression_text_changed() -> void:
	state.change_expression = change_expression.text

func _on_change_trigger_item_selected(index: int) -> void:
	state.change_trigger = change_trigger.get_item_text(index)
