package com.patodesapatos.dungeons.domain.dungeon;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class Entity {
    private String id;
    private String userId;
    private String jsonValues;
}