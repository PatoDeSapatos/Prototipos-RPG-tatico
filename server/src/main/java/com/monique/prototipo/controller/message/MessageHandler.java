package com.monique.prototipo.controller.message;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.monique.prototipo.domain.battle.BattleStateDTO;
import com.monique.prototipo.domain.player.Player;
import com.monique.prototipo.exceptions.InvalidRequestException;
import com.monique.prototipo.services.battle.AddPlayerInBattleRequest;
import com.monique.prototipo.services.battle.BattleService;
import com.monique.prototipo.services.battle.TurnActionRequest;
import com.monique.prototipo.services.player.PlayerService;

import org.json.*;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Component
@RequiredArgsConstructor
@Slf4j
public class MessageHandler extends TextWebSocketHandler {

    private Map<String, WebSocketSession> activeSessions = new HashMap<>();

    private PlayerService playerService = new PlayerService();

    private BattleService battleService = new BattleService();

    @Override 
    public void handleMessage(WebSocketSession session, WebSocketMessage<?> message) throws Exception {
        String jsonString;
        try {
            jsonString = (String) message.getPayload();
        } catch (Exception exception) {
            throw new InvalidRequestException("Invalid Message Format");
        }

        JSONObject packet = messageToJsonObject(jsonString);
        MessageType type = MessageType.valueOf(packet.getString("messageType"));
        JSONObject data = packet.getJSONObject("data");
        BattleStateDTO dto;

        switch (type) {
            case SET_PLAYER_ONLINE:
                playerService.setPlayerOnline(data.getInt("playerId"), session.getId());
                break;
            case ADD_PLAYER:
                dto = battleService.addPlayer(new AddPlayerInBattleRequest(data), session.getId());
                sendBattleState(session, dto);
                break;
            case SET_TURN_ACTION:
                dto = battleService.setTurnActions(new TurnActionRequest(data));
                sendBattleState(session, dto);
                break;
            case SET_PLAYER_READY:
                dto = battleService.setPlayerReady(data.getInt("battleId"), data.getInt("playerId"));
                sendBattleState(session, dto);
                break;
            default:
                throw new InvalidRequestException("Message Type did not exist!");
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
        log.info("User Disconected: {}", sessionId);
        activeSessions.remove(session.getId());
        super.afterConnectionClosed(session, status);
    }

    public void sendBattleState(WebSocketSession session, BattleStateDTO dto) throws IOException, InvalidRequestException {
        if ( dto == null ) return;

        ArrayList<Player> players = dto.getPlayers();
        TextMessage response = new TextMessage(dto.toString());
        
        for (int i = 0; i < players.size(); i++) {
            var player = players.get(i);
            if ( activeSessions.containsKey(player.getSessionId())) {
                activeSessions.get(player.getSessionId()).sendMessage(response);
            } else {
                battleService.getBattleById(dto.getBattleId()).removePlayerFromBattle(player.getId());
            }
        }
    }

    private JSONObject messageToJsonObject(String packet) {
        return new JSONObject(packet);
    }
}
