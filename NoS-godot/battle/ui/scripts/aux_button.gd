class_name AuxButton extends HBoxContainer

@onready var label: Label = $Label
@onready var key: Label = $NinePatchRect/Key

@export var trigger_input: StringName = &"end_turn":
	set(value):
		if (key != null):
			trigger_input = value
			key.text = InputMap.action_get_events(trigger_input)[0].as_text().split()[0]

@export var text: String:
	set(value):
		if (label != null):
			text = value
			label.text = value
