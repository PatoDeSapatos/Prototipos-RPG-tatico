package com.monique.prototipo.domain.battle;

import java.util.ArrayList;

import com.monique.prototipo.domain.entities.Entity;
import com.monique.prototipo.domain.player.Player;
import com.monique.prototipo.domain.scenario.Scenario;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class Battle {
    private int id;
    private int turn = 0;
    private Scenario scenario;
    private boolean revisedTurn = false;
    private ArrayList<Entity> entities = new ArrayList<>();
    private ArrayList<Player> players = new ArrayList<>();

    public Battle(int id, Scenario scenario) {
        this.id = id;
        this.scenario = scenario;
    }

    public void addPlayer(Player player) {
        players.add(player);
    }

    public void addEntity(Entity entity) {
        entities.add(entity);
    }

    public void moveEntityInScenario(Entity entity) {
        scenario.moveEntity(entity);
    }

    public void nextTurn() {
        for(int i = 0; i < players.size(); i++) {
            players.get(i).setReady(false);
        }

        this.revisedTurn = false;
        this.turn++;
    
        if ( getTurn() >= getEntities().size() ) {
            setTurn(0);
        }
    }

    public BattleStateDTO toDTO() {
        return new BattleStateDTO(getTurn(), getId(), getScenario().getMap(), getEntities(), getPlayers(), isRevisedTurn());
    }

    public void updateEntity(Entity entity) {
        for (int i = 0; i < getEntities().size(); i++) {
            var oldEntity = getEntities().get(i);
            if (oldEntity.getId() == entity.getId()) {
                getEntities().remove(i);
                getEntities().add(i, entity);
            }
        }
        moveEntityInScenario(entity);
    }

    public boolean removePlayerFromBattle(int playerId) {
        for (int i = 0; i < players.size(); i++) {
            if (players.get(i).getId() == playerId) {
                players.get(i).setSessionId("");
                players.remove(i);
                break;
            }
        }
        for (int i = 0; i < entities.size(); i++) {
            if (entities.get(i).getPlayerId() == playerId) {
                scenario.removeEntity(entities.remove(i));
                return true;
            }
        }
        return false;
    }
}
