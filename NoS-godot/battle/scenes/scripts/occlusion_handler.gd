extends Node

const MAX_RADIUS: float = 0.3

var occlusion_objecs: Array[Node]
var tween: Tween = null

func set_radius(value: float):
	RenderingServer.global_shader_parameter_set("radius", value)

func add_object(obj: Node):
	if (occlusion_objecs.count(obj) <= 0):
		occlusion_objecs.append(obj)
	
	RenderingServer.global_shader_parameter_set("occlusion_active", true)
	if (tween):
		tween.kill()
	
	tween = get_tree().create_tween()
	tween.tween_method(set_radius, 0.0, MAX_RADIUS, 0.2)
	

func remove_object(obj: Node):
	occlusion_objecs.remove_at(occlusion_objecs.find(obj))
	if (occlusion_objecs.size() <= 0):
		if (tween):
			tween.kill()
		
		tween = get_tree().create_tween()
		tween.tween_method(set_radius, MAX_RADIUS, 0.0, 0.2)
		tween.finished.connect(func(): 
			RenderingServer.global_shader_parameter_set("occlusion_active", false)
			)
		
