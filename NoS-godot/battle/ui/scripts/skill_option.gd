class_name SkillOption extends PanelContainer

@export var action: Action

@onready var type_icon: TextureRect = $Option/HBoxContainer/TypeIcon
@onready var skill_name: Label = $Option/HBoxContainer/SkillName
@onready var cost_value: Label = $Option/HBoxContainer/Cost/CostValue
@onready var background: ColorRect = $Background

var selected: bool

signal interacted
signal focused

func set_action(action: Action):
	self.action = action
	var type = action.types[0]
	
	background.color = type.color
	background.color.a = 0.4
	type_icon.texture = type.icon
	cost_value.text = str(action.cost_value) + action.source.short
	cost_value.add_theme_color_override("font_color", action.source.color)
	skill_name.text = action.name

func _input(event: InputEvent) -> void:
	if ((event.is_action_pressed("mouse_left") || event.is_action_pressed("menu_confirm")) && selected):
		emit_signal("interacted", self)

func _on_focus_entered() -> void:
	self.emit_signal("focused", self)

func _on_mouse_entered() -> void:
	self.emit_signal("focused", self)

func change_selection(selected: bool):
	if (selected):
		background.color.a = 1.0
	else:
		background.color.a = 0.4
		
	self.selected = selected
