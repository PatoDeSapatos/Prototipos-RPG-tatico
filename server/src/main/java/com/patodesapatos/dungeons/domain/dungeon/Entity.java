package com.patodesapatos.dungeons.domain.dungeon;

import java.util.UUID;

import org.json.JSONObject;

import lombok.Data;

@Data
public class Entity implements Cloneable {
    private String id;
    private String userId;
    private String username;
    private JSONObject data;

    public Entity(Player player) {
        this.id = UUID.randomUUID().toString();
        this.userId = player.getUserId();
        this.username = player.getUsername();
    }

    public Entity toDTO() {
        try {
            var dto = (Entity) clone();
            dto.setUserId(null);
            return dto;
        } catch (Exception e) {
            System.err.println("Entity clone not supported.");
            return null;
        }
    }
}