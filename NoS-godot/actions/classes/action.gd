class_name Action extends Serializable

enum TurnStep {
	MAIN,
	MOVEMENT,
	SPECIAL
}

@export_category("Classification")
@export var name: String
@export var description: String
@export var types: Array[MoveType]
@export var category: MoveCategory
@export var is_physical: bool
@export var turn_step: TurnStep
@export var power: int

@export_category("Stat Change")
@export_group("On User")
@export var on_user_stat_changes: Array[String]
@export_range(-6, 6, 1) var on_user_change_levels: Array[int]
@export_range(0, 100, 1) var on_user_change_chances: Array[int] = [100]

@export_group("On Target")
@export var on_target_stat_changes: Array[String]
@export_range(-6, 6, 1) var on_target_change_levels: Array[int]
@export_range(0, 100, 1) var on_target_change_chances: Array[int] = [100]

@export_category("Customization")
@export var custom_source_managment: bool
@export var script_path: String

@export_category("Source")
@export var cost_value: int
@export var source: Source

@export_category("Effects")
@export var user_animation: String
@export var target_animation: String = "hurt"
@export var user_effect: String
@export var target_effect: String
@export var particle_effect_paths: Array[String]

@export_category("Projectile")
@export var has_projectile: bool
@export var projectile_texture: Texture2D
@export var projectile_effect_name: String
@export var projectile_particle_path: String

@export_category("Conditions")
@export var condition_name: String
@export_range(0, 100, 1) var inflict_chance: int

@export_category("Target")
@export var target_required: bool = true
@export var target_self: bool
@export var target_dead: bool
@export var apply_effects_at_once: bool = true
@export var range: int

@export_group("On Target Skill")
@export var on_target: bool
@export var target_count: int
@export var prioritize_enemies: bool

@export_group("Area Based Skill")
@export var area_target: bool
@export var origin_in_player: bool
@export var area: ActionArea = ActionArea.new(3, ActionArea.Shapes.CIRCLE)
