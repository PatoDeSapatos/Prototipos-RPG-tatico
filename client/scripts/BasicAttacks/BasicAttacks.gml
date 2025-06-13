global.basic_attacks = {
	unarmed: {
		name: "Unarmed Strike",
		description: "a melee attack!",
		types: [MOVE_TYPES.BLUDGEONING],
		moveCategory: MOVE_CATEGORY.PHYSICAL,
		costValue: -5,
		resource: RESOURCES.ENERGY,
		userAnimation: "attack",
		hit_effect: spr_effect_hit,
		targetRequired: true,
		prioritizeEnemies: true,
		targetCount: 1,
		targetSelf: false,
		range: 1,
		
		func: function(_user, _targets) {
			var _user_attack = unit_get_stats(_user, "attack");
			var _damage = ceil(_user_attack + random_range(-_user_attack * .25, _user_attack * .25));
			unit_take_damage(_damage, _user, _targets[0], [MOVE_TYPES.BLUDGEONING], true);
		}	
	},
	magic_missile: {
		name: "Magic Missile",
		description: "Cast a missile made of your mana to strike the target!",
		types: [MOVE_TYPES.FIRE],
		moveCategory: MOVE_CATEGORY.MAGICAL,
		costValue: -5,
		resource: RESOURCES.MANA,
		userAnimation: "attack",
		hit_effect: spr_effect_hit,
		targetRequired: true,
		prioritizeEnemies: true,
		targetCount: 1,
		targetSelf: false,
		range: 5,
		
		func: function(_user, _targets) {
			var _user_attack = unit_get_stats(_user, "magic_attack");
			var _damage = ceil(_user_attack + random_range(-_user_attack * .25, _user_attack * .25));	
			unit_take_damage(_damage, _user, _targets[0], [MOVE_TYPES.FIRE], true);
		}
	}
}