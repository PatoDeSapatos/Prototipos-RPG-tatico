class_name Passive extends Resource

var name: String
var icon: Texture2D
var battle_effects: Array[PassiveEffect]
var text: String
var end_text: String

func _init(name: String, icon: Texture2D, battle_effects: Array[PassiveEffect], text: String, end_text: String) -> void:
	self.name = name
	self.icon = icon
	self.battle_effects = battle_effects
	self.end_text = end_text
	self.text = text
