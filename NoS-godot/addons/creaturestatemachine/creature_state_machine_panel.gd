@tool
class_name CreatureStateMachinePanel extends Control

const CREATURE_STATE_MACHINE_NODE = preload("res://addons/creaturestatemachine/creature_state_machine_node.tscn")

@onready var add_state_button: Button = $AddStateButton
@onready var graph_edit: GraphEdit = $GraphEdit
var initial_pos = Vector2(40, 40)
var triggers: Array

var state_machine: CreatureStateMachine:
	set(value):
		state_machine = value
		triggers = TriggerManager.new().triggers
		
		for n in graph_edit.get_children():
			if (n is CreatureStateMachineNode):
				n.queue_free()
		
		for state in state_machine.states:
			var node = _create_node(state)
		
		for c in value.connections:
			graph_edit.connect_node(c.from_node, c.from_port, c.to_node, c.to_port)

func _ready() -> void:
	add_state_button.pressed.connect(_on_add_state_pressed)

func _create_node(state: CreatureState) -> CreatureStateMachineNode:
	var node: CreatureStateMachineNode = CREATURE_STATE_MACHINE_NODE.instantiate()
	node.name = str(state.key)
	
	node.position_offset = state.node_pos
	if (state.node_pos == Vector2.ZERO):
		node.position_offset += initial_pos
	
	node.initial_seted.connect(_on_initial_button_selected)
	node.delete.connect(_on_delete_request)
	
	graph_edit.add_child(node)
	node.triggers = triggers
	node.state = state
	
	if (state_machine.states.size() == 0):
		node.initial_check.button_pressed = true
	
	return node

func _on_add_state_pressed():
	if (state_machine == null):
		return
	
	var state: CreatureState = CreatureState.new()
	state_machine.states.push_back(state)
	_create_node(state)
	
func _on_delete_request(node: CreatureStateMachineNode):
	state_machine.states.erase(node.state)
	node.queue_free()

func _on_initial_button_selected(node: CreatureStateMachineNode):
	var i = 0
	for current_node in graph_edit.get_children():
		if (!current_node is CreatureStateMachineNode):
			continue
		
		if (current_node != node):
			current_node.initial_check.button_pressed = false
		else:
			state_machine.initial_state_index = i
		
		i += 1

func edit(state_machine):
	self.state_machine = state_machine

func _on_graph_edit_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	if (from_node == to_node):
		return
	
	for conection in graph_edit.connections:
		if ((conection.from_node == from_node && conection.from_node == to_node) || (conection.from_node == to_node && conection.to_node == from_node)):
			return
	
	state_machine.connections.push_back({"from_node": from_node, "from_port": from_port, "to_node": to_node, "to_port": to_port})
	graph_edit.connect_node(from_node, from_port, to_node, to_port)

func _on_graph_edit_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	state_machine.connections.erase({"from_node": from_node, "from_port": from_port, "to_node": to_node, "to_port": to_port})
	graph_edit.disconnect_node(from_node, from_port, to_node, to_port)
	
