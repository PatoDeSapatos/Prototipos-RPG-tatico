package com.patodesapatos.dungeons.controller.websocket;

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
import com.patodesapatos.dungeons.domain.user.UserService;
import com.patodesapatos.dungeons.controller.MessageType;
import com.patodesapatos.dungeons.domain.WebSocketDTO;
import com.patodesapatos.dungeons.domain.auth.TokenService;
import com.patodesapatos.dungeons.domain.chat.ChatMessage;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
public class WebSocketController extends TextWebSocketHandler {
    @Autowired
    private TokenService tokenService;
    @Autowired
    public DungeonService dungeonService;
    @Autowired
    private UserService userService;
    private Map<String, WebSocketSession> activeSessions = new HashMap<>();

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        var jsonString = message.getPayload();
        var packet = new JSONObject(jsonString);

        var type = MessageType.valueOf(packet.getString("messageType"));
        var data = packet.getJSONObject("data");
        var isBattle = packet.has("isBattle") && packet.getBoolean("isBattle");

        var username = (String) session.getAttributes().get("username");
        if (username == null || username.isEmpty()) return;

        if (!isBattle) {
            DungeonWSHandler.handle(this, session, username, type, data);
        } else {
            BattleWSHandler.handle(this, session, username, type, data);
        }
    }

    public void sendDTO(WebSocketDTO dto, WebSocketSession session) throws Exception {
        if (dto == null) return;
        session.sendMessage(new TextMessage(dto.toString()));
    }

    public void sendDTOtoAllPlayers(WebSocketDTO dto, JSONObject data, String excludedSessionId) throws Exception {
        if (dto == null) return;
        var dungeon = dungeonService.getDungeonByInvite(data.getString("invite"));
        if (dungeon == null) return;

        for (int i = 0; i < dungeon.getPlayers().size(); i++) {
            String sessionId = userService.getUserById(dungeon.getPlayers().get(i).getUserId()).getSessionId();
            if (sessionId.isEmpty() || sessionId.equals(excludedSessionId)) continue;

            sendDTO(dto, activeSessions.get(sessionId));
        }
    }

    public void sendDTOtoAllPlayers(WebSocketDTO dto, JSONObject data) throws Exception {
        sendDTOtoAllPlayers(dto, data, null);
    }

    public void sendChat(JSONObject data) throws Exception {
        ChatMessage message = new ChatMessage(data);
        sendDTOtoAllPlayers(message, data);
    }

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {

        var token = session.getUri().getPath().replace("/ws/", "");
        var username = tokenService.validateToken(token);
        if (username == "") {
            session.close(CloseStatus.BAD_DATA.withReason("Invalid auth token."));
            return;
        }

        session.getAttributes().put("username", username);
        activeSessions.put(session.getId(), session);
        log.info("User connected: {} ({})", username, session.getId());
        super.afterConnectionEstablished(session);
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        String sessionId = session.getId();

        if (status.getReason() == null) {
            log.info("User disconnected: {}", sessionId);
        } else {
            log.info("User disconnected: {} ({})", status.getReason(), sessionId);
        }

        activeSessions.remove(sessionId);
        dungeonService.leaveDungeon(session);
        super.afterConnectionClosed(session, status);
    }
}