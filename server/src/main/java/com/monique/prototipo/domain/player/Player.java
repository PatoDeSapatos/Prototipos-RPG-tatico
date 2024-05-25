package com.monique.prototipo.domain.player;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
public class Player {
    private int id;
    private boolean ready;
    private String username;
    private String sessionId;

    public Player(int id, String username) {
        this.id = id;
        this.username = username;
        this.ready = false;
        this.sessionId = "";
    }
}
