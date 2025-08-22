class_name Conditions extends Resource

static var condition_library = {
	"poisoned": StatusCondition.new(
		"",
		PassiveEffect.new(
			"end_turn",
			func (target: BattleUnit): BattleHandler.change_unit_hp(target, round(target.info.hp/12))
			),
		null,
		"hurt",
		Color.WEB_PURPLE,
		preload("res://actions/types/poison.tres")
	)
}
