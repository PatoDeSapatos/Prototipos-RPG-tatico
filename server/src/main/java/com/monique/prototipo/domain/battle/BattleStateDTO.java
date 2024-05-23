package com.monique.prototipo.domain.battle;

import java.util.ArrayList;

import com.monique.prototipo.domain.entities.Entity;
import com.monique.prototipo.domain.player.Player;

public record BattleStateDTO(
    int turn,
    Entity[][] scenario,
    ArrayList<Entity> entities,
    ArrayList<Player> players,
    boolean revisedTurn
) {}