class_name GridNode extends Object

var image: Image
var identifier: String
var direction: String
var args: Array
var spawn := -1

static var EMPTY := GridNode.new(null, {
	"identifier": "",
	"direction": "",
	"args": []
})

func _init(image: Image, data: Dictionary[String, Variant] = {}):
	self.image = image
	if (data.is_empty() && !image.resource_name.is_empty()):
		set_from_data(data_from_filename(image.resource_name))
	else:
		set_from_data(data)

func set_from_data(data: Dictionary[String, Variant]):
	self.identifier = data["identifier"]
	self.direction = data["direction"]
	self.args = data["args"]

func get_filename() -> String:
	return identifier + direction + ("_" if args.size() > 0 else "") + "_".join(args) + ".png"

func duplicate() -> GridNode:
	var clone = GridNode.new(self.image, {
		"identifier": self.identifier,
		"direction": self.direction,
		"args": self.args.duplicate()
	})
	return clone

static func data_from_filename(filename: String) -> Dictionary[String, Variant]:
	var name_splited := filename.get_slice(".", 0).split("_")
	var room_identifier := name_splited[0] + "_" + name_splited[1] + "_";
	var room_directions := name_splited[2]
	var room_args := name_splited.slice(3)
	
	return {
		"identifier": room_identifier,
		"direction": room_directions,
		"args": room_args
	}
