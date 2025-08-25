class_name LoadMapNodes

static func _init_dir() -> DirAccess:
	if !DirAccess.dir_exists_absolute(Game.GENERATED_RESOURCES):
		DirAccess.make_dir_recursive_absolute(Game.GENERATED_RESOURCES + "rooms/")
	
	var gen_dir := DirAccess.open(Game.GENERATED_RESOURCES + "rooms/")
	if (!gen_dir.get_files().is_empty()):
		gen_dir.list_dir_begin()
		while true:
			var file_name = gen_dir.get_next()
			if file_name == "":
				break
			gen_dir.remove(file_name)
		gen_dir.list_dir_end()
	
	return gen_dir

static func load_map_nodes() -> Array[GridNode]:
	var gen_dir := _init_dir()
	var grid_nodes: Array[GridNode] = []
	
	var dir = DirAccess.open("res://resources/rooms/")
	dir.list_dir_begin()
	while true:
		var file_name = dir.get_next()
		if file_name == "":
			break
		if !file_name.ends_with(".png"):
			continue
		
		var texture: CompressedTexture2D = load("res://resources/rooms/" + file_name)
		var image := texture.get_image()
		image.convert(Image.FORMAT_RGBA8)
		image.resource_name = file_name
		grid_nodes.append(GridNode.new(image))
		grid_nodes.append_array(_rotate_image(image, file_name))
	
	#for i in grid_nodes: #não há necessidade de salvar as imagens em disco
		#i.image.save_png(Game.GENERATED_RESOURCES + i.get_filename())
	dir.list_dir_end()
	return grid_nodes

static func _rotate_image(_image: Image, _image_name: String) -> Array[GridNode]:
	var data := GridNode.data_from_filename(_image_name)
	
	var rotated_nodes: Array[GridNode] = []
	
	var cycles := 1 if _is_room_ud(data["direction"]) else 3
	for i in cycles:
		var rotated_direction = _generate_rotated_direction(data["direction"]);
		if (rotated_direction == ""):
			continue;
		data["direction"] = rotated_direction
		
		var rotated_image: Image = _image.duplicate(true)
		for j in i+1:
			rotated_image.rotate_90(COUNTERCLOCKWISE)
		rotated_nodes.append(GridNode.new(rotated_image, data))
	
	return rotated_nodes

static func _generate_rotated_direction(_directions: String) -> String:
	if (_directions.length() >= 4):
		return ""
	
	var rotated_name = ""
	for i in _directions:
		match(i):
			"U": rotated_name += "L"
			"R": rotated_name += "U"
			"D": rotated_name += "R"
			"L": rotated_name += "D"
	return rotated_name

static func _is_room_ud(_directions: String) -> bool:
	return (_directions.length() == 2 && _directions[0] == "U" && _directions[1] == "D")
