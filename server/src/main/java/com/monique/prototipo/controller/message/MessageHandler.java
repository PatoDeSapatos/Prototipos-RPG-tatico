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
import com.monique.prototipo.domain.entities.Entity;
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
                sendBattleState(dto);
                break;
            case SET_TURN_ACTION:
                dto = battleService.setTurnActions(new TurnActionRequest(data));
                sendBattleState(dto);
                break;
            case SET_PLAYER_READY:
                dto = battleService.setPlayerReady(data.getInt("battleId"), data.getInt("playerId"));
                sendBattleState(dto);
                break;
            case GET_BATTLE_STATE:
                dto = battleService.getBattleById(data.getInt("battleId")).toDTO();
                sendBattleState(dto);
                break;
            case SET_PLAYER_OFFLINE:
                String sesId = session.getId();
                activeSessions.remove(sesId);
                session.close();
                log.info("User Asked to Disconnect: {}", sesId);
                break;
            case RESET:
                var battle = battleService.getBattleById(data.getInt("battleId"));
                for (int i = 0; i < battle.getPlayers().size(); i++) {
                    var player = battle.getPlayers().get(i);
                    activeSessions.remove(player.getSessionId()).close();
                    battle.removePlayerFromBattle(player.getId());
                }
                battle.setEntities(new ArrayList<>());
                battle.setPlayers(new ArrayList<>());
                battle.getScenario().setMap(new Entity[5][5]);
                battle.setTurn(0);
                battle.setRevisedTurn(false);
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
        log.info("User Disconnected: {}", sessionId);
        activeSessions.remove(sessionId);
        super.afterConnectionClosed(session, status);
    }

    public void sendBattleState(BattleStateDTO dto) throws IOException, InvalidRequestException {
        if ( dto == null ) return;
        ArrayList<Player> players = dto.getPlayers();
        TextMessage response = new TextMessage(dto.toString());

        for (int i = 0; i < players.size(); i++) {
            var player = players.get(i);
            if (activeSessions.containsKey(player.getSessionId())) {
                var session = activeSessions.get(player.getSessionId());
                synchronized(session) {
                    if (session.isOpen()) { 
                        session.sendMessage(response);
                    }
                }
            } else {
                battleService.getBattleById(dto.getBattleId()).removePlayerFromBattle(player.getId());
            }
        }
    }

    private JSONObject messageToJsonObject(String packet) {
        return new JSONObject(packet);
    }
}
