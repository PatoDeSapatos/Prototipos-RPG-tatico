extends Node

var peer := ENetMultiplayerPeer.new()
var username = "demo"
var connected_peers: Dictionary[int, ENetMultiplayerPeer]

var is_connection_on: bool
var is_dedicated_server: bool

var userinfo = {
	"username": "",

}

func _ready() -> void:
	peer.peer_connected.connect(_on_peer_connected)
	peer.peer_disconnected.connect(_on_peer_disconected)

func _on_peer_connected(id):
	print("Peer connected with id: ", id)
	
func _on_peer_disconected(id):
	print("Peer disconnected with id: ", id)

func _process(delta: float) -> void:
	if (is_connection_on):
		peer.poll()

func start_server(port: int = 8910):
	if (OS.has_feature("dedicated_server")):
		is_dedicated_server = true
	
	var error = peer.create_server(port)
	if (error):
		print("Error while creating server: ", error_string(error))
		return
	
	if (!is_dedicated_server):
		var id = peer.get_unique_id()
		connected_peers[id] = peer
		multiplayer.multiplayer_peer = peer
	
	is_connection_on = true

func start_client(ip:="127.0.0.1", port:=8910):
	var error := peer.create_client(ip, port)
	if (error):
		print("Error while creating a client: ", error_string(error))
		return
	
	is_connection_on = true
