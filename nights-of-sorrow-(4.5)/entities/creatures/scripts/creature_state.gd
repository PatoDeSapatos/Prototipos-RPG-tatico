class_name CreatureState extends Resource

@export var script_path: String
@export var change_trigger: String
@export var change_expression: String
@export var initial: bool

@export var node_pos: Vector2

var key: int

func _init() -> void:
	self.key = ResourceUID.create_id()
