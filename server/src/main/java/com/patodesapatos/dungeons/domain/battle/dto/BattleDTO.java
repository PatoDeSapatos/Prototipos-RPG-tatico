package com.patodesapatos.dungeons.domain.battle.dto;

import org.json.JSONArray;

import com.patodesapatos.dungeons.controller.MessageType;
import com.patodesapatos.dungeons.domain.WebSocketDTO;
import com.patodesapatos.dungeons.domain.battle.Battle;

public class BattleDTO extends WebSocketDTO {

    public BattleDTO(Battle battle) {
        super(MessageType.BATTLE_STATE);

        var data = getData();
        data.put("id", battle.getId());
        data.put("units", new JSONArray(battle.getUnits().values()));
        data.put("eUnits", new JSONArray(battle.getEUnits().values()));
    }
}
