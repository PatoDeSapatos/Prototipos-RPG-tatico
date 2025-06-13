enum EFFECT_TRIGGERS {
	END_TURN_SELF,
	END_TURN_ALL,
	ATTACK
}

global.conditions = {
	poison: {
		name: "poison",
		inflict_name: "poisoned",
		description: "When poisoned, a unit loses 1/8 of its own health.",
		effect_spr: spr_effect_poison,
		trigger: EFFECT_TRIGGERS.END_TURN_SELF,
		targetAnimation: "hurt",
		col: c_purple,
		type: MOVE_TYPES.POISON,
		func: function(_target) {
			with(_target) {
				var _damage = max(round(_target.unit.max_hp/8), 0);
				instance_create_depth(_target.x, _target.y, -1000, obj_battle_floating_text, {
					text: _damage,
					col: c_purple,
					font: fnt_inventory_title
				});
				_target.unit.hp = max(0, _target.unit.hp - _damage);
			}
		}
	}
}