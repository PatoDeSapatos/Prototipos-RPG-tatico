function passive_effect(_trigger, _func) constructor {
	trigger = _trigger
	func = _func
}

function Event(_name) constructor {
	name = _name
}

function AttackEvent(_user, _target) : Event() constructor {
	name = "ATTACK"
	user = _user
	target = _target
}

function StartTurnEvent(_user) : Event() constructor {
	name = "START_TURN"
	user = _user
}


global.passives_library = {
	rage: {
		name: "Rage",
		battle_effects: [ 
			new passive_effect("ATTACK", function (_event) {
				if (!is_user_turn(_event.user)) {
					return
				}	
				
				battle_change_damage_temp(_event.user, true, 2)
			}),
			
			
		],
		
		text: " enters in a fury state!",
		end_text: " calms down."
	}
}