class_name Enemy extends Resource

@export var display_name: String
@export var stats: Stats
@export var movement: int
@export var weakness: Array[MoveType]
@export var resistences: Array[MoveType]
@export var immunities: Array[MoveType]
@export var skills: Dictionary[String, Action]
@export var basic_attack: Action
@export var animator_path: String

@export var init_battle_state_path: String
@export var init_dungeon_state_path: String = "res://entities/enemies/creature_states/dungeon/wanderer.gd"
var drops
var battle_script

# Tame
@export var tameable : bool
var tame_prop
var tame_condition
