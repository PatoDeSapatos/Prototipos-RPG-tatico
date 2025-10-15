class_name SkillMenu extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var background: ColorRect = $Background

@onready var skill_list: InventoryList = $MarginContainer/Content/SkillList

# Skill Desc
@onready var skill_name: Label = $MarginContainer/Content/PanelContainer/MarginContainer/VBoxContainer/SkillName
@onready var skill_desc: RichTextLabel = $MarginContainer/Content/PanelContainer/MarginContainer/VBoxContainer/SkillDesc
@onready var type_icon: TextureRect = $MarginContainer/Content/PanelContainer/MarginContainer/VBoxContainer/HSliptContainer/HBoxContainer/TypeIcon
@onready var skill_category: TextureRect = $MarginContainer/Content/PanelContainer/MarginContainer/VBoxContainer/HSliptContainer/SkillCategory

@onready var audio: AudioStreamPlayer = $"../../Audio"

const SKILL_OPTION = preload("res://battle/ui/skill_option.tscn")

var current_option = 0
var skills: Array
var active = false
var option_callback: Callable

func _ready() -> void:
	skill_list.option_interacted.connect(_on_option_selected)
	skill_list.option_changed.connect(_on_option_changed)
	hide()

func show_menu():
	if (active):
		return
	
	show()
	animation_player.play("show_menu")
	await animation_player.animation_finished
	active = true

func hide_menu():
	#if (!active):
		#return
	
	animation_player.play("hide_menu")
	await animation_player.animation_finished
	active = false
	hide()

func _unhandled_input(event: InputEvent) -> void:
	if (active && event.is_action_pressed("menu_cancel")):
		await hide_menu()
		BattleHandler.return_to_prev_state()

func _on_option_changed(new_option: int):
	var option = skill_list.elements[new_option]
	
	# skill desc
	var skill = option.action
	skill_name.text = skill.name
	skill_name.add_theme_color_override("font_color", skill.types[0].color)
	skill_desc.text = DescHandler.format_text_colors(skill.description)
	type_icon.texture = skill.types[0].icon
	skill_category.texture = skill.category.icon

func _on_option_selected(option: SkillOption):
	if (!active):
		return
	
	active = false
	await hide_menu()
	option_callback.call(option.action)

func _process(delta: float) -> void:
	#if (options_container.get_children().size() > 0):
		#var option = options_container.get_children()[current_option]
		#selector.set_pos(Vector2(option.global_position.x - 10, option.global_position.y + selector.get_rect().size.y/2))
	
	if (!active):
		return

func set_skills(skills):
	self.skills = skills
	skill_list.clear()

	for i in len(skills):
		var option = SKILL_OPTION.instantiate()
		skill_list.add_element(option)
		option.set_action(skills[i])
	
	skill_list.change_option_selected(0)
