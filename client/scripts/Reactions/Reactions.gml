function create_guest_reaction() {
	var _res = json_parse( async_load[? "result"] );
	global.server.username = struct_get(_res, "username");
	global.user_token = struct_get(_res, "token");
	global.server.guest_password = struct_get(_res, "password");
	global.server.user_logged = true;
	global.server.is_user_guest = true;
}