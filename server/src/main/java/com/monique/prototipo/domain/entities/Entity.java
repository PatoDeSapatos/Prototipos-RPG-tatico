package com.monique.prototipo.domain.entities;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
public class Entity {
    private int id;
    private int sprite;
    private int playerId;
    private int x;
    private int y;
    private int oldX;
    private int oldY;

    public int getId(){
        return id;
    }
}