class_name ProjectileTrail extends Node2D

var texture: Texture2D
var pos: Vector2

func _init(texture: Texture2D, pos: Vector2) -> void:
	self.texture = texture
	self.pos = pos

func _draw() -> void:
	if (texture != null):
		draw_texture(texture, position - texture.get_size()/2)

func _ready() -> void:
	modulate.a = 0.6
	queue_redraw()

func _process(delta: float) -> void:
	modulate.a -= 0.1
	global_position.y -= 0.1
	global_position = pos
	
	if (modulate.a <= 0):
		queue_free()
