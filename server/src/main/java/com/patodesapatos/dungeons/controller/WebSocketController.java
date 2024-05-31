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

import com.patodesapatos.dungeons.domain.dungeon.DungeonService;
import com.patodesapatos.dungeons.domain.auth.TokenService;

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

    private Map<String, WebSocketSession> activeSessions = new HashMap<>();
    
    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        String jsonString = message.getPayload();
        JSONObject packet = new JSONObject(jsonString);
        
        MessageType type = MessageType.valueOf(packet.getString("type"));
        String token = packet.getString("token");
        JSONObject data = packet.getJSONObject("data");

        if (tokenService.validateToken(token) == "") return;

        switch (type) {
            case PING:
                session.sendMessage(new TextMessage("Pong!"));
                break;
            case CREATE_DUNGEON:
                
                break;
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