switch(async_load[?"type"]){
	case network_type_non_blocking_connect:
		//code that executes when we have connected
		//tell the server to create a player for us

		show_debug_message("conectou")
		var Buffer = buffer_create(1, buffer_grow ,1);
		var data = ds_map_create();
		//ASK THE SERVER TO CREATE A PLAYER FOR US
		buffer_write(Buffer , buffer_text  , json_encode(data));

		network_send_raw(socket , Buffer , buffer_tell(Buffer));
		ds_map_destroy(data);
		break;
	case network_type_data:
		var buffer_raw = async_load[? "buffer"];
		var buffer_processed = buffer_read(buffer_raw , buffer_text);
		var realData = json_decode(buffer_processed);
		var eventName = realData[?"eventName"];
		show_debug_message(buffer_processed)
		switch(eventName){
			case "created_you":
				//DO SOMETHING
				break;		
		}	
		break;
}