class_name ActionParticle extends Node2D

signal finished

func _ready() -> void:
	scale *= 0.5
	for particle: CPUParticles2D in get_children():
		particle.finished.connect(_on_finished)
		particle.emitting = true

func _on_finished():
	finished.emit()
	queue_free()

func set_emitting(value: bool):
	for particle: CPUParticles2D in get_children():
		particle.emitting = value
