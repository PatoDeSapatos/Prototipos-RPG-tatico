class_name ActionEffects extends Node2D

@onready var animations: AnimatedSprite2D = $Animations
var animation_name: String
signal animation_finished

func play(animation_name: String, pos: Vector2):
	global_position = pos
	self.animation_name = animation_name
	animations.play(animation_name)

func _on_animations_animation_finished() -> void:
	animation_finished.emit()
	queue_free()
