extends TextureRect

@onready var timer: Timer = $Timer

var animation_duration := 0.5
var length: int = 1.5
var pos: Vector2
	
func set_pos(pos: Vector2):
	self.pos = pos
	global_position = Vector2(pos.x + length, pos.y)

func _on_timer_timeout() -> void:
	global_position.x = pos.x + length
	length *= -1
