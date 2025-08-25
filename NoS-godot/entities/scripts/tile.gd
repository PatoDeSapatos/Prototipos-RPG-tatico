class_name Tile extends Node2D
## A tile from the ground of the Dungeon.
## It can store the objects standing from above the tile and render them in position.

const DUNGEON_TILE_HIGHLIGHT = preload("res://entities/assets/tiles/dungeon_tile_highlight.png")
const DUNGEON_TILE_SELECTED = preload("res://entities/assets/tiles/dungeon_tile_selected.png")
const TILE = preload("res://entities/Tile.tscn")

@export var tile_info: TileInfo:
	set(info):
		image.animation = Tables.DungeonType.keys()[info.type].to_lower()
		image.frame = info.image_number
		render_stack()

@export var highlighted := false:
	set(value):
		highlighted = value
		queue_redraw()

@export var selected := false:
	set(value):
		selected = value
		queue_redraw()

@onready var image: AnimatedSprite2D = $Image

var tile_instance
var coll: bool

func _draw() -> void:
	if (selected):
		draw_texture(DUNGEON_TILE_SELECTED, Vector2.ZERO - Vector2(Game.TILE_SIZE, Game.TILE_SIZE)/2, Color(1, 1, 1, 0.9))
		
	if (highlighted):
		draw_texture(DUNGEON_TILE_HIGHLIGHT, Vector2.ZERO - Vector2(Game.TILE_SIZE, Game.TILE_SIZE)/2)

func render_stack():
	if (tile_info == null):
		return
	
	for i in len(tile_info.stack):
		var render = load(tile_info.stack[i])
		render.global_position.y -= (Game.TILE_SIZE/4)*i
