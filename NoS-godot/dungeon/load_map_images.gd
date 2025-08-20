extends Node

func init_dir() -> DirAccess:
	if !DirAccess.dir_exists_absolute(Game.GENERATED_RESOURCES):
		DirAccess.make_dir_recursive_absolute(Game.GENERATED_RESOURCES)
	
	var gen_dir := DirAccess.open(Game.GENERATED_RESOURCES)
	if (!gen_dir.get_files().is_empty()):
		gen_dir.list_dir_begin()
		while true:
			var file_name = gen_dir.get_next()
			if file_name == "":
				break
			gen_dir.remove(file_name)
		gen_dir.list_dir_end()
	
	return gen_dir

func load_map_images() -> Array[Image]:
	var gen_dir := init_dir()
	var images: Array[Image] = []
	
	var dir = DirAccess.open("res://resources/rooms/")
	dir.list_dir_begin()
	while true:
		var file_name = dir.get_next()
		if file_name == "":
			break
		
		var image: Image = load("res://resources/rooms/" + file_name)
		images.append(image)
		
		var rotated_images := rotate_image(image, file_name)
		for i in images:
			i.save_png(Game.GENERATED_RESOURCES + i.resource_name)
		images.append_array(rotated_images)
	
	dir.list_dir_end()
	return images

func rotate_image(_image: Image, _image_name: String) -> Array[Image]:
	var name_splited := _image_name.split("_")
	var room_identifier := name_splited[0] + "_" + name_splited[1] + "_";
	var room_directions := name_splited[2]
	var current_direction := room_directions
	
	var rotated_images: Array[Image] = []
	
	var cycles := 1 if is_room_ud(room_directions) else 3
	for i in cycles:
		var rotated_name = generate_rotated_name(current_direction);
		if (rotated_name == ""):
			continue;
		
		var rotated_image: Image = _image.duplicate(true)
		rotated_image.rotate_90(CLOCKWISE)
		rotated_images.append(rotated_image)
	
	return rotated_images

func generate_rotated_name(_directions: String) -> String:
	_directions = _directions.get_slice(".", 0)
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

func is_room_ud(_directions: String) -> bool:
	_directions = _directions.get_slice(".", 0)
	
	return (_directions.length() == 2 && _directions[0] == "U" && _directions[1] == "D")
