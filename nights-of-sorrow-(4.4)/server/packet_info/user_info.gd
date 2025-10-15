class_name UserInfo extends PacketInfo

var id: int
var userinfo: Dictionary

func _init(id: int, userinfo: Dictionary) -> void:
	self.id = id
	self.userinfo = userinfo
	super(PACKET_TYPE.USER_INFO, MultiplayerPeer.TRANSFER_MODE_RELIABLE)

func encode() -> PackedByteArray:
	var data = super()
	data.append(id)
	
	var packed_userinfo = str(self.userinfo).to_utf8_buffer()
	for info in packed_userinfo:
		data.append(info)
	
	data.compress()
	return data

func decode(data: PackedByteArray):
	super(data)
	self.id = data.decode_u8(1)
	
	var userinfo: PackedByteArray
	for i in range(2, data.size()):
		userinfo.append(data.decode_u8(i))
	
	self.userinfo = JSON.parse_string(userinfo.get_string_from_utf8())

func _to_string() -> String:
	return str("ID: ", id) + str("; Userinfo: ", userinfo)
