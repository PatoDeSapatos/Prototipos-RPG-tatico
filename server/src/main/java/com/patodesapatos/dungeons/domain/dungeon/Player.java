package com.patodesapatos.dungeons.domain.dungeon;

import com.patodesapatos.dungeons.domain.user.User;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Player implements Cloneable {
    private String userId;
    private String username;
    private boolean ready;
    private boolean online;

    public Player(String userId, String username) {
        this.userId = userId;
        this.username = username;
        this.ready = false;
        this.online = true;
    }

    public Player(User user) {
        this.userId = user.getId();
        this.username = user.getUsername();
        this.ready = false;
        this.online = true;
    }

    public Player toDTO() {
        try {
            var dto = (Player) clone();
            dto.setUserId(null);
            return dto;
        } catch (Exception e) {
            System.err.println("Player clone not supported.");
            return null;
        }
    }
}
