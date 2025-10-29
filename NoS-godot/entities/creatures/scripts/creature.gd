class_name Creature extends Resource

@export var display_name: String
@export var stats: Stats
@export var movement: int
@export var weakness: Array[MoveType]
@export var resistences: Array[MoveType]
@export var immunities: Array[MoveType]
@export var skills: Array[Action]
@export var basic_attack: Action
@export var animator_path: String

@export var state_machine: CreatureStateMachine
var state: CreatureState

var drops

# Tame
@export var tameable : bool
var tame_prop
var tame_condition
