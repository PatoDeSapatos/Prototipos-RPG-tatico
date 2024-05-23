package com.monique.prototipo.domain.entities;

public record Entity(
    int id,
    int sprite,
    int playerId,
    int x,
    int y,
    int oldX,
    int oldY
) {}