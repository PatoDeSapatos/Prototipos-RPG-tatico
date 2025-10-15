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

@export var init_battle_state: CreatureState = preload("res://entities/creatures/creature_states/battle/simple.tres")
@export var init_dungeon_state: CreatureState

@export var state_machine: CreatureStateMachine

var drops

# Tame
@export var tameable : bool
var tame_prop
var tame_condition
