extends Control

@onready var button_container: Control = %ButtonContainer
@onready var skill_menu: Control = $CanvasLayer/SkillMenu
@onready var item_menu: ItemMenu = $CanvasLayer/ItemMenu
@onready var aux_buttons: Control = $CanvasLayer/AuxButtons

@export var radius := 80
@export var animation_speed := 0.1
@export var camera: Camera2D = null

var active := false
var animating := false
var center_position

func _get_button_target_position(button):
	var angle = deg_to_rad(button.angle)-PI
	var target_direction = Vector2(radius*1.15 * cos(angle), radius/1.5 * sin(angle))
	var target_position = center_position - button.get_rect().size/2 + target_direction
	
	if (button.angle == 270):
		target_position.y += 10
	
	return target_position

func _on_button_pressed(button: ActionButton):
	var state_name = button.state_name
	
	if (!self.animating && self.active && !button.disabled && state_name != ""):
		await hide_ui()
		button.set_pressed_no_signal(false)
		BattleHandler.exit_state_turn(Callable(self, state_name))
	
func _ready() -> void:
	center_position = global_position
	button_container.hide()
	
	for button in button_container.get_children():
		button.global_position = center_position
		button.connect("interacted", _on_button_pressed)

func _process(delta: float) -> void:
	if (camera != null):
		var follow = BattleHandler.get_user().global_position
		center_position = Vector2(follow.x - 6, follow.y - 24)
	
	if (active):
		if (BattleHandler.get_state() != BattleHandler.manager.turn_state):
			hide_ui()
		
		for button in button_container.get_children():
			button.global_position = _get_button_target_position(button)

func show_ui():
	if (active || animating):
		return
	
	animating = true
	button_container.show()
	aux_buttons.show()
	
	$ButtonContainer/AttackButton.active = BattleHandler.manager.main_actions > 0
	$ButtonContainer/ItemButton.active = BattleHandler.manager.main_actions > 0
	$ButtonContainer/GuardButton.active = BattleHandler.manager.main_actions > 0
	
	$ButtonContainer/MoveButton.active = BattleHandler.manager.movement_actions > 0
	
	$ButtonContainer/PassButton.visible = BattleHandler.manager.extra_action
	
	for button in button_container.get_children():
		if (button.angle < 90 || button.angle > 270):
			button.set_hdir("left")
		else:
			button.set_hdir("right")
		
		button.global_position = center_position
		
		var target_position = _get_button_target_position(button)
		var tween = get_tree().create_tween()
		tween.tween_property(button, "global_position", target_position, animation_speed)
		tween.parallel()
		tween.tween_property(button, "scale", Vector2.ONE, animation_speed)
	
	await get_tree().create_timer(animation_speed).timeout
	active = true
	animating = false

func hide_ui():
	if (!active || animating):
		return
	
	animating = true
	aux_buttons.hide()
	
	for button in button_container.get_children():
		var tween = get_tree().create_tween()
		tween.tween_property(button, "global_position", Vector2(center_position.x - 36, center_position.y), animation_speed)
		tween.parallel()
	
	await get_tree().create_timer(animation_speed/2).timeout
	
	active = false
	animating = false
	button_container.hide()
	
func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_pressed("test_ui")):
		if !active: show_ui() 
		else: hide_ui()

func start_state_skill():
	var skills = [preload("res://actions/basic_attacks/sword_slash.tres"), preload("res://actions/skills/sharpen blades.tres"), preload("res://actions/skills/poison_mist.tres"), preload("res://actions/skills/fire_ball.tres")]
	skill_menu.user = BattleHandler.get_user()
	skill_menu.set_skills(skills)
	skill_menu.show_menu()
	skill_menu.option_callback = _on_skill_selected
	BattleHandler.set_state(Callable(self, "state_skill"))

func _on_skill_selected(skill: Action):
	skill_menu.option_callback = Callable()
	BattleHandler.aim_action(skill)

func state_skill():
	pass

func start_state_move():
	BattleHandler.set_state(BattleHandler.manager.start_state_move)

func start_state_item():
	item_menu.items = BattleHandler.get_user().info.inventory.items
	item_menu.show_menu()
	BattleHandler.set_state(state_item)

func state_item():
	if (Input.is_action_just_pressed("menu_cancel")):
		item_menu.hide_menu()
		BattleHandler.return_to_prev_state()
	
	if (Input.is_action_just_pressed("menu_confirm")):
		item_menu.hide_menu()
		var item = item_menu.current_item
		BattleHandler.get_user().info.inventory.remove_item(item.item.name, 1)
		if (item != null && item.item.action != null):
			BattleHandler.aim_action(item.item.action)
