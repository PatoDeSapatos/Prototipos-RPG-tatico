package com.patodesapatos.dungeons.controller;

import java.util.HashMap;
import java.util.Map;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.patodesapatos.dungeons.domain.dungeon.Dungeon;
import com.patodesapatos.dungeons.domain.dungeon.DungeonService;
import com.patodesapatos.dungeons.domain.user.UserService;
import com.patodesapatos.dungeons.domain.WebSocketDTO;
import com.patodesapatos.dungeons.domain.auth.TokenService;
import com.patodesapatos.dungeons.domain.chat.ChatMessage;
import com.patodesapatos.dungeons.domain.chat.ChatType;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
public class WebSocketController extends TextWebSocketHandler {
    @Autowired
    private TokenService tokenService;
    @Autowired
    private DungeonService dungeonService;
    @Autowired
    private UserService userService;
    private Map<String, WebSocketSession> activeSessions = new HashMap<>();

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        String jsonString = message.getPayload();
        JSONObject packet = new JSONObject(jsonString);
        
        MessageType type = MessageType.valueOf(packet.getString("messageType"));
        String token = packet.getString("token");
        JSONObject data = packet.getJSONObject("data");

        var username = tokenService.validateToken(token);
        if (username.isEmpty()) return;

        WebSocketDTO dto;
        switch (type) {
            case PING:
                session.sendMessage(new TextMessage("Pong!"));
                break;
            case CREATE_DUNGEON:
                dto = dungeonService.createDungeon(data.getBoolean("isPublic"), username, session.getId());
                sendDTO(dto, session);
                break;
            case JOIN_DUNGEON:
                dto = dungeonService.joinDungeon(data.getString("dungeonInvite"), username, session.getId());
                sendDTO(dto, session);
                break;
            case DUNGEON_STATE:
                dto = dungeonService.getDungeonById(data.getString("id")).toDTO();
                sendDTO(dto, session);
            case UPDATE_ENTITY:
                dto = dungeonService.updateEntity(data);
                sendDTO(dto, session);
                break;
            case SEND_CHAT_MESSAGE:
                sendChat(data);
                break;
            default:
                throw new Exception("Message Type: '" + type + "' not accepted!");
        }
    }

    public void sendDTO(WebSocketDTO dto, WebSocketSession session) throws Exception {
        session.sendMessage(new TextMessage(dto.toString()));
    }

    public void sendChat(JSONObject data) throws Exception {
        String dungeonId = data.getString("dungeonId");
        String sender = data.getString("sender");
        String content = data.getString("content");
        ChatType type = ChatType.valueOf( data.getString("type") );

        ChatMessage message = new ChatMessage(sender, content, type);
        Dungeon dungeon = dungeonService.getDungeonById(dungeonId);

        for (int i = 0; i < dungeon.getUsersId().size(); i++) {
            String sessionId = userService.getUserById( dungeon.getUsersId().get(i) ).getSessionId();
            if ( sessionId.isEmpty() ) continue;

            sendDTO(message, activeSessions.get(sessionId));
        }
    }

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        activeSessions.put(session.getId(), session);
        log.info("User Connected: {}", session.getId());
        super.afterConnectionEstablished(session);
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        String sessionId = session.getId();
        log.info("User Disconnected: {}", sessionId);
        activeSessions.remove(sessionId);
        super.afterConnectionClosed(session, status);
    }
}