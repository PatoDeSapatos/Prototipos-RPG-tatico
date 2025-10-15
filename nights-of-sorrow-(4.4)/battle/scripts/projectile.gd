class_name Projectile extends Node2D

signal end

const SPEED = 0.15
var target_pos: Vector2
var texture: Texture2D
var particle_path: String
var particle

func _init(target_pos: Vector2, texture: Texture2D) -> void:
	self.target_pos = target_pos
	self.texture = texture

func _draw() -> void:
	if (texture != null):
		draw_texture(texture, position - texture.get_size()/2)

func _ready() -> void:
	var timer = Timer.new()
	timer.wait_time = 0.02
	timer.connect("timeout", _on_timer_timeout)
	timer.autostart = true
	add_child(timer)
	
	var particle = load(particle_path)
	if (particle != null):
		particle = particle.instantiate()
		particle.z_index = z_index + 1
		self.particle = particle
		self.particle.connect("finished", _on_finished)
		add_child(particle)
	
	scale = Vector2.ZERO
	top_level = true
	z_index = 10
	queue_redraw()

func _process(delta: float) -> void:
	global_position = lerp(global_position, target_pos, SPEED)
	scale = lerp(scale, Vector2.ONE, 0.2)
	
	if (abs((global_position - target_pos).length()) <= SPEED):
		particle.set_emitting(false)
		end.emit()

func _on_timer_timeout():
	add_child(ProjectileTrail.new(texture, global_position))

func _on_finished():
	queue_free()
