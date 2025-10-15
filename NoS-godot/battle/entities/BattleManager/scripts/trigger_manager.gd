class_name TriggerManager extends Resource

signal turn_started(event: TurnStartedEvent)
signal attack(event: AttackEvent)

var triggers: Array

func _init() -> void:
	var built_in = Resource.new().get_signal_list()
	var signals = get_signal_list().filter(func(e): return !e in built_in)
	triggers = signals.map(
		func(e):
			return e.name
	)
