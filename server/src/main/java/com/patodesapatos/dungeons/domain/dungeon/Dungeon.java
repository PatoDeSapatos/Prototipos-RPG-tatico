package com.patodesapatos.dungeons.domain.dungeon;

import java.util.ArrayList;
import java.util.UUID;

import org.apache.commons.lang3.RandomStringUtils;
import org.json.JSONObject;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
@AllArgsConstructor
public class Dungeon {
    private String id;
    private ArrayList<String> usersId;
    private ArrayList<Entity> entities;
    private String dungeonInvite;
    private boolean waiting;
    private boolean isPublic;

    public Dungeon(boolean isPublic, String userId) {
        this.id = UUID.randomUUID().toString();
        this.dungeonInvite = randomInvite();
        this.waiting = true;
        this.isPublic = isPublic;

        this.usersId = new ArrayList<>();
        this.usersId.add(userId);
    }

    public void addUserId(String userId) {
        usersId.add(userId);
    }

    public DungeonDTO ready() {
        this.waiting = false;

        for (int i = 0; i < usersId.size(); i++) {
            entities.add(new Entity(usersId.get(i)));
        }

        return toDTO();
    }

    public String randomInvite() {
        return RandomStringUtils.randomAlphanumeric(4);
    }

    public Entity getEntityById(String id) {
        for (int i = 0; i < entities.size(); i++) {
            var entity = entities.get(i);
            if (entity.getId().equals(id)) return entity;
        }
        return null;
    }

    public DungeonDTO toDTO() {
        return new DungeonDTO(this);
    }

    public void updateEntity(JSONObject data) {
        getEntityById(data.getString("entityId")).setData(data.getJSONObject("data"));
    }
}