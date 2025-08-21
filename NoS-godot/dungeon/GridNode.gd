class_name GridNode extends Object

var image: Image
var identifier: String
var direction: String
var args: String

func _init(image: Image, data: Dictionary[String, String] = {}):
	self.image = image
	if (data.is_empty() && !image.resource_name.is_empty()):
		set_from_data(data_from_filename(image.resource_name))
	else:
		set_from_data(data)

func set_from_data(data: Dictionary[String, String]):
	self.identifier = data["identifier"]
	self.direction = data["direction"]
	self.args = data["args"]

func get_filename() -> String:
	return identifier + direction + args + ".png"

static func data_from_filename(filename: String) -> Dictionary[String, String]:
	var name_splited := filename.split("_")
	var room_identifier := name_splited[0] + "_" + name_splited[1] + "_";
	var room_directions := name_splited[2]
	var room_args := "_".join(name_splited.slice(3))
	room_args = "" if room_args.is_empty() else "_" + room_args
	
	return {
		"identifier": room_identifier,
		"direction": room_directions,
		"args": room_args
	}
