class_name PassiveEffect extends Resource

var trigger: String
var callback: Callable

func _init(trigger, callback) -> void:
	self.trigger = trigger
	self.callback = callback
