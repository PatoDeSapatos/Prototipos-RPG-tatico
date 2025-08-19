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

func load_map_images():
	var gen_dir := init_dir()
	var images: Array[Image] = []
	
	var dir = DirAccess.open("res://resources/rooms/")
	dir.list_dir_begin()
	while true:
		var file_name = dir.get_next()
		if file_name == "":
			break
		var image: Image = load("res://resources/rooms/" + file_name)
		images.append_array(rotate_image(image, file_name))
	dir.list_dir_end()
	
	for i in images:
		i.save_png(Game.GENERATED_RESOURCES + i.resource_name)

func rotate_image(_image: Image, _image_name: String) -> Array[Image]:
	var _name_splited := _image_name.split("_")
	var _room_identifier := _name_splited[0] + "_" + _name_splited[1] + "_";
	var _room_directions := _name_splited[2]
	
	var cycles := 1 if is_room_ud(_room_directions) else 3
	for i in cycles:
		if (_rotated_name == "" || file_exists(_new_file_name)):
			continue;

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
