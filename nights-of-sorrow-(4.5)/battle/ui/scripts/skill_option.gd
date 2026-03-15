class_name SkillOption extends InventoryOption

@export var action: Action

@onready var type_icon: TextureRect = $Option/HBoxContainer/TypeIcon
@onready var skill_name: Label = $Option/HBoxContainer/SkillName
@onready var cost_value: Label = $Option/HBoxContainer/Cost/CostValue
@onready var background: NinePatchRect = $Background

func set_action(action: Action, user: BattleUnit):
	self.action = action
	var type = action.types[0]
	
	background.modulate = type.color
	background.modulate.a = 0.4
	type_icon.texture = type.icon
	skill_name.text = action.name
	
	if (action.source != null):
		cost_value.text = str(action.cost_value) + action.source.short.to_upper()
		
		cost_value.add_theme_color_override("font_color", action.source.color)
		
		if (user.info.get(action.source.name.to_lower()) != null):
			active = action.cost_value <= user.info.get(action.source.name.to_lower())

func change_selection(selected: bool):
	super(selected)
	
	if (selected):
		background.modulate.a = 1.0
	else:
		background.modulate.a = 0.4
