class_name PassiveEffect extends Serializable

var trigger: String
var callback: Callable

var origin: BattleUnit
var target: BattleUnit

func _init(trigger="", callback=Callable()) -> void:
	self.trigger = trigger
	self.callback = callback

func resolve(event: BattleEvent):
	if (!callback.is_null()):
		callback.call(event, origin, target)
