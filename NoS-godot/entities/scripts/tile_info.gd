class_name TileInfo extends Resource

@export var type := Tables.DungeonType.DEFAULT
@export var image_number := 0
@export var stack: Array[String]

## [b]Image_number:[/b] The number of the tile's image (ex: 0 -> empty, 1 -> floor, ...) [br]
## [b]Type:[/b] The type of dungeon this tile belongs. This changes the base texture of the tile [br]
## [b]Stack:[/b] A array with the path of the objects standing above this tile
func _init(image_number: int, type := Tables.DungeonType.DEFAULT, stack: Array[String] = []) -> void:
	self.image_number = image_number
	self.type = type
	self.stack = stack
