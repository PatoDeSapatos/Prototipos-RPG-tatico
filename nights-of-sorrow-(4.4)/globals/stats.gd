class_name Stats extends Serializable

@export var hp : int
@export var mana : int
@export var energy : int
@export var defense : int
@export var magic_defense : int
@export var attack : int
@export var magic_attack : int
@export var spd : int
@export var luck : int

static func create(hp=0, mana=0, energy=0, defense=0, magic_defense=0, attack=0, magic_attack=0, spd=0, luck=0) -> Stats:
	var obj = Stats.new()
	obj.hp = hp
	obj.mana = mana
	obj.energy = energy
	obj.defense = defense
	obj.magic_defense = magic_defense
	obj.attack = attack
	obj.magic_attack = magic_attack
	obj.spd = spd
	obj.luck = luck
	return obj
