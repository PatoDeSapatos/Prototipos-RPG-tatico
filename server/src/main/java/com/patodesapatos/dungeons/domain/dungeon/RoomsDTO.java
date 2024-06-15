package com.patodesapatos.dungeons.domain.dungeon;

import org.json.JSONObject;

import com.patodesapatos.dungeons.controller.MessageType;
import com.patodesapatos.dungeons.domain.WebSocketDTO;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class RoomsDTO extends WebSocketDTO {

    public RoomsDTO(JSONObject data) {
        super(MessageType.DUNGEON_ROOMS_SHARE);

        packet.put("data", data.getJSONArray("data"));
    }
}