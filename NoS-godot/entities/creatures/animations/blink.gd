class_name Blink extends Timer

@export var eyes : AnimatedSprite2D
@export var can_blink : bool
@export var closed_eyes_frame : int

@export_group("Interval beetween blinks")
@export var blink_interval : float
@export var interval_range : float

func _process(delta: float) -> void:
	if (can_blink):
		if (is_stopped()):
			var interval = randf_range(-interval_range, interval_range)
			start(blink_interval + interval)
	else:
		stop()

func _on_timeout() -> void:
	var frame = eyes.frame
	
	eyes.frame = closed_eyes_frame
	await get_tree().create_timer(0.2).timeout
	eyes.frame = frame
