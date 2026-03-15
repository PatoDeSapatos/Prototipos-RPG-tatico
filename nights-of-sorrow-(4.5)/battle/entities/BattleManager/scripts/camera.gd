class_name BattleCamera extends Camera2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var follow: Node2D = null

var camera_offset: Vector2 = Vector2.ZERO

var zoom_target: Vector2 = Vector2.ONE
var offset_target: Vector2 = Vector2.ZERO

var target_pos: Vector2 = Vector2.ZERO

var is_bar_on: bool = false

func _process(delta: float) -> void:
	if (follow != null):
		target_pos = follow.global_position
	
	if (camera_offset != offset_target):
		camera_offset = lerp(camera_offset, offset_target, delta)
	
	zoom = lerp(zoom, zoom_target, delta * 2)
	
	global_position = target_pos + camera_offset

func hide_bar():
	if (is_bar_on):
		animation_player.play("hide_bar")
		is_bar_on = false

func show_bar():
	if (!is_bar_on):
		animation_player.play("show_bar")
		is_bar_on = true
