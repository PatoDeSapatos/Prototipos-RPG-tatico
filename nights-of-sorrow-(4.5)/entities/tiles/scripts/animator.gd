class_name Animator extends Node2D

@onready var effect_origin: Node2D = $EffectOrigin
@onready var animations: AnimationPlayer = $Animations
@onready var area: Area2D = $Area
@onready var coll: CollisionShape2D = $Area/Coll
