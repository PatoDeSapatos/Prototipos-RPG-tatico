package com.monique.prototipo.domain.battle;

import java.util.ArrayList;

import com.monique.prototipo.domain.entities.Entity;

public record TurnActionRequest( ArrayList<Entity> entities, int playerId ) {}
