package com.patodesapatos.dungeons.domain.dungeon.dto;

import com.patodesapatos.dungeons.controller.MessageType;
import com.patodesapatos.dungeons.domain.WebSocketDTO;
import com.patodesapatos.dungeons.domain.dungeon.Entity;

public class InventoryDTO extends WebSocketDTO {
    
    public InventoryDTO(String id, Entity entity) {
        super(MessageType.INVENTORY, null);

        packet.put("id", id);

        if (entity != null) {
            packet.put("data", entity.getInventory());
        }
    }
}