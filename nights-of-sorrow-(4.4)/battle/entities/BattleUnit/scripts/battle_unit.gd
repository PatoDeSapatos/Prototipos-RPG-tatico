class_name BattleUnit extends Node2D

@onready var targeting_timer: Timer
@onready var animator: Animator = $Animator

@export var info : BattleUnitInfo

const BATTLE_TARGETING = preload("res://battle/entities/BattleUnit/assets/battle_targeting.png")
var focus_position := Vector2()
var focus_down := false
var animating := false
var grid_init_pos: Vector2
var owner_id: int
var done: bool

var focus := false:
	set(value):
		focus = value
		
		if (value):
			top_level = true
			z_index = 1000
		else:
			top_level = false
		
		queue_redraw()

func assign_info(info : BattleUnitInfo):
	self.info = info
	var animator = load(info.animator)
	if (animator != null):
		add_child(animator.instantiate())

func _ready() -> void:
	var shape_size = animator.coll.shape.get_rect().size if animator != null else Vector2(0, BATTLE_TARGETING.get_height()/2)
	self.focus_position = Vector2(-BATTLE_TARGETING.get_width()/2, -BATTLE_TARGETING.get_height() - shape_size.y)
	
	if (animator != null):
		animator.area.mouse_entered.connect(_on_mouse_entered)
		animator.area.mouse_exited.connect(_on_mouse_exited)
	
	var targeting_timer = Timer.new()
	targeting_timer.wait_time = 0.5
	targeting_timer.one_shot = false
	targeting_timer.timeout.connect(_on_timer_timeout)
	self.targeting_timer = targeting_timer
	add_child(targeting_timer)

func _on_mouse_entered():
	BattleHandler.set_unit_hover(self)

func _on_mouse_exited():
	BattleHandler.set_unit_hover(null)

func _process(delta: float) -> void:
	if (!focus):
		var grid_pos = Grid.scene_to_tile_pos(global_position.x, global_position.y, grid_init_pos)
		var depth = (Grid.tile_to_scene_pos(grid_pos.x, grid_pos.y, grid_init_pos).y)
		z_index = depth

func _draw() -> void:
	if (focus):
		draw_texture(BATTLE_TARGETING, focus_position)
		
		if (targeting_timer.is_stopped()):
			targeting_timer.start()

func _on_timer_timeout():
	if (!focus):
		targeting_timer.stop()

	var shape_size = animator.coll.shape.get_rect().size if animator != null else Vector2(0, BATTLE_TARGETING.get_height()/2)
	if (focus_down):
		focus_position = Vector2(-BATTLE_TARGETING.get_width()/2, -BATTLE_TARGETING.get_height() - shape_size.y - 5)
	else:
		focus_position = Vector2(-BATTLE_TARGETING.get_width()/2, -BATTLE_TARGETING.get_height() - shape_size.y - 3)
	
	focus_down = !focus_down
	
	queue_redraw()
	
func get_effect_origin_position() -> Vector2:
	if (animator == null): return position
	return animator.effect_origin.global_position if animator.effect_origin != null else global_position
