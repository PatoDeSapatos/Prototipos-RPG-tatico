package com.patodesapatos.dungeons.domain.battle.dto;

import com.patodesapatos.dungeons.controller.MessageType;
import com.patodesapatos.dungeons.domain.WebSocketDTO;

public class UnitReadyDTO extends WebSocketDTO {
    
    public UnitReadyDTO(int battleId, int unitId) {
        super(MessageType.UNIT_READY);

        var data = getData();
        data.put("battleId", battleId);
        data.put("unitId", unitId);
    }
}
