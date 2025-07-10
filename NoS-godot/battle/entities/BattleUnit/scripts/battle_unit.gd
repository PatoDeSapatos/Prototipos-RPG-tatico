class_name BattleUnit extends Node2D
@export var info : BattleUnitInfo

func assign_info(info : BattleUnitInfo):
	self.info = info
	add_child(info.animator.instantiate())
