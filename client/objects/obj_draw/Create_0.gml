scale = 2
tile_size = 32 * scale
width = round(room_width / tile_size)
height = round(room_height / tile_size)
grid = ds_grid_create(width, height)
start_x = room_width / 2
start_y = room_height / 4
selected = -1
player_bottom = -1
depth = 10

ds_grid_set_region(grid, 0, 0, width, height, {spr: 0, z: 0})

for (var _x = 0; _x < width; ++_x) {
    for (var _y = 0; _y < height; ++_y) {

		if (_x == round(width / 2) && _y == round(height / 2)) instance_create_layer(tileToScreenX(_x, _y), tileToScreenY(_x, _y), "Instances", obj_iso_player)
		
	    grid[# _x, _y] = {
			spr: (_x == 0 || _x == width - 1 || _y == 0 || _y == height - 1) ? 5 : 1,
			z: 0
		}
	}
}