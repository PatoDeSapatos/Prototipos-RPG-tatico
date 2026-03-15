class_name TargetCanvas extends CanvasLayer

@onready var selector: Node2D = $Selector
var pos: Vector2
var active: bool:
	set(value):
		active = value
		selector.focus = value
		selector.focus_position = pos
		selector.queue_redraw()
