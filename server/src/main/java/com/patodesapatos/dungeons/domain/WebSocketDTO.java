package com.patodesapatos.dungeons.domain;

import org.json.JSONObject;

import com.patodesapatos.dungeons.controller.MessageType;

public abstract class WebSocketDTO {
    protected JSONObject packet = new JSONObject();

    public WebSocketDTO(MessageType type) {
        packet.put("messageType", type);
    }

    @Override
    public String toString() {
        return packet.toString();
    }
}