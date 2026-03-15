class_name Passives

static var passives_library = {
	"rage": Passive.new(
		"Rage",
		 null,
		[
			PassiveEffect.new(
				"action",
				func (event: ActionEvent, origin: BattleUnit, target: BattleUnit):
				BattleHandler.add_battle_text("Placeholder")
				),
		],
		 "enters in a fury state!",
		 "calms down."
		),
		
	"poisoned":
		null
}
