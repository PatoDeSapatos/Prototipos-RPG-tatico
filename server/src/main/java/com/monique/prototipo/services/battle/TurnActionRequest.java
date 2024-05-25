package com.monique.prototipo.services.battle;

import java.util.ArrayList;

import org.json.JSONObject;

import com.monique.prototipo.domain.entities.Entity;

import lombok.Getter;

@Getter
public class TurnActionRequest {
    private ArrayList<Entity> entities = new ArrayList<>();
    private int playerId;
    private int battleId;

    public TurnActionRequest(JSONObject data) {
        var entitiesJSON = data.getJSONArray("entities");

        for (int i = 0; i < entitiesJSON.length(); i++) {
            entities.add(JSONObjectToEntity(entitiesJSON.getJSONObject(i)));
        }

        playerId = data.getInt("playerId");
        battleId = data.getInt("battleId");
    }

    private Entity JSONObjectToEntity(JSONObject json) {
        return new Entity(json.getInt("id"), json.getInt("sprite"), json.getInt("playerId"), json.getInt("x"), json.getInt("y"), json.getInt("oldX"), json.getInt("oldY"));
    }
}
