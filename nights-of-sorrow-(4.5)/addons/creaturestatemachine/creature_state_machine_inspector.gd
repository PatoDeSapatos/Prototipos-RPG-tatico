@tool
extends EditorInspectorPlugin

var bottom_panel: CreatureStateMachinePanel

func _init(bottom_panel: CreatureStateMachinePanel) -> void:
	self.bottom_panel = bottom_panel

func _can_handle(object: Object) -> bool:
	return true

func _parse_property(object: Object, type: Variant.Type, name: String, hint_type: PropertyHint, hint_string: String, usage_flags: int, wide: bool) -> bool:
	if type == TYPE_OBJECT && hint_string == "CreatureStateMachine":
		var prop = preload("res://addons/creaturestatemachine/creature_state_machine_property.gd").new()
		prop.pressed.connect(func():
			if (object.get(name) == null):
				object.set(name, CreatureStateMachine.new())
			
			bottom_panel.edit(object.get(name))
			bottom_panel.set("creature", object)
			bottom_panel.show()
			)
			
		add_property_editor(name, prop)
		return true
	
	return false
