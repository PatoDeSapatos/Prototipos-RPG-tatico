package com.monique.prototipo.domain.scenario;

import com.monique.prototipo.domain.entities.Entity;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Scenario {
    private int width;
    private int height;
    private Entity[][] map;

    public Scenario(CreateScenarioRequest size) {
        width = size.width();
        height = size.height();
        map = new Entity[width][height];
    }

    public void moveEntity(Entity entity) {
        map[entity.getOldX()][entity.getOldY()] = null;
        map[entity.getX()][entity.getY()] = entity;
    }
}