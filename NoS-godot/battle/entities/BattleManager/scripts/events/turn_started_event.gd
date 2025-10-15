class_name TurnStartedEvent extends BattleEvent

var turn_owner: BattleUnit
var turn_count: int

@warning_ignore("shadowed_variable")
func _init(turn_owner: BattleUnit, turn_count) -> void:
	self.turn_owner = turn_owner
	self.turn_count = turn_count
	super("turn_started")
