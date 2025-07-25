class_name BattleUnit extends Node2D
const BATTLE_TARGETING = preload("res://battle/entities/BattleUnit/assets/battle_targeting.png")
@onready var targeting_timer: Timer
@onready var shape: CollisionShape2D = $Animator/Area/Coll
@export var info : BattleUnitInfo
var focus_position := Vector2()
var focus_down := false
var grid_init_pos: Vector2
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
	add_child(info.animator.instantiate())

func _ready() -> void:
	self.focus_position = Vector2(-BATTLE_TARGETING.get_width()/2, -BATTLE_TARGETING.get_height() - shape.shape.get_rect().size.y)
	
	var targeting_timer = Timer.new()
	targeting_timer.wait_time = 0.5
	targeting_timer.one_shot = false
	targeting_timer.timeout.connect(_on_timer_timeout)
	self.targeting_timer = targeting_timer
	add_child(targeting_timer)

func _process(delta: float) -> void:
	if (!focus):
		var grid_pos = Grid.scene_to_tile_pos(global_position.x, global_position.y, grid_init_pos)
		var depth = -(Grid.tile_to_scene_pos(grid_pos.x - 1, grid_pos.y - 1, grid_init_pos).y);
		z_index = depth

func _draw() -> void:
	if (focus):
		draw_texture(BATTLE_TARGETING, focus_position)
		
		if (targeting_timer.is_stopped()):
			targeting_timer.start()

func _on_timer_timeout():
	if (!focus):
		targeting_timer.stop()

	if (focus_down):
		focus_position = Vector2(-BATTLE_TARGETING.get_width()/2, -BATTLE_TARGETING.get_height() - shape.shape.get_rect().size.y - 5)
	else:
		focus_position = Vector2(-BATTLE_TARGETING.get_width()/2, -BATTLE_TARGETING.get_height() - shape.shape.get_rect().size.y - 3)
	
	focus_down = !focus_down
	
	queue_redraw()
