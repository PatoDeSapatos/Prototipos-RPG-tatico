extends GridMap

var player: CharacterBody3D
var camera: Camera3D

func _ready() -> void:
	var p = get_tree().get_first_node_in_group("player")
	if p is CharacterBody3D: player = p
	camera = get_viewport().get_camera_3d()

func _process(delta: float) -> void:
	if player && camera:
		var camera_forward = camera.global_transform.basis.z
		var screen_pos = camera.unproject_position(player.global_position + Vector3.UP * 1.25)
		var viewport_size = get_viewport().get_visible_rect().size
		var screen_uv = screen_pos / viewport_size
		
		RenderingServer.global_shader_parameter_set("player_screen_pos", screen_uv)
		RenderingServer.global_shader_parameter_set("player_position", player.global_position)
		RenderingServer.global_shader_parameter_set("camera_forward", camera_forward)
