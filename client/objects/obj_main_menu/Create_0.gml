// Menu parameters
setup = true;
page = 0;
option_selected = 0;

width = -1;
height = -1;
start_x = 0;
start_y = 0;
offset = 10;
reading_string = "";
max_string_length = 0;

input_up = -1;
input_down = -1;
input_forward = -1;
input_back = -1;

// Options per page
function setup_options( _page ) {
	switch (_page) {
		case 0:
			options[0] = ["Enter in Dungeon", "Create Dungeon", global.server.user_logged ? ("Account") : ("Login"), "Options", "Exit"];
			break;
		case 1:
			options[1] = ["Public Dungeons", "Enter With Code", "Back"];
			break;
		case 2:
			options[2] = ["Create Dungeon"];
			break;
		case 3: // Account
			if ( global.server.user_logged ) {
				options[3, 0] = global.server.user_username;
				options[3, 1] = "Edit Account";
				options[3, 2] = "Logout";
				options[3, 3] = "Back"
			} else {
				options[3] = ""; 	
			}
			break;
		case 4:
			options[4] = ["Options"];
			break;
		case 5: // Login
			options[5] = ["Username:", "", "Send", "Cancel"];
			break;
		case 6:
			options[6] = [];
			break;
		case 7: // Enter Public Dungeon
			options[7] = ["Dungeon Code:", "", "Enter", "Cancel"];
			break;
	}
}
setup_options(0);

function menu_change_page( _page ) {
	option_selected = 0;
	page = _page;
	setup = true;
	setup_options(_page);
}