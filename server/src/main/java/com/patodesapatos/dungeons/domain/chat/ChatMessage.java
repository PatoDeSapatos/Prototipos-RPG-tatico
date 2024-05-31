package com.patodesapatos.dungeons.domain.chat;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class ChatMessage {
    private String sender;
    private String content;    
    private MessageType type;
}