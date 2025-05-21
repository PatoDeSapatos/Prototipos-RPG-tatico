enum MOVE_TYPES {
	NORMAL,
	SLASHING,
	BLUDGEONING,
	PIERCING,
	FIRE,
	LIGHT,
	POISON
}

enum MOVE_CATEGORY {
	PHYSICAL,
	MAGICAL,
	STATUS
}

enum MOVE_SHAPES {
	CIRCLE,
	SQUARE
}

enum CONDITIONS {
	NEVER,
	ONLY,
	ALWAYS
}

enum RESOURCES {
	ENERGY,
	MANA,
	LIFE,
	LENGTH
}

function get_type_color(_type) {
	switch(_type) {
		case MOVE_TYPES.NORMAL:
			return make_color_rgb(129, 151, 150);
		case MOVE_TYPES.SLASHING:
			return make_color_rgb(165, 48, 48);
		case MOVE_TYPES.BLUDGEONING:
			return make_color_rgb(165, 48, 48);
		case MOVE_TYPES.PIERCING:
			return make_color_rgb(165, 48, 48);
		case MOVE_TYPES.POISON:
			return make_color_rgb(122, 54, 123);
		case MOVE_TYPES.FIRE:
			return make_color_rgb(218, 134, 62);
		case MOVE_TYPES.LIGHT:
			return make_color_rgb(232, 193, 112);
		default:
			return c_white;
	}
}

function get_resource_name(_resource) {
	switch(_resource) {
		case RESOURCES.MANA:
			return "mp";
		case RESOURCES.ENERGY:
			return "ep";
		case RESOURCES.LIFE:
			return "hp";
		default:
			return "error";
	}
}

function get_resource_color(_resource) {
	switch(_resource) {
		case RESOURCES.MANA:
			return make_color_rgb(115, 190, 211);
		case RESOURCES.ENERGY:
			return make_color_rgb(222, 158, 65);
		case RESOURCES.LIFE:
			return make_color_rgb(165, 48, 48);
		default:
			return c_white;
	}
}

function end_charging_action(_user) {
	with (_user) {
		charging_turns = 0;
		charging_action = noone;
		charging_targets = noone;
	}
}

