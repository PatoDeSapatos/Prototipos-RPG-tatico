package com.monique.prototipo.services.battle;

import org.json.JSONObject;

import lombok.Getter;

@Getter
public class AddPlayerInBattleRequest {
    private int battleId;
    private int playerId;

    public AddPlayerInBattleRequest(JSONObject data) {
        battleId = data.getInt("battleId");
    }
}