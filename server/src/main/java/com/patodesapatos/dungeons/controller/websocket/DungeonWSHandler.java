package com.patodesapatos.dungeons.controller.websocket;

import org.json.JSONObject;
import org.springframework.web.socket.WebSocketSession;

import com.patodesapatos.dungeons.controller.MessageType;
import com.patodesapatos.dungeons.domain.WebSocketDTO;

public class DungeonWSHandler {
    
    public static void handle(WebSocketController wsc, WebSocketSession session, String username, MessageType type, JSONObject data) throws Exception {
        WebSocketDTO dto;

        switch (type) {
            /**
             * return: WaitingDTO
             */
            case CREATE_DUNGEON:
                dto = wsc.dungeonService.createDungeon(username, session);
                wsc.sendDTO(dto, session);
                break;
            /**
             * data: {
             *      invite
             * }
             * return: WaitingDTO to everyone if the dungeon isn't started | DungeonDTO to everyone if dungeon is started UNLESS the joining player
             */
            case JOIN_DUNGEON:
                var dungeon = wsc.dungeonService.joinDungeon(data.getString("invite"), username, session);
                if (!dungeon.isStarted()) {
                    wsc.sendDTOtoAllPlayers(dungeon.toWaitingDTO(), data);
                } else {
                    wsc.sendDTO(dungeon.toWaitingDTO(), session);
                    wsc.sendDTOtoAllPlayers(dungeon.toDTO(), data, session.getId());
                }
                break;
            /**
             * data: {
             *      invite
             * }
             * return: DungeonDTO
             */
            case DUNGEON_STATE:
                dungeon = wsc.dungeonService.getDungeonByInvite(data.getString("invite"));
                var entity = dungeon.getEntityByUsername(username);

                dto = dungeon.toDTO(entity);
                wsc.sendDTO(dto, session);
                break;
            /**
             * data: {
             *      invite,
             *      entityId,
             *      data: {
             *          ...EntityData
             *      }
             * }
             * return: DungeonDTO
             */
            case UPDATE_ENTITY:
                dto = wsc.dungeonService.updateEntity(data);
                wsc.sendDTO(dto, session);
                break;
            /**
             * data: {
             *      invite,
             *      type,
             *      content
             * }
             * return: ChatMessage
             */
            case SEND_CHAT_MESSAGE:
                data.put("sender", username);
                wsc.sendChat(data);
                break;
            /**
             * data: {
             *      invite
             * }
             */
            case SET_PLAYER_READY:
                dto = wsc.dungeonService.setPlayerReady(data.getString("invite"), username);
                wsc.sendDTOtoAllPlayers(dto, data);
                break;
            /**
             * data: {
             *      invite,
             *      entityId,
             *      level
             * }
             */
            case CHANGE_LEVEL:
                dungeon = wsc.dungeonService.getDungeonByInvite(data.getString("invite"));

                entity = dungeon.getEntityById(data.getString("entityId"));
                entity.setLevel(data.getInt("level"));

                dto = dungeon.toDTO(entity);
                wsc.sendDTO(dto, session);
                break;
            case GET_WAITING_STATE:
                dto = wsc.dungeonService.getDungeonByInvite(data.getString("invite")).toWaitingDTO();
                wsc.sendDTO(dto, session);
                break;
            case CHANGE_DUNGEON_PRIVACY:
                dto = wsc.dungeonService.changeDungeonPrivacy(data.getString("invite"), username);
                wsc.sendDTOtoAllPlayers(dto, data);
                break;
            case LEAVE_DUNGEON:
                dto = wsc.dungeonService.leaveDungeon(data.getString("invite"), username);
                if (dto != null) wsc.sendDTOtoAllPlayers(dto, data);
                break;
            /**
             * data: {
             *      invite,
             *      tileEntId
             * }
             * return TileEntityDTO
             */
            case GET_TILE_ENTITY:
                dto = wsc.dungeonService.getTileEntity(data);
                wsc.sendDTO(dto, session);
                break;
            /**
             * data: {
             *      invite,
             *      tileEntId,
             *      data
             * }
             */
            case ADD_TILE_ENTITY:
                wsc.dungeonService.addTileEntity(data);
                break;
            /**
             * data: {
             *      invite,
             *      entityId,
             *      inventory: Item[]
             * }
             */
            case UPDATE_INVENTORY:
                System.out.println(data.toString());
                wsc.dungeonService.updateInventory(data);
                break;
            /**
             * data: {
             *      invite,
             *      entityId
             * }
             * return: InventoryDTO
             */
            case GET_INVENTORY:
                dto = wsc.dungeonService.getInventory(data);
                wsc.sendDTO(dto, session);
                break;
            default:
                throw new Exception("Message Type: '" + type + "' not accepted! (Dungeon Handler)");
        }
    }
}
