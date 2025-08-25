extends Node

const GENERATED_RESOURCES := "user://generated_resources/"

const TILE_SIZE := 32
const ROOM_SIZE := 32
const ROOM_SIZE_IN_PIXELS := TILE_SIZE * ROOM_SIZE * 15
const ROOM_WIDTH := ROOM_SIZE_IN_PIXELS
const ROOM_HEIGHT := ROOM_SIZE_IN_PIXELS
const WIDTH := roundi(ROOM_WIDTH / TILE_SIZE)
const HEIGHT := roundi(ROOM_HEIGHT / TILE_SIZE)
var MAP_NODES := LoadMapNodes.load_map_nodes()
const START_X = ROOM_WIDTH / 2
const START_Y = ROOM_HEIGHT / 4
const START_POS = Vector2(START_X, START_Y)

func get_gamepad_device() -> int:
	var gamepads = Input.get_connected_joypads()
	
	if (gamepads.size() > 0):
		return gamepads[0]
	else:
		return 0

func _ready() -> void:
	if ("--server" in OS.get_cmdline_args()):
		NetworkHandler.start_server()
	else:
		NetworkHandler.start_client()

func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_pressed("restart")):
		get_tree().reload_current_scene()
	
