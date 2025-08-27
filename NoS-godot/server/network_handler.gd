extends Node

var peer := ENetMultiplayerPeer.new()
var username = "demo":
	set(value):
		username = value
		userinfo["username"] = value

var is_connection_on: bool = false
var is_dedicated_server: bool

var peer_id: int
var players := {}

var userinfo = {
	"username": "demo",
}

signal player_connected(player_id: int, player_info: Dictionary)

func _ready() -> void:
	peer.peer_connected.connect(_on_peer_connected)
	peer.peer_disconnected.connect(_on_peer_disconected)
	multiplayer.peer_packet.connect(_handle_packets)

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
		multiplayer.multiplayer_peer = peer
		peer_id = peer.get_unique_id()
	
	print("Server started!")
	is_connection_on = true

func start_client(ip:="127.0.0.1", port:=8910):
	var error := peer.create_client(ip, port)
	if (error):
		print("Error while creating a client: ", error_string(error))
		return
	
	multiplayer.multiplayer_peer = peer
	peer_id = peer.get_unique_id()
	is_connection_on = true

## Register a new Player given his player info. [br]
## All inner custom objects of player info must be a serializable object in the form of a dictionary.
@rpc("any_peer", "call_local", "reliable")
func register_player(new_player_info: Dictionary):
	var id = multiplayer.get_remote_sender_id()
	
	for key in new_player_info:
		var player_info = new_player_info[key]
		
		if (player_info is EncodedObjectAsID):
			new_player_info[key] = instance_from_id(player_info.get_instance_id())
		
		var error = JSON.new().parse(player_info)
		if (error == OK):
			new_player_info[key] = Serializable.from_json(player_info)
	
	players[id] = new_player_info
	player_connected.emit(id, new_player_info)

func _handle_packets(id: int, packet: PackedByteArray):
	var type = packet.decode_u8(0)
	match type:
		PacketInfo.PACKET_TYPE.USER_INFO:
			var data = UserInfo.new(0, Dictionary())
			data.decode(packet)
			
