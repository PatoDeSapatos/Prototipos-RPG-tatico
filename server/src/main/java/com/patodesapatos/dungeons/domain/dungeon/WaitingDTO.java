package com.patodesapatos.dungeons.domain.dungeon;

import java.util.ArrayList;

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

        var parsedPlayers = new ArrayList<Player>();
        for (int i = 0; i < dungeon.getPlayers().size(); i++) {
            parsedPlayers.add(dungeon.getPlayers().get(i).toDTO());
        }

        data.put("players", parsedPlayers);
        data.put("adm", dungeon.getAdmUsername());
        data.put("invite", dungeon.getInvite());
        data.put("started", dungeon.isStarted());
        data.put("isPublic", dungeon.isPublic());

        packet.put("data", data);
    }
}
