class_name Enemy extends Resource

@export var display_name : String
@export var stats : Stats
@export var movement : int
@export var actions : Array
@export var weakness : Array
@export var resistences : Array
@export var immunities : Array
var basic_attack

@export var animator_path : String
var init_state
var drops
var battle_script

# Tame
@export var tameable : bool
var tame_prop
var tame_condition