global.actions = {
	attack: {
		name: "Attack",
		description: "a melee attack!",
		types: [MOVE_TYPES.SLASHING, MOVE_TYPES.BLUDGEONING, MOVE_TYPES.PIERCING],
		moveCategory: MOVE_CATEGORY.PHYSICAL,
		costValue: 2,
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
			
			unit_take_damage(_damage, _user, _targets[0], [MOVE_TYPES.SLASHING], true);
		}	
	},
	rage_beatdown: {
		name: "Relentless Beatdown",
		description: "Relenteless rush into a enemy and activates rage for the next 2 turns.",
		types: [MOVE_TYPES.BLUDGEONING],
		moveCategory: MOVE_CATEGORY.PHYSICAL,
		costValue: 2,
		resource: RESOURCES.LIFE,
		userAnimation: "attack",
		hit_effect: spr_effect_hit,
		targetRequired: true,
		prioritizeEnemies: true,
		targetCount: 1,
		targetSelf: false,
		range: 1,
		
		func: function(_user, _targets) {
			var _user_attack = unit_get_stats(_user, "attack");
			
			var _damage = ceil(_user_attack + random_range(-_user_attack * .25, _user_attack * .5));
			
			unit_take_damage(_damage, _user, _targets[0], [MOVE_TYPES.BLUDGEONING], true);
			unit_add_passive(_user, global.passives_library.rage, 3);
		}	
	},
	guard: {
		name: "Guard",
		description: "protect yourself!",
		types: [MOVE_TYPES.NORMAL],
		moveCategory: MOVE_CATEGORY.STATUS,
		costValue: 0,
		resource: RESOURCES.ENERGY,
		userAnimation: "idle",
		targetRequired: false,
		range: -1,
		
		func: function(_user) {
			_user.defended = true;
			battle_create_floating_text("Guarding!", _user.x, _user.y, c_white);
			add_battle_text( string("{0} sets up the guard!", _user.unit.name) );
		}
	},
	attackBoost: {
		name: "Attack Boost",
		description: "Strongly raises the user attack stat.",
		moveCategory: MOVE_CATEGORY.STATUS,
		types: [MOVE_TYPES.NORMAL],
		costValue: 5,
		resource: RESOURCES.ENERGY,
		userAnimation: "idle",
		hit_effect: noone,
		targetRequired: false,
		range: -1,
		
		func: function (_user) {
			battle_change_stats(_user, "attack", 2);
		}
	},
	useItem: {
		name: "Use Item",
		description: "Use a item from your inventory.",
		costValue: 0,
		resource: noone,
		targetRequired: false,
		range: -1,
		
		func: function (_user, _item_stack) {
			var _item_info = get_item_by_id(_item_stack.id);
			_item_info.battle_script(_user);
		}
	},
	lightRay: {
		name: "Light Ray",
		description: "Charges for three turns, heals on the second and blasts a powerful bean dealing damage to a enemy.",
		costValue: 2,
		resource: RESOURCES.MANA,
		types: [MOVE_TYPES.LIGHT],
		moveCategory: MOVE_CATEGORY.MAGICAL,
		targetRequired: true,
		targetCount: 1,
		targetSelf: false,
		prioritizeEnemies: true,
		charge: true,
		chargingTurns: 3,
		range: 8,
		
		func: function (_user, _targets) {
			with(_user) { 
				switch(_user.charging_turns) {
					case 0:
						charging_action = global.actions.lightRay;
						charging_turns++;
						break;
					case 1: 
						battle_change_hp(_user, ceil(_user.unit.stats.hp/16));
						charging_turns++;
						break;
					case 2:
						var _attack = unit_get_stats(_user, "magic_attack");
						var _damage = ceil(_attack * 1.5 + irandom(_attack/4));
					
						unit_take_damage(_damage, _user, _targets[0], MOVE_TYPES.LIGHT, false);
						end_charging_action(self);
						break;
				}
			
			}
 		}
	},
	fireBall: {
		name: "Fire Ball",
		description: "Casts a powerfull fireball that give damage to a area.",
		costValue: 10,
		resource: RESOURCES.MANA,
		types: [MOVE_TYPES.FIRE],
		moveCategory: MOVE_CATEGORY.MAGICAL,
		targetRequired: true,
		targetCount: -1,
		targetSelf: true,
		prioritizeEnemies: true,
		charge: false,
		range: 6,
		projectile: spr_fire_ball_projectile,
		onUserEffect: spr_effect_fire_ball_casting,
		landingSpr: spr_effect_fire_ball_landing,
		areaTarget: true,
		originInPlayer: false,
		shape: MOVE_SHAPES.CIRCLE,
		shapeSize: 3,
		
		func: function (_user, _targets) {
			for (var i = 0; i < array_length(_targets); ++i) {
				var _attack = unit_get_stats(_user, "magic_attack");
				var _damage = ceil(_attack*2.5 + irandom(_attack));
			    unit_take_damage(_damage, _user, _targets[i], [MOVE_TYPES.FIRE], false);
			}
		}
	},
	poisonMist: {
		name: "Poison Mist",
		description: "Spreads a venomous mist around the caster that gives damage and has a chance to poison.",
		costValue: 5,
		resource: RESOURCES.MANA,
		types: [MOVE_TYPES.POISON],
		moveCategory: MOVE_CATEGORY.MAGICAL,
		targetRequired: true,
		targetCount: -1,
		targetSelf: false,
		prioritizeEnemies: true,
		charge: false,
		range: 3,
		areaTarget: true,
		originInPlayer: true,
		shape: MOVE_SHAPES.CIRCLE,
		
		func: function (_user, _targets) {
			for (var i = 0; i < array_length(_targets); ++i) {
				var _attack = unit_get_stats(_user, "magic_attack");
				var _damage = ceil(_attack + irandom(_attack div 4));
			    unit_take_damage(_damage, _user, _targets[i], [MOVE_TYPES.POISON], false);
				battle_inflict_condition(_targets[i], global.conditions.poison, 33);
			}
		}
	},
	smallHealthPotion: {
		name: "Use Small Health Potion",
		description: "Recovers 10 hp.",
		costValue: 0,
		resource: noone,
		targetRequired: false,
		targetSelf: true,
		range: -1,
		
		func: function (_user) {
			var _item = get_item_id_by_name("S_HEALTH_POTION");
			
			battle_change_hp(_user, 10);
			inventory_remove_item(_user.unit.inventory, _item, 1);
		}
	},
	placeProp: {
		name: "Place a prop",
		description: "Place a prop in battle.",
		costValue: 0,
		resource: noone,
		targetRequired: true,
		targetCount: -1,
		targetSelf: false,
		prioritizeEnemies: false,
		charge: false,
		range: 3,
		areaTarget: true,
		originInPlayer: false,
		shape: MOVE_SHAPES.CIRCLE,
		shapeSize: 1,
		
		func: function (_user, _targets, _point) {
			battle_create_props(global.props.sticky_meal, _point)
		}
	}
	
}