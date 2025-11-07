extends Node

var data: Dictionary

func _init() -> void:
	data = get_all_in_file_path("res://items/", {})

func get_item(name: String) -> Item:
	return data.get(name)

func get_all_in_file_path(path: String, file_paths) -> Dictionary:
	var dir = DirAccess.open(path)
	dir.list_dir_begin()  
	
	var file_name = dir.get_next()  
	while file_name != "":  
		var file_path = path + "/" + file_name  
		if dir.current_is_dir():  
			file_paths.assign(get_all_in_file_path(file_path, file_paths))
		else: 
			if (file_path.ends_with(".tres")):
				var item: Item = load(file_path)
				file_paths.set(item.name, item)
			
		file_name = dir.get_next()  

	return file_paths
