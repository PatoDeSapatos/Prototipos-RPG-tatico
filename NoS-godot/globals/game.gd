extends Node

const TILE_SIZE := 32

func get_gamepad_device() -> int:
	var gamepads = Input.get_connected_joypads()
	
	if (gamepads.size() > 0):
		return gamepads[0]
	else:
		return 0

func _ready() -> void:
	if ("--server" in OS.get_cmdline_args()):
		NetworkHandler.start_server()

func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_pressed("restart")):
		get_tree().reload_current_scene()
