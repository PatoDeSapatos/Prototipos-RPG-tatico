class_name BattleUnitInfo extends Resource

var in_target = false;
var defended = false;

var is_broken = false;
var is_dead = false;
var animating = false;

var grid_pos : Vector2
var stat_changes
var condition
var passives : Array

func _init(_position, _stat_changes, _condition = null, _passives = []) -> void:
	grid_pos = _position
	stat_changes = _stat_changes
	condition = _condition
	passives = _passives
