package com.patodesapatos.dungeons.domain.dungeon;

import java.util.ArrayList;

import org.json.JSONObject;

import com.patodesapatos.dungeons.controller.MessageType;
import com.patodesapatos.dungeons.domain.WebSocketDTO;

public class DungeonDTO extends WebSocketDTO {

    public DungeonDTO(Dungeon dungeon) {
        super(MessageType.DUNGEON_STATE);

        var data = new JSONObject();

        var parsedEntities = new ArrayList<Entity>();
        for (int i = 0; i < dungeon.getEntities().size(); i++) {
            var entity = dungeon.getEntities().get(i);
            var player = dungeon.getPlayerByUsername(entity.getUsername());
            if (player != null) {
                if (player.isOnline()) parsedEntities.add(entity.toDTO());
            }
        }

        data.put("entities", parsedEntities);
        packet.put("data", data);
    }
}
