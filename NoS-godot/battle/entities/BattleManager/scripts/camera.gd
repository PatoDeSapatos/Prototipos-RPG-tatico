extends Camera2D

@export var follow: Node2D = null

func _process(delta: float) -> void:
	if (follow != null):
		global_position = follow.global_position - get_viewport_rect().size/2
