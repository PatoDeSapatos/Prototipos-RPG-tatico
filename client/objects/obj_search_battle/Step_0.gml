/// @description Insert description here
if ( player_username != "" && !send_username ) {
	send_username = true;
	request_post_new_player(player_username);	
} else if ( player_username == "" ) {
	player_username = get_string("Username: ", "");	
}