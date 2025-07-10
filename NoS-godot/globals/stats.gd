class_name Stats
extends Resource

@export var hp : int
@export var mana : int
@export var energy : int
@export var defense : int
@export var magic_defense : int
@export var attack : int
@export var magic_attack : int
@export var spd : int
@export var luck : int

func _init(hp=0, mana=0, energy=0, defense=0, magic_defense=0, attack=0, magic_attack=0, spd=0, luck=0) -> void:
	self.hp = hp
	self.mana = mana
	self.energy = energy
	self.defense = defense
	self.magic_defense = magic_defense
	self.attack = attack
	self.magic_attack = magic_attack
	self.spd = spd
	self.luck = luck
