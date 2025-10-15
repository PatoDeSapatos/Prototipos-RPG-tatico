extends Node2D

@onready var label: Label = $Label

var value
var color: Color = Color.WHITE
var speed := 4
var start_y: int
var gravity := 8
var direction: Vector2

func _ready() -> void:
	label.text = str(value)
	label.label_settings.font_color = color
	direction = Vector2(randf_range(-0.5, 0.5), -speed)
	start_y = global_position.y
	
	scale = Vector2(0.2, 0.2)

func _process(delta: float) -> void:
	if (global_position.y > start_y):
		direction.y = 0
		direction.x = 0
		modulate.a = lerpf(modulate.a, 0, speed/2*delta)
		scale = lerp(scale, Vector2.ZERO, speed/2*delta)
	else:
		direction.y += gravity*delta
		scale = lerp(scale, Vector2.ONE, speed*delta)
	
	if (abs(modulate.a) <= speed*delta):
		queue_free()
	
	global_position += direction
