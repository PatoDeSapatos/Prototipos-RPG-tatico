extends Node

static func tile_to_scene_pos(x : int, y : int, init_pos : Vector2):
	return Vector2(((x - y) * (Game.TILE_SIZE / 2)) + init_pos.x, ((x + y) * (Game.TILE_SIZE / 4)) + init_pos.y)

static func scene_to_tile_pos():
	pass
