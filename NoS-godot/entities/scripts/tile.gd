class_name Tile
## A tile from the ground of the Dungeon.
## It can store the objects standing from above the tile and render them in position.

extends Node2D

const TILE = preload("res://entities/Tile.tscn")
@export var type := "default"
@export var image_number := 0
@export var stack : Array[String] = []
var tile_instance

@onready var image: AnimatedSprite2D = $Image

## [b]Image_number:[/b] The number of the tile's image (ex: 0 -> empty, 1 -> floor, ...) [br]
## [b]Type:[/b] The type of dungeon this tile belongs. This changes the base texture of the tile [br]
## [b]Stack:[/b] A array with the path of the objects standing above this tile
func _init(_image_number : int, _type : String = "default", _stack : Array[String] = []) -> void:
	image_number = _image_number
	type = _type
	stack = _stack

func update_info(tile_info : Tile):
	image_number = tile_info.image_number
	type = tile_info.type
	stack = tile_info.stack

func instantiate(parent : Node2D, pos : Vector2):
	var instance = TILE.instantiate()
	instance.global_position = pos
	instance.get_child(0).animation = type
	instance.get_child(0).frame = image_number
	tile_instance = instance
	parent.add_child(instance)

func render_stack():
	for i in len(stack):
		var render = load(stack[i])
		render.global_position.y -= (Game.TILE_SIZE/4)*i
