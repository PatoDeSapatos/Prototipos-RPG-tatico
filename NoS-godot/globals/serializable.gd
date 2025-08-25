class_name Serializable
extends Resource

# Serializable classes cannot have a constructor as an empty one is needed. Resort to static
# create function for easier object creation.

# Convert instance to a dictionary.
func to_dict() -> Dictionary:
	var result = {
		"_type": get_script().get_path()  # This is a reference to the class/script type.
	}
	
	for property in self.get_property_list():
		if property.usage & PROPERTY_USAGE_SCRIPT_VARIABLE:
			if property.type == Variant.Type.TYPE_OBJECT:
				var object = get(property.name)
				if object is Serializable:
					result[property.name] = object.to_dict()
			elif property.type == Variant.Type.TYPE_DICTIONARY:
				var dict = get(property.name)
				var dict_result = _convert_dictionary(dict)
				
				result[property.name] = dict_result
			elif property.type == Variant.Type.TYPE_ARRAY:
				var array = get(property.name)
				
				result[property.name] = _convert_array(array)
			else:
				result[property.name] = get(property.name)
	
	return result

# Array of dictionaries is not supported, use a Serializable object instead.
func _convert_array(array: Array):
	var result_array = []
	for i in array:
		if i is Serializable:
			result_array.append(i.to_dict())
		else:
			result_array.append(i)
			
	return result_array
		
func _convert_dictionary(dict: Dictionary):
	var dict_result = {}
	for k in dict.keys():
		var value = dict[k]
		if value is Dictionary:
			dict_result[k] = _convert_dictionary(value)
		elif value is Array:
			dict_result[k] = _convert_array(value)
		elif value is Serializable:
			dict_result[k] = value.to_dict()
		else:
			dict_result[k] = value
			
	return dict_result

func to_json() -> String:
	var dict = to_dict()
	return JSON.stringify(dict)

# Populate the instance from a dictionary.
# Arrays included cannot be typed in their definition due to limitations with GDScript
# e.g: if you have an Array[CustomClass] you should change only its definition to be just Array
static func from_dict(data: Dictionary):
	var instance
	if data.has("_type"):
		instance = load(data["_type"]).new()
	else:
		instance = {}
	
	for key in data.keys():
		if key != "_type":
			var value = data[key]
			if value is Dictionary:
				var dict = from_dict(value)
				set_value(instance, key, dict)
			elif value is Array:
				var result_array = []
				for e in value:
					if e is Dictionary:
						var dict = from_dict(e)
						result_array.append(dict)
					else:
						result_array.append(e)
				set_value(instance, key, result_array)
			else:
				set_value(instance, key, data[key])
	
	return instance
	
static func set_value(object, key, value):
	if object is Dictionary:
		object[key] = value
	else:
		object.set(key, value)
	
static func from_json(json_string: String):
	var json = JSON.new()

	var parse_result = json.parse(json_string)
	if not parse_result == OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return null
		
	var dict = from_dict(json.data)
	
	return dict
