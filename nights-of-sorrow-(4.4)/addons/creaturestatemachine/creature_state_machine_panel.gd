@tool
extends Control

const CREATURE_STATE_MACHINE_NODE = preload("res://addons/creaturestatemachine/creature_state_machine_node.tscn")

@onready var add_state_button: Button = $AddStateButton
@onready var graph_edit: GraphEdit = $GraphEdit
var initial_pos = Vector2(40, 40)
var state_machine: CreatureStateMachine = CreatureStateMachine.new():
	set(value):
		pass

func _ready() -> void:
	add_state_button.pressed.connect(_on_add_state_pressed)

func _on_add_state_pressed():
	var node = CREATURE_STATE_MACHINE_NODE.instantiate()
	node.position_offset += initial_pos
	
	state_machine.states.push_back(node)
	graph_edit.add_child(node)
	
	node.initial_button_selected.connect(_on_initial_button_selected)
	
	if (state_machine.states.size() == 0):
		node.initial_check.button_pressed = true

func _on_initial_button_selected(node: CreatureStateMachineNode):
	for current_node in graph_edit.get_children():
		if (current_node is CreatureStateMachineNode && current_node != node):
			current_node.initial_check.button_pressed = false

func edit(state_machine):
	self.state_machine = state_machine

func _on_graph_edit_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	for conection in graph_edit.connections:
		if ((conection.from_node == from_node && conection.from_node == to_node) || (conection.from_node == to_node && conection.to_node == from_node)):
			return
	
	if (from_node == to_node):
		return
	
	state_machine.connections.push_back({"from_node": from_node, "from_port": from_port, "to_node": to_node, "to_port": to_port})
	graph_edit.connect_node(from_node, from_port, to_node, to_port)

func _on_graph_edit_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	state_machine.connections.erase({"from_node": from_node, "from_port": from_port, "to_node": to_node, "to_port": to_port})
	graph_edit.disconnect_node(from_node, from_port, to_node, to_port)
	
