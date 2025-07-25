class_name SkillMenu extends Control

# Skill List
@onready var options_container: VBoxContainer = $MarginContainer/Content/SkillList/SkillOptions/OptionsContainer
@onready var selector: TextureRect = $MarginContainer/Selector
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var background: ColorRect = $Background

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

signal option_changed

func _ready() -> void:
	option_changed.connect(Callable(self, "_on_option_changed"))
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

func _on_option_focus(option: SkillOption):
	var new_option = options_container.get_children().find(option)
	if (new_option != current_option):
		option_changed.emit(new_option)

func _on_option_changed(new_option: int):
	if (new_option >= len(skills)):
		new_option = 0
	elif (new_option < 0):
		new_option = len(skills)-1
	
	# skill option
	var option: SkillOption = options_container.get_children()[new_option]
	options_container.get_children()[current_option].change_selection(false)
	option.change_selection(true)
	
	# skill desc
	var skill = option.action
	skill_name.text = skill.name
	skill_name.add_theme_color_override("font_color", skill.types[0].color)
	skill_desc.text = DescHandler.format_text_colors(skill.description)
	type_icon.texture = skill.types[0].icon
	skill_category.texture = skill.category.icon
	
	current_option = new_option

func _on_option_interacted(option: SkillOption):
	if (!active):
		return
	
	active = false
	await hide_menu()
	option_callback.call(option.action)

func _process(delta: float) -> void:
	if (options_container.get_children().size() > 0):
		var option = options_container.get_children()[current_option]
		selector.set_pos(Vector2(option.global_position.x - 10, option.global_position.y + selector.get_rect().size.y/2))
	
	if (!active):
		return
	
	var dir = int(Input.is_action_just_pressed("down")) - int(Input.is_action_just_pressed("up"))
	if (dir != 0):
		option_changed.emit(current_option + dir)

func set_skills(skills):
	self.skills = skills

	for c in options_container.get_children():
		c.queue_free()

	for i in len(skills):
		var option = SKILL_OPTION.instantiate()
		option.connect("focused", Callable(self, "_on_option_focus"))
		option.connect("interacted", Callable(self, "_on_option_interacted"))
		options_container.add_child(option)
		option.set_action(skills[i])
		
		if (i == 0):
			option.change_selection(true)
	
	if (len(skills) > 0):
		_on_option_changed(0)
		
