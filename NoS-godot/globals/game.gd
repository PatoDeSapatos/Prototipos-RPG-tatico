extends Node

const GENERATED_RESOURCES := "user://generated_resources/rooms/"

const TILE_SIZE := 32
const ROOM_SIZE := 32
const ROOM_SIZE_IN_PIXELS = TILE_SIZE * ROOM_SIZE * 15
const ROOM_WIDTH = ROOM_SIZE_IN_PIXELS
const ROOM_HEIGHT = ROOM_SIZE_IN_PIXELS
const WIDTH = roundi(ROOM_WIDTH / TILE_SIZE)
const HEIGHT = roundi(ROOM_HEIGHT / TILE_SIZE)
