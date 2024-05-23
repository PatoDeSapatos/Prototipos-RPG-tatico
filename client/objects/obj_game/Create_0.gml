/// @description Insert description here
url = "http://localhost:8080";

global.playerId = 0;
global.battleId = 0;
global.loading = false;

global.player_exists = -1;
global.battle_exists = -1;

setup_requests();
room_goto_next();