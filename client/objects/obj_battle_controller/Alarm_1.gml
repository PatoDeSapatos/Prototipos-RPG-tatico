/// @description Player Ready State
request_post_player_ready();
request_get_game_state();
if (state == state_ready) {
	alarm[1] = waiting_time;	
}