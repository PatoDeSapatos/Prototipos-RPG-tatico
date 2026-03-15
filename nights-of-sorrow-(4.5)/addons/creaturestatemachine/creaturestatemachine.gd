@tool
extends EditorPlugin

var plugin
var panel

func _enter_tree() -> void:
	panel = preload("res://addons/creaturestatemachine/creature_state_machine_panel.tscn").instantiate()
	add_control_to_bottom_panel(panel, "State Machine Editor")
	
	plugin = preload("res://addons/creaturestatemachine/creature_state_machine_inspector.gd").new(panel)
	add_inspector_plugin(plugin)

func _exit_tree() -> void:
	remove_control_from_bottom_panel(panel)
	remove_inspector_plugin(plugin)
