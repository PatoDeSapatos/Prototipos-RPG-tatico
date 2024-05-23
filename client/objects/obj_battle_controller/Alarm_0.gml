/// @desc Awaiting State
request_get_game_state();

if (state == state_waiting || state_choosing) {
	alarm[0] = waiting_time;	
}