class_name ActionEvent extends BattleEvent

var user: BattleUnit
var targets: Array[BattleUnit]
var action: Action
var damage: int

@warning_ignore("shadowed_variable")
func _init(user: BattleUnit, targets: Array[BattleUnit], damage: int, action: Action) -> void:
	self.user = user
	self.targets = targets
	self.damage = damage
	self.action = action
	
	super("action", {
		"targets": targets,
		"damage": damage,
		"action": action,
		"can_use": true
	})
