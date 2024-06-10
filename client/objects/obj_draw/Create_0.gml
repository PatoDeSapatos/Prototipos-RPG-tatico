scale = 2
tile_size = 32 * scale
roomSize = 16

roomSizeInPixels = tile_size * roomSize * 15
room_width = roomSizeInPixels
room_height = roomSizeInPixels

width = round(room_width / tile_size)
height = round(room_height / tile_size)
grid = ds_grid_create(width, height)
start_x = room_width / 2
start_y = room_height / 4
selected = -1
player_bottom = -1
depth = 10

ds_grid_set_region(grid, 0, 0, width, height, undefined)