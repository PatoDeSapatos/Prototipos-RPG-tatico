extends Control

@onready var button_container: Control = %ButtonContainer

@export var radius := 80
@export var animation_speed := 0.2
@export var camera: Camera2D = null

var active := false
var center_position

func _get_button_target_position(button):
	var angle = deg_to_rad(button.angle)-PI
	var target_direction = Vector2(radius*1.15 * cos(angle), radius/1.5 * sin(angle))
	var target_position = center_position - button.get_rect().size/2 + target_direction
	
	if (button.angle == 270):
		target_position.y += 10
	
	return target_position

func _ready() -> void:
	center_position = global_position + get_viewport_rect().size / 2
	button_container.hide()
	
	for button in button_container.get_children():
		button.global_position = center_position

func _process(delta: float) -> void:
	if (camera != null):
		center_position = Vector2(camera.follow.global_position.x - 6, camera.follow.global_position.y - 24) + get_viewport_rect().size / 2
	
	if (active):
		for button in button_container.get_children():
			button.global_position = _get_button_target_position(button)

func show_ui():
	if (active):
		return
	
	button_container.show()
	
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

func hide_ui():
	if (!active):
		return
	
	for button in button_container.get_children():
		var tween = get_tree().create_tween()
		tween.tween_property(button, "global_position", Vector2(center_position.x - 36, center_position.y), animation_speed)
		tween.parallel()
	
	await get_tree().create_timer(animation_speed).timeout
	
	active = false
	button_container.hide()
	
func _unhandled_input(event: InputEvent) -> void:
	if (Input.is_action_just_pressed("test_ui")):
		if !active: show_ui() 
		else: hide_ui()
