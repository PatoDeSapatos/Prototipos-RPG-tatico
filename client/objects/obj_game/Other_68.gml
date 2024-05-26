switch(async_load[?"type"]){
	case network_type_non_blocking_connect:
		break;
	case network_type_data:
		var buffer_raw = async_load[? "buffer"];
		var buffer_processed = buffer_read(buffer_raw , buffer_text);
		var realData = json_decode(buffer_processed);
		if ( instance_exists(obj_battle_controller) ) obj_battle_controller.update_game_state( realData );
		break;
	case network_type_disconnect:
		game_restart();
		break;
}