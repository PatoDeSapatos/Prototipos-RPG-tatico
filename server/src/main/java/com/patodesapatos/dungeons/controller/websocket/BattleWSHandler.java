package com.patodesapatos.dungeons.controller.websocket;

import java.util.ArrayList;

import org.json.JSONObject;
import org.springframework.web.socket.WebSocketSession;

import com.patodesapatos.dungeons.controller.MessageType;
import com.patodesapatos.dungeons.domain.WebSocketDTO;
import com.patodesapatos.dungeons.domain.battle.dto.TurnActionDTO;
import com.patodesapatos.dungeons.domain.battle.dto.UnitReadyDTO;
import com.patodesapatos.dungeons.domain.dungeon.Player;

public class BattleWSHandler {
    
    public static void handle(WebSocketController wsc, WebSocketSession session, String username, MessageType type, JSONObject data) throws Exception {
        WebSocketDTO dto;

        switch (type) {
            /**
             * data: {
             *      invite,
             *      units: Unit[],
             *      eUnits: EnemyUnit[],
             *      room: {
             *          x: int,
             *          y: int     
             *      }
             * }
             */
            case BATTLE_START:
                var dungeon = wsc.dungeonService.getAll().get(0); //TODO: by invite

                var players = new ArrayList<Player>();
                var units = data.getJSONArray("units");

                for (int i = 0; i < units.length(); i++) {
                    var unit = units.getJSONObject(i);
                    var player = dungeon.getPlayerByUsername(unit.getString("username"));
                    if (player != null && !players.contains(player)) players.add(player);
                }

                dto = dungeon.createBattle(data.getJSONObject("room"), players, units, data.getJSONArray("eUnits"));
                wsc.sendDTOtoAllPlayers(dto, data);
                break;
            /**
             * data: {
             *      invite,
             *      id,
             *      units: Unit[]
             * }
             */
            case JOIN_BATTLE:
                dungeon = wsc.dungeonService.getAll().get(0); //TODO: by invite
                var player = dungeon.getPlayerByUsername(username);

                var battle = dungeon.getBattles().get(0); //TODO: by id

                if (battle.add(player, data.getJSONArray("units"))) {
                    wsc.sendDTO(battle.toStartDTO(), session);
                    wsc.sendDTOtoAllPlayers(battle.toDTO(), data, session.getId());
                }
                break;
            /**
             * data: {
             *      invite,
             *      battleId,
             *      actions: Action[]
             * }
             */
            case TURN_ACTION:
                dto = new TurnActionDTO(data.getInt("battleId"), data.getJSONArray("actions"));
                wsc.sendDTOtoAllPlayers(dto, data, session.getId());
                break;
            /**
             * data: {
             *      invite,
             *      battleId,
             *      unitId
             * }
             */
            case UNIT_READY:
                dto = new UnitReadyDTO(data.getInt("battleId"), data.getInt("unitId"));
                wsc.sendDTOtoAllPlayers(dto, data, session.getId());
                break;
            /**
             * data: {
             *      invite,
             *      battleId
             * }
             */
            case BATTLE_END:
                dungeon = wsc.dungeonService.getDungeonByInvite(data.getString("invite"));
                dungeon.endBattle(data.getInt("battleId"));
                break;
            default:
                throw new Exception("Message Type: '" + type + "' not accepted! (Battle Handler)");
        }
    }
}