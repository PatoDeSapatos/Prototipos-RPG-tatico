class_name PacketInfo

enum PACKET_TYPE {
	USER_INFO
}

var packet_type: PACKET_TYPE
var flag: int

func _init(packet_type: PACKET_TYPE, flag: int) -> void:
	self.packet_type = packet_type
	self.flag = flag

func encode() -> PackedByteArray:
	var data: PackedByteArray
	data.resize(1)
	data.append(packet_type)
	data.compress()
	return data

func decode(data: PackedByteArray):
	packet_type = data.decode_u8(0)

func send(receiver_id: int):
	var error = NetworkHandler.multiplayer.send_bytes(encode(), receiver_id, flag)
	if (error):
		print("Error while sending packet: ", error_string(error))

func broadcast():
	var error = NetworkHandler.multiplayer.send_bytes(encode(), 0, flag)
	if (error):
		print("Error while sending packet: ", error_string(error))
