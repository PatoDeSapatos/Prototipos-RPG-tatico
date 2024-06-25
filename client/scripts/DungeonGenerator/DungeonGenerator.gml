function generate_dungeon() {
    var ambient = {

        roomsAmount: 40,

		offsets: [
	        new Point(0, -1), //top
	        new Point(0, 1), //bottom
	        new Point(1, 0), //right
	        new Point(-1, 0), //left
	    ],
        offsetLetter: [
            "U",
            "D",
            "R",
            "L"
        ],
		toCollapse: [],
        nodes: [],
        emptyNode: noone,
        salas: 1,
        nodeGrid: [],
        salasGrid: [],
        roomsWidth: obj_dungeon_manager.width div obj_dungeon_manager.roomSize,
        roomsHeight: obj_dungeon_manager.height div obj_dungeon_manager.roomSize
	}

    for (var i = 0; i < ambient.roomsHeight; i++) {
        ambient.nodeGrid[i] = []
        ambient.salasGrid[i] = []
        for (var j = 0; j < ambient.roomsWidth; j++) {
            ambient.nodeGrid[i][j] = noone
            ambient.salasGrid[i][j] = []
			
			for (var _i = 0; _i < obj_dungeon_manager.roomSize; ++_i) {
			    ambient.salasGrid[i][j][_i] = []
				for (var _j = 0; _j < obj_dungeon_manager.roomSize; ++_j) {
			        ambient.salasGrid[i][j][_i][_j] = noone
				}
			}
        }
    }

    method(ambient, register)()
	var data = date_current_datetime()
    method(ambient, collapse)()
    show_debug_message(string("finished in: {0} s with {1} rooms", date_second_span(data, date_current_datetime()), ambient.salas))

    return ambient
}

function collapse() {
	array_push(toCollapse, new Point(roomsWidth / 2, roomsHeight / 2))
	var initial = true
	
	while (array_length(toCollapse) > 0) {
		var atual = array_shift(toCollapse)
		if (is_struct(nodeGrid[atual.y][atual.x])) continue

		var potentialNodes = []
		array_copy(potentialNodes, 0, nodes, 0, array_length(nodes))

        var nome = []
        var nomeRestritivo = []
		
		for (var i = 0; i < array_length(offsets); i++) {
            
            var neighbour = new Point(atual.x + offsets[i].x, atual.y + offsets[i].y)

            if (isInside(neighbour)) {
                var neighbourNode = nodeGrid[neighbour.y][neighbour.x]

                if (is_struct(neighbourNode)) {
                    if (neighbourNode == emptyNode) addRestritivo(i, nomeRestritivo)
                    switch (i) {
                        case 0:
                            if (string_pos("D", neighbourNode.name)) array_push(nome, "U")
                            else addRestritivo(i, nomeRestritivo)
                            break
                        case 1:
                            if (string_pos("U", neighbourNode.name)) array_push(nome, "D")
                            else addRestritivo(i, nomeRestritivo)
                            break
                        case 2:
                            if (string_pos("L", neighbourNode.name)) array_push(nome, "R")
                            else addRestritivo(i, nomeRestritivo)
                            break
                        case 3:
                            if (string_pos("R", neighbourNode.name)) array_push(nome, "L")
                            else addRestritivo(i, nomeRestritivo)
                            break
                    }
                } else if (!array_contains(toCollapse, neighbour)) {
                    array_push(toCollapse, neighbour)
                }
            } else {
                addRestritivo(i, nomeRestritivo)
            }
        }
		
		apenasCompativeis(potentialNodes, nome, nomeRestritivo)
		
		if (array_length(potentialNodes) <= 0) {

            if (initial) {
                var rndNode = nodes[irandom(array_length(nodes) - 1)]
                nodeGrid[atual.y][atual.x] = rndNode
                initial = false
            } else {
                nodeGrid[atual.y][atual.x] = emptyNode
            }
        } else {
            var randomNode

            if (salas < roomsAmount) {
                array_sort(potentialNodes, function(a, b) { return string_length(b.name) - string_length(a.name) })
                randomNode = irandom(floor(array_length(potentialNodes) / 2))
            } else {
                array_sort(potentialNodes, function(a, b) { return string_length(a.name) - string_length(b.name) })
                randomNode = 0
            }

            salas++
            nodeGrid[atual.y][atual.x] = potentialNodes[randomNode]
        }
	}
}

function apenasCompativeis(potenciais, nome, nomeRestritivo) {
    if (array_length(nome) == 0) return array_delete(potenciais, 0, array_length(potenciais))

    for (var i = array_length(potenciais) - 1; i >= 0; --i) {
        
		var ambient = {
			potenciais: potenciais,
			i: i
		}
		
        var includes = array_all(nome, method(ambient, function(v) { return string_pos(v, potenciais[i].name) != 0 }))
		var excludes = array_any(nomeRestritivo, method(ambient, function(v) { return string_pos(v, potenciais[i].name) != 0 }))

        if (!includes || excludes) {
            array_delete(potenciais, i, 1)
        }
    }
}

function isInside(_point) {
    if (_point.x >= 0 && _point.x < roomsWidth && _point.y >= 0 && _point.y < roomsHeight) {
        return true
    }
    return false
}

function addRestritivo(i, nomeRestritivo) {
    array_push(nomeRestritivo, offsetLetter[i])
}

function register() {
	emptyNode = new Node("", "")
	
	if (!directory_exists(working_directory + "\\dungeon_rooms")) {
		return;
	}
	
	var _room_name = file_find_first(working_directory + "\\dungeon_rooms\\generated\\*.png", 0);
	while(_room_name != "") {
		var _direction = string_upper(string_split(string_split(_room_name, "_")[2], ".")[0])

		array_push(nodes, new Node(_direction, _room_name))

		_room_name = file_find_next();
	}
}

function Node(_name, _fileName) constructor {
    name = _name
    fileName = _fileName
}

function Point(_x, _y) constructor {
    x = round(_x)
    y = round(_y)
}