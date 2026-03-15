class_name AttackEvent extends BattleEvent

var user: BattleUnit
var target: BattleUnit
var damage: int
var action: Action

@warning_ignore("shadowed_variable")
func _init(user: BattleUnit, target: BattleUnit, damage: int, action: Action) -> void:
	self.user = user
	self.target = target
	self.damage = damage
	self.action = action
	super("attack")
