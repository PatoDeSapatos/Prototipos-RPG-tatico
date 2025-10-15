class_name StatusCondition extends Resource

var name: String
var effect: PassiveEffect
var effect_spr: Texture2D
var target_animaton: String
var color: Color
var type: MoveType

func _init(name: String, effect: PassiveEffect, effect_spr: Texture2D, target_animation: String, color: Color, type: MoveType) -> void:
	self.name = name
	self.effect = effect
	self.effect_spr = effect_spr
	self.target_animaton = target_animation
	self.color = color
	self.type = type
