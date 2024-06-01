package com.patodesapatos.dungeons.domain.dungeon;

import org.json.JSONObject;

import com.patodesapatos.dungeons.controller.MessageType;
import com.patodesapatos.dungeons.domain.WebSocketDTO;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class WaitingDTO extends WebSocketDTO {

    public WaitingDTO(Dungeon dungeon) {
        super(MessageType.WAITING);

        var data = new JSONObject();
        data.put("usersId", dungeon.getUsersId());
        data.put("dungeonInvite", dungeon.getDungeonInvite());
        data.put("waiting", dungeon.isWaiting());

        packet.put("data", data);
    }
}
