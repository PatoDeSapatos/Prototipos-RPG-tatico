package com.patodesapatos.dungeons.domain.chat;

import org.json.JSONObject;

import com.patodesapatos.dungeons.controller.MessageType;
import com.patodesapatos.dungeons.domain.WebSocketDTO;

public class ChatMessage extends WebSocketDTO {

    public ChatMessage(String sender, String content, ChatType type) {
        super(MessageType.SEND_CHAT_MESSAGE);

        JSONObject data = new JSONObject();
        data.put("sender", sender);
        data.put("content", content);
        data.put("type", type);

        packet.put("data", data);
    }
}