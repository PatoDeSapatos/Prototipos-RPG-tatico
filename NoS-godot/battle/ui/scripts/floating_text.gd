extends Node2D

@onready var label: Label = $Label
@onready var disappear: Timer = $Disappear

var value
var color: Color = Color.WHITE
var speed := 4
var start_y: int
var gravity := 8
var direction: Vector2

var has_gravity: bool
var can_despawn: bool

func _ready() -> void:
	label.text = str(value)
	label.label_settings = label.label_settings.duplicate(true)
	label.label_settings.font_color = color
	
	direction = Vector2(randf_range(-0.5, 0.5), -speed)
	start_y = global_position.y
	
	if (!has_gravity):
		direction.y /= 2
		disappear.start()
		disappear.timeout.connect(func():
			can_despawn = true
			)
		var tween = create_tween()
		tween.tween_property(self, "direction:y", 0.0, disappear.wait_time)
	
	scale = Vector2(0.2, 0.2)

func _process(delta: float) -> void:
	if (global_position.y > start_y || can_despawn):
		direction.y = 0
		direction.x = 0
		modulate.a = lerpf(modulate.a, 0, speed/2*delta)
		scale = lerp(scale, Vector2.ZERO, speed/2*delta)
	else:
		if (has_gravity):
			direction.y += gravity*delta
		
		scale = lerp(scale, Vector2.ONE, speed*delta)
	
	if (abs(modulate.a) <= speed*delta):
		queue_free()
	
	global_position += direction
