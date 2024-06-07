function generate_dungeon() {
	//tamanho do room tem que ser divisível por tile_size * roomSize * scale
	var roomSize = 10
	var roomsWidth = obj_draw.width / roomSize
	var roomsHeight = obj_draw.height / roomSize
	var roomsAmount = 40

	var nodeGrid = []
	for (var i = 0; i < roomsHeight; i++) {
	    nodeGrid[i] = []
	}

	var nodes = []
	var emptyNode

	var toCollapse = []

	var offsets = [
	    new Point(0, -1), //top
	    new Point(0, 1), //bottom
	    new Point(1, 0), //right
	    new Point(-1, 0), //left
	]

	//var offsetLetter = {
	//    0: "U",
	//    1: "D",
	//    2: "R",
	//    3: "L"
	//}
}

function Node(_name, _sprite, _index) constructor {
    name = _name
    sprite = _sprite
	index = _index
}

function Point(_x, _y) constructor {
    x = round(_x)
    y = round(_y)
}