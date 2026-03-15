class_name Animator extends Node2D

@onready var effect_origin: Node2D = $EffectOrigin
@onready var animations: AnimationPlayer = $Animations
@onready var area: Area2D = $Area
@onready var coll: CollisionShape2D = $Area/Coll
var viewport: SubViewport

func _ready() -> void:
	viewport = SubViewport.new()
	add_child(viewport)

func get_image() -> Texture:
	return viewport.get_texture()
