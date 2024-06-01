package com.patodesapatos.dungeons.domain.dungeon;

import org.json.JSONObject;

import com.patodesapatos.dungeons.controller.MessageType;
import com.patodesapatos.dungeons.domain.WebSocketDTO;

public class DungeonDTO extends WebSocketDTO {

    public DungeonDTO(Dungeon dungeon) {
        super(MessageType.DUNGEON_STATE);

        var data = new JSONObject();
        data.put("entities", dungeon.getEntities());

        packet.put("data", data);
    }
}
