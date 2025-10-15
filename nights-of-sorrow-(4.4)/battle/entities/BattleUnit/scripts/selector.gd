extends Node2D

const BATTLE_TARGETING = preload("res://battle/entities/BattleUnit/assets/battle_targeting.png")
@onready var timer: Timer = $"../Timer"
var focus_position := Vector2.ZERO
var focus_down := false
var focus: bool

func _draw() -> void:
	if (focus):
		draw_texture(BATTLE_TARGETING, focus_position)
		
		if (timer.is_stopped()):
			timer.start()

func _on_timer_timeout() -> void:
	if (!focus):
		timer.stop()

	if (focus_down):
		focus_position = Vector2(focus_position.x, focus_position.y - 1)
	else:
		focus_position = Vector2(focus_position.x, focus_position.y + 1)

	focus_down = !focus_down
	queue_redraw()
