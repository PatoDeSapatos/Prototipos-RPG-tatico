function generate_dungeon() {
	register()
	var data = date_current_datetime()
    collapse()
    show_debug_message(string("finished in: {0} s with {1} rooms", date_second_span(data, date_current_datetime()), salas))
	show_str()
}

function collapse() {
	array_push(toCollapse, new Point(roomsWidth / 2, roomsHeight / 2))
	
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
		
		if (potentialNodes.length <= 0) {

            if (initial) {
                var rndNode = nodes[irandom(array_length(potentialNodes) - 1)]
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

function show_str() {
	for (var _y = 0; _y < array_length(nodeGrid); _y++) {
        var line1 = ""
        var line2 = ""
        var line3 = ""

        for (var _x = 0; _x < array_length(nodeGrid[_y]); _x++) {
            var nodeSpriteSplitted = string_split(nodeGrid[_y][_x].sprite, "\n")

            line1 += nodeSpriteSplitted[0]
            line2 += nodeSpriteSplitted[1]
            line3 += nodeSpriteSplitted[2]
        }

        show_debug_message(line1)
        show_debug_message(line2)
        show_debug_message(line3)
    }
}

function apenasCompativeis(potenciais, nome, nomeRestritivo) {
    if (array_length(nome) == 0) return array_delete(potenciais, 0, array_length(potenciais))

    for (var i = array_length(potenciais) - 1; i >= 0; --i) {
        //checa pra todas as letras se o nome do node às contém
        var includes = array_all(nome, function(v) { return string_pos(v, potenciais[i].name) != 0 })
		var excludes = array_any(nomeRestritivo, function(v) { return string_pos(v, potenciais[i].name) != 0 })
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
	emptyNode = new Node("", "ooo\nooo\nooo", 0)
    array_push(nodes, new Node("U", "o⬆o\no o\nooo", 0))
    array_push(nodes, new Node("D", "ooo\no o\no⬇o", 0))
    array_push(nodes, new Node("L", "ooo\n⬅ o\nooo", 0))
    array_push(nodes, new Node("R", "ooo\no ➡️\nooo", 0))
    array_push(nodes, new Node("UD", "o⬆o\no o\no⬇o", 0))
    array_push(nodes, new Node("UL", "o⬆o\n⬅ o\nooo", 0))
    array_push(nodes, new Node("UR", "o⬆o\no ➡️\nooo", 0))
    array_push(nodes, new Node("ULR", "o⬆o\n⬅ ➡️\nooo", 0))
    array_push(nodes, new Node("UDL", "o⬆o\n⬅ o\no⬇o", 0))
    array_push(nodes, new Node("UDR", "o⬆o\no ➡️\no⬇o", 0))
    array_push(nodes, new Node("UDLR", "o⬆o\n⬅ ➡️\no⬇o", 0))
    array_push(nodes, new Node("DL", "ooo\n⬅ o\no⬇o", 0))
    array_push(nodes, new Node("DR", "ooo\no ➡️\no⬇o", 0))
    array_push(nodes, new Node("DLR", "ooo\n⬅ ➡️\no⬇o", 0))
    array_push(nodes, new Node("LR", "ooo\n⬅ ➡️\nooo", 0))
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