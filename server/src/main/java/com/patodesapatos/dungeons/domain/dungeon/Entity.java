package com.patodesapatos.dungeons.domain.dungeon;

import java.util.UUID;

import org.json.JSONObject;

import lombok.Data;

@Data
public class Entity {
    private String id;
    private String userId;
    private JSONObject data;

    public Entity(String userId, JSONObject JSONData) {
        this.id = UUID.randomUUID().toString();
        this.userId = userId;
        this.data = JSONData;
    }

    public Entity(String userId) {
        this.id = UUID.randomUUID().toString();
        this.userId = userId;
        this.data = defaultData();
    }

    public JSONObject defaultData() {
        var json = new JSONObject();
        json.put("x", 0);
        json.put("y", 0);
        return json;
    }
}