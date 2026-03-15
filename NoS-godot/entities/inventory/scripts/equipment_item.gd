class_name EquipmentItem extends Item

enum EquipmentSlots {
	ONE_HAND,
	TWO_HANDS,
	HEAD,
	TORSO,
	LEGS
}

@export var slot: EquipmentSlots = EquipmentSlots.TORSO
@export var stats: Stats
@export var passives: Passive
@export var action: Action
