package com.monique.prototipo.domain.battle;

import java.util.ArrayList;

import org.json.JSONObject;

import com.monique.prototipo.domain.entities.Entity;
import com.monique.prototipo.domain.player.Player;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class BattleStateDTO {
    private int turn;
    private int battleId;
    private Entity[][] scenario;
    private ArrayList<Entity> entities;
    private ArrayList<Player> players;
    private boolean revisedTurn;
    
    @Override
    public String toString() {
        JSONObject json = new JSONObject();
        json.put("turn", turn);
        json.put("battleId", battleId);
        json.put("scenario", scenario);
        json.put("entities", new ArrayList<>(entities));
        json.put("revisedTurn", revisedTurn);
        return json.toString();
    }
}