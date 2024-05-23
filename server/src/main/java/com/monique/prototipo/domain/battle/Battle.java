package com.monique.prototipo.domain.battle;

import java.util.ArrayList;
import java.util.concurrent.CompletableFuture;
import java.awt.event.ActionEvent;

import javax.swing.Timer;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

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
    private Timer timer = new Timer(10, this::listener);
	private ArrayList<CompletableFuture<ResponseEntity<BattleStateDTO>>> cfs = new ArrayList<>();

    public Battle(int id, Scenario scenario) {
        this.id = id;
        this.scenario = scenario;
        timer.start();
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
    }

    public BattleStateDTO toDTO() {
        return new BattleStateDTO(getTurn(), getScenario().getMap(), getEntities(), getPlayers(), isRevisedTurn());
    }

    public void listener(ActionEvent e) {
        for (int i = 0; i < cfs.size(); i++) {
            cfs.get(i).complete(new ResponseEntity<BattleStateDTO>(toDTO(), HttpStatus.OK));
        }
        cfs.clear();
    }

    public void updateEntity(Entity entity) {
        for (int i = 0; i < getEntities().size(); i++) {
            var oldEntity = getEntities().get(i);
            if (oldEntity.id() == entity.id()) {
                getEntities().remove(i);
                getEntities().add(i, entity);
            }
        }
        moveEntityInScenario(entity);
    }
}
