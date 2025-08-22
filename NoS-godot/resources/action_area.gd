class_name ActionArea extends Resource

enum Shapes {
	CIRCLE,
	SQUARE
	}

@export var shape: Shapes
@export var range: int
var origin_point: Vector2 = Vector2.ZERO

func _init(range: int, shape: Shapes, origin_point: Vector2 = Vector2.ZERO) -> void:
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
