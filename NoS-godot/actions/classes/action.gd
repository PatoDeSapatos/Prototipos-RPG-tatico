class_name Action extends Resource

@export var name: String
@export var description: String
@export var types: Array[MoveType]
@export var category: MoveCategory
@export var cost_value: int
@export var source: Source
@export var user_animation: String
@export var hit_effect: Texture2D
@export var target_required: bool
@export var prioritize_enemies: bool
@export var target_count: int
@export var target_self: bool
@export var target_dead: bool
@export var range: int
@export var area_target: bool
@export var origin_in_player: bool
@export var shape: int
@export var function: Callable = Callable()
@export var is_physical: bool
