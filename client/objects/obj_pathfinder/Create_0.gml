/// @description
grid_size = 10; 
cell_size = 64;
grid = [];
path = [];

start_cell = [-1, -1];

draw_size = grid_size*cell_size;
selected_cell = -1;

spd = 60;

for (var i = 0; i < grid_size; ++i) {
    for (var j = 0; j < grid_size; ++j) {
	    grid[j, i] = 0;
	}
}