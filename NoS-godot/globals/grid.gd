extends Node

func tile_to_scene_pos(x : int, y : int, init_pos : Vector2) -> Vector2:
	return Vector2(((x - y) * (Game.TILE_SIZE / 2)) + init_pos.x, ((x + y) * (Game.TILE_SIZE / 4)) + init_pos.y)

func scene_to_tile_pos(x : int, y : int, init_pos : Vector2) -> Vector2:
	var screen_x = x - init_pos.x
	var screen_y = y - init_pos.y
	
	var res = Vector2()
	res.x = floor(((screen_x / (Game.TILE_SIZE / 2)) + (screen_y / (Game.TILE_SIZE / 4))) / 2)
	res.y = floor(((screen_y / (Game.TILE_SIZE / 4)) - (screen_x / (Game.TILE_SIZE / 2))) / 2)

	return res
