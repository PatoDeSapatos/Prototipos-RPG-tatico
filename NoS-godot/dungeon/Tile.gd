class_name TempTile extends Object

var spr: int
var coll: bool
var stack: Array
var stack_instances = []
var z := 0

func _init(spr: int, coll: bool, stack := [], z := 0):
	self.spr = spr;
	self.coll = coll;
	self.stack = stack;
	self.z = z

func get_stack_item():
	return stack.pop_front()

func collide():
	pass

func get_stack_instance():
	return stack_instances[0]
