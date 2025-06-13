/// @description

// Pre set variables
// unit = new Battle_Unit();
// scale = 1;
event_inherited();

sprites = unit.sprites
idle_frames = 4;
current_image = 0;
animation_spd = 5;

head_sprites = [spr_hair, spr_head_acessories, spr_hats];
facing_right = 1;
facing_up = false;
clothing = 0;

ready = false;
charging_turns = 0;
charging_action = noone;
charging_targets = noone;
focusing = false;

effect = noone;
effect_image = 0;

// Damage changes that lasts one turn
physical_damage_temp = 0;
magical_damage_temp = 0;

for (var i = 0; i < array_length(unit.passives); ++i) {
	var _passive = unit.passives[i]
	
    for (var j = 0; j < array_length(_passive.info.battle_effects); ++j) {
		var _effect = _passive.info.battle_effects[j]
	    battle_connect_trigger(_effect.trigger, _effect.func, self)
	}
}