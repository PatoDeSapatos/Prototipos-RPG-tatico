class_name ActionArea extends Resource

enum Shapes {
	CIRCLE,
	SQUARE
	}

@export var origin_point: Vector2
@export var range: int
@export var shape: Shapes

func _init(origin_point: Vector2, range: int, shape: Shapes) -> void:
	self.origin_point = origin_point
	self.range = range
	self.shape = shape

func point_in_area(point: Vector2) -> bool:
	match shape:
		Shapes.SQUARE:
			return 0
		Shapes.CIRCLE:
			return (point.x - origin_point.x)**2 + (point.y - origin_point.y)**2 <= range**2
		_:
			return false
