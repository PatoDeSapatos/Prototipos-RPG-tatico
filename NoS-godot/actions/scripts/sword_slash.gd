extends Action

func _call(user: BattleUnit, targets: Array[BattleUnit], point: Vector2):
	var damage = 1
	BattleHandler.unit_take_damage(damage, user.info, targets[0].info, self)
