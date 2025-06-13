package com.patodesapatos.dungeons.domain.battle.dto;

import org.json.JSONArray;

import com.patodesapatos.dungeons.controller.MessageType;
import com.patodesapatos.dungeons.domain.WebSocketDTO;
import com.patodesapatos.dungeons.domain.battle.Battle;

public class BattleStartDTO extends WebSocketDTO {

    public BattleStartDTO(Battle battle) {
        super(MessageType.BATTLE_START);

        var data = getData();
        data.put("id", battle.getId());
        data.put("room", battle.getRoom());
        data.put("units", new JSONArray(battle.getUnits().values()));
        data.put("eUnits", new JSONArray(battle.getEUnits().values()));
    }
}
