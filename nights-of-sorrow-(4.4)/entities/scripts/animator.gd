class_name Animator extends Node2D

@onready var effect_origin: Node2D = $EffectOrigin
@onready var animations: AnimationPlayer = $Animations
@onready var area: Area2D = $Area
@onready var coll: CollisionShape2D = $Area/Coll

var subviewport: SubViewport

func _ready() -> void:
	subviewport = SubViewport.new()
	subviewport.transparent_bg = true
	subviewport.render_target_update_mode = subviewport.UPDATE_ONCE
	
	
	add_child(subviewport)

func get_image() -> Texture2D:
	if (subviewport != null):
		return subviewport.get_texture()
	return null
