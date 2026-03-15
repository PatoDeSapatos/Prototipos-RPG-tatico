class_name BattleEvent extends Resource

var trigger_name: String
var response: Dictionary

@warning_ignore("shadowed_variable")
func _init(trigger_name: String, response: Dictionary = {}) -> void:
	self.trigger_name = trigger_name
	self.response = response
