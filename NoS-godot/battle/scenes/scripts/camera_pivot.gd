extends Node3D

@export var camera_sensibility: float = 0.004
@export var min_zoom: int = 8
@export var max_zoom: int = 40
@export var target: Node3D
@export var occlusion_collider_offset: Vector3 = Vector3.ZERO

@onready var camera_3d: Camera3D = $Camera3D

@onready var area: Area3D = $Occlusion
@onready var area_coll: CollisionShape3D = $Occlusion/CollisionShape3D

func _input(event: InputEvent) -> void:
	#if (event is InputEventMouseMotion && Input.is_action_pressed("rotate_camera")):
		#rotation.y -= event.relative.x * camera_sensibility
	_camera_zoom()

func _camera_zoom():
	var zoom_change = 0
	if (Input.is_action_pressed("mouse_wheel_up")):
		zoom_change -= 1
	if (Input.is_action_pressed("mouse_wheel_down")):
		zoom_change += 1
	
	camera_3d.size = clamp(camera_3d.size + zoom_change, min_zoom, max_zoom)

func _physics_process(delta: float) -> void:
	if (target):
		var dir = Vector2.ZERO
		dir.x = target.global_position.x
		dir.y = target.global_position.z
		
		target.rotation.x = rotation.x
		target.rotation.y = rotation.y
		global_position = Vector3(dir.x, global_position.y, dir.y)
		
		var pos = Vector3(target.global_position.x, target.global_position.y, target.global_position.z)
		#var size = pos.distance_to(camera_3d.global_position)
		#var coll_dir = Vector3.BACK
		#area_coll.shape.size = Vector3()
		area.global_position = pos + Vector3(
			area_coll.shape.size.x/2,
			0,
			area_coll.shape.size.z/2
		)
		

func _get_body_shader_material(body: PhysicsBody3D) -> ShaderMaterial:
	var meshes = body.get_children().filter(func(node: Node): 
		return node is MeshInstance3D
		)
	
	if (body.get_parent() is MeshInstance3D):
		meshes.append(body.get_parent())
	
	if (meshes.size() <= 0): 
		return null
	
	var mesh: MeshInstance3D = meshes[0]
	if (mesh.get_active_material(0) is ShaderMaterial):
		return mesh.get_active_material(0)
	
	return null

func _on_area_3d_body_entered(body: Node3D) -> void:
	if (body.is_in_group("occlusion")):
		if (body is StaticBody3D):
			var material: ShaderMaterial = _get_body_shader_material(body)
			if (material):
				material.set_shader_parameter("screen_space_texture", preload("uid://b4s0x77wqe264"))
				OcclusionHandler.add_object(body)
		elif (body is GridMap):
				OcclusionHandler.add_object(body)

func _on_area_3d_body_exited(body: Node3D) -> void:
	if (body.is_in_group("occlusion")):
		if (body is StaticBody3D):
			var material: ShaderMaterial = _get_body_shader_material(body)
			if (material):
				OcclusionHandler.remove_object(body)
		elif (body is GridMap):
			OcclusionHandler.remove_object(body)
