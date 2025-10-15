class_name BattleEvent extends Resource

var response: Array[Callable]
var trigger_name: String

@warning_ignore("shadowed_variable")
func _init(trigger_name: String) -> void:
	self.trigger_name = trigger_name
