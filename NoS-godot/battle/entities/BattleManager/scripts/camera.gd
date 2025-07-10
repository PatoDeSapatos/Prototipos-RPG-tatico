extends Camera2D

@export var follow: Node2D = null

func _process(delta: float) -> void:
	var dir = Input.get_vector("left", "right", "up", "down")
	
	if (follow != null && dir == Vector2.ZERO):
		global_position = follow.global_position - get_viewport_rect().size/2
	
	global_position += dir
