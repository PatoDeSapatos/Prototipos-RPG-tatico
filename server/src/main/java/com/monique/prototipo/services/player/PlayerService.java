package com.monique.prototipo.services.player;

import com.monique.prototipo.domain.player.PlayerModel;

public class PlayerService { 

    public static PlayerModel playerModel = PlayerModel.instance;

    public PlayerService() {
        // savePlayer("Felipe");
        // savePlayer("Monique");
    }

    public void setPlayerOnline(int playerId, String sessionId) {
        playerModel.getPlayerById(playerId).setSessionId(sessionId);
    }

	public void disconnectPlayer(String sessionId) {

	}
}