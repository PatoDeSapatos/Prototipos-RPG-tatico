package com.patodesapatos.dungeons.domain.chat;

import org.json.JSONObject;

import com.patodesapatos.dungeons.controller.MessageType;
import com.patodesapatos.dungeons.domain.WebSocketDTO;

public class ChatMessage extends WebSocketDTO {

    public ChatMessage(JSONObject data) {
        super(MessageType.SEND_CHAT_MESSAGE);

        var parsedData = new JSONObject(data.toString());
        parsedData.remove("invite");

        packet.put("data", parsedData);
    }
}