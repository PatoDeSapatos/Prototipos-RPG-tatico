package com.patodesapatos.dungeons.domain.dungeon;

import org.json.JSONArray;
import org.json.JSONObject;
import org.json.JSONPropertyIgnore;

import lombok.Data;

@Data
public class Entity implements Cloneable {
    private String id;
    private String userId;
    private String username;
    private int level;
    private JSONObject data;
    private JSONArray inventory;

    public Entity(Player player, String dungeonEntitiesId) {
        id = dungeonEntitiesId;
        userId = player.getUserId();
        username = player.getUsername();
        level = 1;
    }

    public JSONObject toDTO() {
        var dto = new JSONObject(this);
        return dto;
    }

    @JSONPropertyIgnore
    public String getUserId() {
        return userId;
    }

    @JSONPropertyIgnore
    public JSONArray getInventory() {
        return inventory;
    }
}