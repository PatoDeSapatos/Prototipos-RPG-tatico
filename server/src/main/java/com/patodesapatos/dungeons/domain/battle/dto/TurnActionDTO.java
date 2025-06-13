package com.patodesapatos.dungeons.domain.battle.dto;

import org.json.JSONArray;

import com.patodesapatos.dungeons.controller.MessageType;
import com.patodesapatos.dungeons.domain.WebSocketDTO;

public class TurnActionDTO extends WebSocketDTO {
    
    public TurnActionDTO(int battleId, JSONArray actions) {
        super(MessageType.TURN_ACTION);
        
        var data = getData();
        data.put("battleId", battleId);
        data.put("actions", actions);
    }
}
